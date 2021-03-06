# to clean in cron removing ports where last < Time.now - 400.days
# for my hp procurve switches
#                ".1.3.6.1.2.1.17.4.3.1.2.0.0.116.144.162.19 = INTEGER: 50\n"
REGEXP_MAC_PORT = /(\d+?).(\d+?).(\d+?).(\d+?).(\d+?).(\d+?) = INTEGER: (\d+)?/

require 'snmp'

namespace :nms_on_rails do
  namespace :snmp do
    desc "Snmpwalk switches"
    task switches: :environment do
      debug = false
      Switch.all.each do |switch|
        puts "Trying with #{switch.inspect}" if debug
        # in my hp procurve last two ports are not end ports
        max_interesting_port_number = switch.number_of_ports - 2
        hostname = switch.hostname
        clean_ip = Ip.clean!(switch.ip)

        shell_command = "snmpwalk -On -v 2c -c #{switch.community} #{clean_ip} BRIDGE-MIB::dot1dTpFdbPort"
        debug and p shell_command

        IO.popen(shell_command).readlines.each do |line|
          #<MatchData "0.0.116.144.169.166 = INTEGER: 20" 1:"0" 2:"0" 3:"116" 4:"144" 5:"169" 6:"166" 7:"20">
          match_mac_port = REGEXP_MAC_PORT.match(line) or raise line
          port_number = match_mac_port[7].to_i
          next unless (port_number > 0 and port_number <= max_interesting_port_number)
          mac = sprintf("%x:%x:%x:%x:%x:%x", match_mac_port[1], match_mac_port[2], match_mac_port[3], match_mac_port[4], match_mac_port[5], match_mac_port[6])

          # must be already in database (via switch we don't get the ip)
          arp = Arp.where(mac: mac).first
          (puts "Missing #{mac}" and next) unless arp
          # if already in same switch/port
          port = switch.ports.where(port: port_number).where(mac: mac).first

          if port
            port.update_attribute(:last, Time.now) 
          else
            puts "create in #{switch.name} port #{port_number}" if debug
            Port.create!(switch_id: switch.id, port: port_number, mac: mac, start: Time.now, last: Time.now)
          end
        end
      end
    end

    desc "Read printers with snmp"
    task printers: :environment do
      Info.actual_printers.includes(:ip).each do |i|
        ip = i.ip
        # https://github.com/hallidave/ruby-snmp/blob/master/lib/snmp/manager.rb
        SNMP::Manager.open(host: ip.ip, retries: 0) do |manager|
          response = manager.get([
            '1.3.6.1.2.1.1.5.0', 
            '1.3.6.1.2.1.25.3.2.1.3.1'
          ])
          fact = ip.fact || ip.build_fact
          response.each_varbind do |vb|
            case vb.name.to_s
            when 'SNMPv2-MIB::sysName.0'
              fact.host = vb.value
            when 'SNMPv2-SMI::mib-2.25.3.2.1.3.1'
              fact.productname = vb.value
            end
          end
          p ip
          fact.save!
          p fact.host
          p fact.productname
          puts "\n-----------------------"
        rescue SNMP::RequestTimeout
        end
      end
    end

    desc "Read switches infos with snmp"
    task switches_info: :environment do
      Switch.find_each do |s|
        SNMP::Manager.open(host: s.ip, community: s.community, retries: 0) do |manager|
          response = manager.get('1.3.6.1.2.1.1.1.0')
          # only first
          response.each_varbind do |vb|
            p vb.value
            s.update_attribute(:model, vb.value)
          end
        rescue SNMP::RequestTimeout
        end
      end
    end
  end
end

# .1.3.6.1.2.1.1.5.0 = STRING: "lp-segsci-color"
# .1.3.6.1.2.1.1.5.0 = STRING: "lp-tecnici.dm.unibo.it"
# .1.3.6.1.2.1.1.6.0 = STRING: "Sala Prestiti"
# .1.3.6.1.2.1.2.2.1.6.1 = Hex-STRING: 00 17 C8 6B D2 1E 
# .1.3.6.1.2.1.4.20.1.1.137.204.135.244 = IpAddress: 137.204.135.244
#  .1.3.6.1.2.1.25.3.2.1.3.1 = STRING: "ECOSYS P3050dn"
#  .1.3.6.1.2.1.25.3.2.1.3.1 = STRING: "EPSON WF-8090 Series"


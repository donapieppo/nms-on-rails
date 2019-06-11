# to clean in cron removing ports where last < Time.now - 400.days
# for my hp procurve switches
#                ".1.3.6.1.2.1.17.4.3.1.2.0.0.116.144.162.19 = INTEGER: 50\n"
REGEXP_MAC_PORT = /(\d+?).(\d+?).(\d+?).(\d+?).(\d+?).(\d+?) = INTEGER: (\d+)?/

namespace :nms_on_rails do
namespace :snmp do
  desc "Snmpwalk switches"
  task snmpwalk: :environment do
    debug = true
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
end
end

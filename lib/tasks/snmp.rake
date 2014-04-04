namespace :NmsOnRails do
namespace :snmp do
  def number_of_ports(ip, community)
    clean_ip = Ip.clean!(ip)
    shell_command = "snmpwalk -On -v 2c -c #{community} #{clean_ip} .1.3.6.1.2.1.17.2.7.0"
    line = IO.popen(shell_command).readline
    line =~ /.1.3.6.1.2.1.17.2.7.0 = INTEGER: (\d+)/ or raise "wrong format for number of port in switch" + line
    $1.to_i
  end

  def device_hostname(ip, community)
    clean_ip = Ip.clean!(ip)
    shell_command = "snmpwalk -On -v 2c -c #{community} #{clean_ip} .1.3.6.1.2.1.1.5.0"
    line = IO.popen(shell_command).readline
    # switch.1.3.6.1.2.1.1.5.0 = STRING: "dm11"
    line =~ /.1.3.6.1.2.1.1.5.0 = STRING: "(\w+)"/ or raise "wrong format for name in switch" + line
    $1
  end

  desc "Snmpwalk switches"
  task :snmpwalk => :environment do
    Switch.all.each do |switch|
      # puts "query to #{switch.name}"
      # in my hp procurve last two ports are not end ports
      max_interesting_port_number = number_of_ports(switch.ip, switch.community) - 2
      hostname = device_hostname(switch.ip, switch.community)
      clean_ip = Ip.clean!(switch.ip)
      shell_command = "snmpwalk -On -v 2c -c #{switch.community} #{clean_ip} BRIDGE-MIB::dot1dTpFdbPort"
      IO.popen(shell_command).readlines.each do |line|
        # ".1.3.6.1.2.1.17.4.3.1.2.0.0.116.144.162.19 = INTEGER: 50\n"
        line =~ /(\d+?).(\d+?).(\d+?).(\d+?).(\d+?).(\d+?) = INTEGER: (\d+)?/ or raise line
        port_number = $7.to_i
        next unless (port_number > 0 and port_number <= max_interesting_port_number)
        mac = sprintf("%x:%x:%x:%x:%x:%x", $1, $2, $3, $4, $5, $6)
        
        # must be already in database
        next unless arp = Arp.where(:mac => mac).first
        # if already in same switch/port
        port = Port.where(:switch_id => switch.id).where(:port => port_number).where(:mac => mac).first
        
        if port
          port.update_attribute(:last, Time.now) 
        else
          # puts "create in #{switch.name} port #{port_number}"
          Port.create!(:switch_id => switch.id, :port => port_number, :mac => mac, :start => Time.now, :last => Time.now)
        end
      end
    end
  end
end
end

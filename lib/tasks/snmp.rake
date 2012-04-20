namespace :NmsOnRails do
namespace :snmp do
  def number_of_ports(ip, community)
    clean_ip = Ip.clean!(ip)
    shell_command = "snmpwalk -On -v 2c -c #{community} #{clean_ip} .1.3.6.1.2.1.17.2.7.0"
    line = IO.popen(shell_command).readline
    line =~ /.1.3.6.1.2.1.17.2.7.0 = INTEGER: (\d+)/ or raise "wrong format for number of port in switch"
    $1.to_i
  end

  def device_hostname(ip, community)
    clean_ip = Ip.clean!(ip)
    shell_command = "snmpwalk -On -v 2c -c #{community} #{clean_ip} .1.3.6.1.2.1.1.5.0"
    line = IO.popen(shell_command).readline
    line =~ /.1.3.6.1.2.1.1.5.0 = STRING: (\w+)/ or raise "wrong format for name in switch"
    $1
  end

  desc "Snmpwalk switches"
  task :snmpwalk => :environment do
    Switch.all.each do |switch|
      max_interesting_port_number = number_of_ports(switch.ip, switch.community) - 2
      hostname = device_hostname(switch.ip, switch.community)
      clean_ip = Ip.clean!(switch.ip)
      shell_command = "snmpwalk -On -v 2c -c #{switch.community} #{clean_ip} BRIDGE-MIB::dot1dTpFdbPort"
      IO.popen(shell_command).readlines.each do |line|
        line =~ /(\d+?).(\d+?).(\d+?).(\d+?).(\d+?).(\d+?) = INTEGER: (\d+)?/ or raise line
        port_number = $7.to_i
        next unless (port_number > 0 and port_number <= max_interesting_port_number)
        mac = sprintf("%x:%x:%x:%x:%x:%x", $1, $2, $3, $4, $5, $6)
        port = Port.where(:switch_id => switch.id).where(:port => port_number).order('date desc').first
        next if (port and port.mac == mac)
        p Port.create!(:switch_id => switch.id, :port => port_number, :mac => mac, :date => Time.now)
      end
    end
  end
end
end

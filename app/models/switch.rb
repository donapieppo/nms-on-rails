class Switch < ActiveRecord::Base
  has_many :ports

  def number_of_ports
    clean_ip = Ip.clean!(self.ip)
    shell_command = "snmpwalk -On -v 2c -c #{self.community} #{clean_ip} .1.3.6.1.2.1.17.2.7.0"
    line = IO.popen(shell_command).readline
    line =~ /.1.3.6.1.2.1.17.2.7.0 = INTEGER: (\d+)/ or raise "wrong format for number of port in switch"
    $1.to_i
  end
  
end

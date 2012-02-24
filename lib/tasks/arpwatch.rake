require 'puppet'

namespace :NmsOnRails do
  def read_arpfile(file)
    debug = 1 
    File.open(file, "r").each do |line|
      mac_address, ip_address, last_time = line.split(%r{\s+})
      ip = Ip.find_by_ip(ip_address) or next

      # last arp in database with current ip
      arp = ip.arps.where(:mac => mac_address).order("date DESC").first
      if arp
        if arp.date.to_i < last_time.to_i
          debug == 1 and puts "updating \t#{ip.ip}\t#{arp.mac}\t#{last_time}"
          arp.update_attribute(:date, Time.at(last_time.to_i))
          ip.update_last_arp
        end
      else
        debug == 1 and puts "adding \t" + ip.ip + "\t" + mac_address + "\t" + last_time
        arp = ip.arps.create!(:mac => mac_address, :date => Time.at(last_time.to_i))
        ip.update_last_arp
      end
    end
  end

  desc "Load times from arpwatch"
  task :arpwatch => :environment do
    read_arpfile('/home/rails/rete/doc/arp_ciram.dat')
    read_arpfile('/var/lib/arpwatch/arp.dat')
  end
end


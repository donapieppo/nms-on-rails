# ex from arpwatch 
# 00:d8:61:30:5f:f3 137.204.1.1 1557829916    eth0
namespace :nms_on_rails do
  def read_arpfile(file)
    debug = false
    puts "opening #{file}" if debug
    File.open(file, "r").each do |line|
      mac_address, ip_address, last_time = line.split
      ip = Ip.find_by_ip(ip_address) or next

      # last arp in database with current ip
      arp = ip.arps.where(mac: mac_address).order("date DESC").first

      if arp
        if arp.date.to_i < last_time.to_i
          puts "updating \t#{ip.ip}\t#{arp.mac}\t#{last_time}" if debug
          arp.update_attribute(:date, Time.at(last_time.to_i))
        end
      else
        puts "adding #{mac_address}:#{last_time} to #{ip.ip}" if debug
        arp = ip.arps.create!(mac: mac_address, date: Time.at(last_time.to_i))
      end
      ip.update_last_arp
    end
  end

  desc "Load times from arpwatch"
  task arpwatch: :environment do
    NmsOnRails::Application.config.arpwatch_files.each do |file|
      read_arpfile(file) if File.exist?(file)
    end
  end
end


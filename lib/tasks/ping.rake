# FIXME 
# using net/ping requires root provileges...
namespace :NmsOnRails do
  desc "Notify requested pingable pc"
  task :ping => :environment do
    Ip.where(:notify => true).includes(:info).all.each do |ip|
      clean_ip = ip.ip
      clean_ip =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ or raise "wrong ip format #{ip.inspect}"
      `ping -q -c 1 #{clean_ip}`
      if ($?.exitstatus == 0)
        if (ip.info)
          puts "Device #{ip.ip} #{ip.info.name} (#{ip.info.comment}) is up!"
        else
          puts "Device senza info #{ip.ip} is up!"
        end
        ip.update_attribute(:notify, false)
      end
      sleep 1
    end
  end
end


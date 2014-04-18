# FIXME 
# using net/ping requires root provileges...
namespace :NmsOnRails do
  desc "Notify requested pingable pc"
  task :ping => :environment do
    Ip.where(:notify => true).includes(:info).each do |ip|
      `ping -q -c 1 #{ip.clean_ip}`
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


require 'resolv'

namespace :NmsOnRails do
  desc "notify requested pingable ips"
  task :ping => :environment do
    Ip.where(:notify => true).includes(:info).all.each do |ip|
     `ping -q -c 1 #{ip.ip}`
     if ($?.exitstatus == 0) 
       if (ip.info)
         puts "Device #{ip.ip} #{ip.info.name} (#{ip.info.comment}) is up!"
       else
         puts "Device senza info #{ip.ip} is up!"
       end
       ip.update_attribute(:notify, false)
     end
     sleep 2
    end
  end
end


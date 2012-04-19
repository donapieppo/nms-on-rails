require 'resolv'

namespace :NmsOnRails do
  desc "notify active ips withot info"
  task :active_with_no_name => :environment do
    Ip.includes(:info).where('infos.name' => nil).includes(:arp).where('arps.date > ADDDATE(NOW(), INTERVAL -20 DAY)').each do |ip|

      p ip
      p ip.info
    end
  end
end


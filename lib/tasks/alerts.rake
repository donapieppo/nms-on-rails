require 'resolv'

namespace :nms_on_rails do

  desc "Notify active ips without info"
  task active_with_no_name: :environment do
    Ip.includes(:info).where('infos.name' => nil).includes(:arp).where('arps.date > ADDDATE(NOW(), INTERVAL -20 DAY)').each do |ip|
      puts "No information on #{ip.ip} with last mac #{ip.last_arp.mac}"
    end
  end

end


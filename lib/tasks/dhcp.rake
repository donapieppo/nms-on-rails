def clear_mac(m)
  m.split(':').map{|i| i.size < 2 ? "0#{i}" : i}.join(':')
end

namespace :nms_on_rails do
namespace :dhcp do
  desc "Read dhcp ips"
  task update: :environment do
    debug = true
    DHCP_REGEXP = Regexp.new '\Ahost (\S+) { hardware ethernet (\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}+:\w{1,2}); fixed-address (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3});'
    NmsOnRails::Application.config.dhcp_files.each do |f|
      File.open(f).each do |l|
        # host lp-amm05 { hardware ethernet 0:c0:ee:8f:be:65; fixed-address 137.204.135.235; }
        m = DHCP_REGEXP.match(l) or raise "Wrong dhcp line #{l}"
        mac = m[2] 
        ip = Ip.find_by_ip(m[3]) or raise "Ip #{m[3]} not found"
        arp = ip.last_arp
        if clear_mac(mac) != clear_mac(arp.mac)
          p l
          p arp.mac
        end
      end
    end
  end
end
end

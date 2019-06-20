require 'resolv'

namespace :nms_on_rails do
namespace :dns do
  desc "Read DNS direct"
  task update: :environment do
    debug = false
    # to be filled with ip as key and name as value
    # TODO CNAMES or multiple domain name for single ip
    dns = Hash.new
    # read only requested domains
    NmsOnRails::Application.config.dns_domains.each do |domain, server|
      # FIMXE clear domain name. Important because used in in bash script
      NmsOnRails::REGEXP_FOR_DOMAIN.match(domain.downcase) or raise "Wrong dns domain name #{domain} in configuration"
      NmsOnRails::REGEXP_FOR_IP.match(server) or raise "Wrong server name ip #{server} in configuration"
      puts "Asking @#{server} #{domain} axfr"
      IO.popen("/usr/bin/dig @#{server} #{domain} axfr").each do |line|
        NmsOnRails::REGEXP_FOR_HOST_ENTRY.match(line) or next
        dns[$2] = $1 unless $1.blank?
      end
    end

    Ip.includes(:info).each do |ip|
      # if has info we update (even with null)
      if ip.info
        ip.info.update_attribute(:dnsname, dns[ip.ip])
        puts "updated #{ip.ip} with #{dns[ip.ip]}" if debug
      elsif dns[ip.ip]
        ip.infos.create!(dnsname: dns[ip.ip])
        puts "created info for #{ip.ip} with #{dns[ip.ip]}" if debug
      end
    end
  end

  desc "Read DNS reverse"
  task update_reverse: :environment do
    res = Resolv.new()
    Info.all.each do |info|
      sleep 1
      begin
        thisname = res.getname(info.ip.ip)
      rescue
        next
      end
      (thisname == info.dnsname) and next
      puts "Check #{thisname} in place of #{info.dnsname}"
      # info.dnsname = thisname
      # info.save
    end
  end
end
end

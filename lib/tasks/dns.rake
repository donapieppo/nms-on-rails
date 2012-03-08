require 'resolv'

namespace :NmsOnRails do
  desc "Read DNS direct"
  task :dns => :environment do
    # to be filled with ip as key and name as value
    # TODO CNAMES or multiple domain name for single ip
    dns = Hash.new
    # read only requested domains
    NmsOnRails::Application.config.dns_domains.each do |domain, server|
      # FIMXE clear domain name. Important because used in in bash script
      clear_domain = domain.downcase
      clear_domain =~ /^(([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\.)*([a-z]|[a-z][a-z0-9\-]*[a-z0-9])$/ or raise "Wrong dns domain name #{domain} in configuration"
      server =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ or raise "Wrong server name ip #{server} in configuration"
      IO.popen("/usr/bin/dig @#{server} #{clear_domain} axfr").each do |line|
        line =~ /^(.*?)\s+\d+\s+IN\s+A\s+(\d+\.\d+\.\d+\.\d+)/ or next
        dns[$2] = $1 unless $1.blank?
      end
    end

    Ip.includes(:info).all.each do |ip|
      ip.info or next
      ip.info.update_attribute(:dnsname, dns[ip.ip])
      puts "updated #{ip.ip} with #{dns[ip.ip]}"
    end
  end

  desc "Read DNS reverse"
  task :dns2 => :environment do
    res = Resolv.new()
    # FIXME solo ultimi
    Info.find(:all).each do |info|
      sleep 1
      begin
        thisname = res.getname(info.ip.ip)
      rescue
        next
      end
      (thisname == info.dnsname) and next
      puts "#{thisname} in place of #{info.dnsname}"
      info.dnsname = thisname
      info.save
    end
  end
end


require 'resolv'

# example.com
REGEXP_FOR_DOMAIN = Regexp.new '\A(([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\.)*([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\z/'
# tester.example.com. 39600 IN  A 137.204.134.31
REGEXP_FOR_HOST   = Regexp.new '\A(.*?)\s+\d+\s+IN\s+A\s+(\d+\.\d+\.\d+\.\d+)'

namespace :NmsOnRails do
namespace :dns do
  desc "Read DNS direct"
  task :update => :environment do
    # to be filled with ip as key and name as value
    # TODO CNAMES or multiple domain name for single ip
    dns = Hash.new
    # read only requested domains
    NmsOnRails::Application.config.dns_domains.each do |domain, server|
      # FIMXE clear domain name. Important because used in in bash script
      clear_domain = domain.downcase
      clear_domain =~ /\A(([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\.)*([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\z/ or raise "Wrong dns domain name #{domain} in configuration"
      REGEXP_FOR_DOMAIN.match(server) or raise "Wrong server name ip #{server} in configuration"
      puts "Asking @#{server} #{clear_domain} axfr"
      IO.popen("/usr/bin/dig @#{server} #{clear_domain} axfr").each do |line|
        REGEXP_FOR_HOST.match(line) or next
        dns[$2] = $1 unless $1.blank?
      end
    end

    Ip.includes(:info).each do |ip|
      # if has info we update (even with null)
      if ip.info
        ip.info.update_attribute(:dnsname, dns[ip.ip])
        puts "updated #{ip.ip} with #{dns[ip.ip]}"
      elsif dns[ip.ip]
        Info.create!(:ip_id => ip.id, :dnsname => dns[ip.ip])
        puts "created info for #{ip.ip} with #{dns[ip.ip]}"
      end
    end
  end

  desc "Read DNS reverse"
  task :update_reverse => :environment do
    res = Resolv.new()
    Info.all.each do |info|
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
end

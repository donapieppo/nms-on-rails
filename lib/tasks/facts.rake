# require 'puppet'

namespace :NmsOnRails do
  namespace :facts do

    desc "Load facts from yams"
    task :load => :environment do
      # FIXME (now start from clean database)
      ActiveRecord::Base.connection.instance_variable_get(:@connection).query("DELETE FROM facts")
      Dir[NmsOnRails::Application.config.facts_dir + "/*.yaml"].each do |file|
        a = YAML::load_file(file)
        yaml_ip = a.values['ipaddress_eth0'].blank? ? a.values['ipaddress'] : a.values['ipaddress_eth0']
        if ip = Ip.where(:ip => yaml_ip).first
          fact = ip.fact || ip.build_fact
          fact.processor      = a.values['processor0']
          fact.processorcount = a.values['processorcount']
          fact.lsbdistrelease = a.values['lsbdistrelease']
          fact.lsbdistid      = a.values['lsbdistid']
          fact.kernelrelease  = a.values['kernelrelease']
          fact.date           = a.values[:_timestamp]
          # memorysize: 1.97 GB
          # memorysize: 874.00 MB
          a.values['memorysize'] =~ /(\d+\.?\d*)\s(\w\w)/ or raise "memorysize=#{a.values['memorysize']}"
          fact.memorysize = ($2 == 'GB') ? ($1.to_f * 1024) : $1
          fact.save!
        else
          puts "Missing '%40s' with eth0 '%15s'" % [a.name, a.values['ipaddress_eth0']]
        end
      end
    end
  end
end

#<Puppet::Node::Facts:0x7f932f4aca30 @name="nap.pippo.com", 
#  @values={"swapfree"=>"1.86 GB", 
#           "processorcount"=>"2", 
#           "kernel"=>"Linux", 
#           "netmask"=>"255.255.255.0", 
#           "uniqueid"=>"cc89cf86", 
#           "operatingsystemrelease"=>"5.0.8", 
#           "fqdn"=>"nap.pippo.com", 
#           "lsbmajdistrelease"=>"5", 
#           "clientversion"=>"0.24.5", 
#           "memorysize"=>"985.95 MB", 
#           "virtual"=>"physical", 
#           :_timestamp=>Wed Mar 16 15:38:44 +0100 2011, 
#           "hardwaremodel"=>"i686", 
#           "kernelrelease"=>"2.6.26-2-686", 
#           "domain"=>"dm.pippo.com", 
#           "netmask_eth0"=>"255.255.255.0", 
#           "id"=>"root", 
#           "type"=>"Unknown", 
#           "hardwareisa"=>"unknown", 
#           "lsbdistrelease"=>"5.0.8", 
#           "processor0"=>"Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz",
#           "memoryfree"=>"490.70 MB",
#           "interfaces"=>"eth0", 
#           "lsbdistdescription"=>"Debian GNU/Linux 5.0.8 (lenny)", 
#           "kernelversion"=>"2.6.26", 
#           "processor1"=>"Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz", 
#           "lsbdistcodename"=>"lenny", 
#           "puppetversion"=>"0.24.5", 
#           "hostname"=>"nap", 
#           "ipaddress_eth0"=>"192.204.134.207", 
#           "macaddress_eth0"=>"00:16:76:d6:78:b0", 
#           "facterversion"=>"1.5.1", 
#           "ipaddress"=>"192.204.134.207", 
#           "macaddress"=>"00:16:76:d6:78:b0", 
#           "swapsize"=>"1.86 GB", 
#           "operatingsystem"=>"Debian", 
#           "rubyversion"=>"1.8.7", 
#           "lsbdistid"=>"Debian", 
#           "architecture"=>"i386"



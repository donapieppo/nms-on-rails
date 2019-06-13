require 'msgpack'

namespace :nms_on_rails do
  namespace :facts do

    desc "Load facts from yams"
    task load: :environment do
      # FIXME (now start from clean database)
      ActiveRecord::Base.connection.instance_variable_get(:@connection).query("DELETE FROM facts")
      Dir.glob(NmsOnRails::Application.config.facts_dir + '/*/data.p') do |file|
        File.open(file) do |io|
          u = MessagePack::Unpacker.new(io)
          u.each do |obj|
            grains = obj['grains']
            _ip = grains['ipv4'][1]
            if ip = Ip.where(ip: _ip).first
              fact = ip.fact || ip.build_fact
              fact.host           = grains['host']
              fact.ssd            = grains['SSDs'].to_s
              fact.productname    = grains['productname']
              fact.processor      = grains['cpu_model']
              fact.processorcount = grains['num_cpus']
              fact.lsbdistrelease = grains['lsb_distrib_release']
              fact.lsbdistid      = grains['osrelease']
              fact.kernelrelease  = grains['kernelrelease']
              fact.date           = grains[:_timestamp]
              fact.memorysize     = grains['mem_total']
              fact.save!
            else
              puts "Missing '%40s' with eth0 '%15s'" % [grains['host'], grains['ipv4']]
            end
          end
        end
      end
    end
  end
end

# {"grains"=>
#  { "biosversion"=>"2.11.0", 
#    "kernel"=>"Linux", 
#    "domain"=>"dm.unibo.it"
#     "kernelrelease"=>"4.9.0-9-amd64"
#     "serialnumber"=>"JXL7CS2"
#     "ip_interfaces"=>{"lo"=>["127.0.0.1", "::1"], "enp0s31f6"=>["137.204.134.52"]}
#     "mem_total"=>32071 
#     "host"=>"str963-fablil"
#     "SSDs"=>["nvme0n1"]
#     "id"=>"str963-fablil"
#     "osrelease"=>"9.9"
#     "uuid"=>"4c4c4544-0058-4c10-8037-cac04f435332"
#     "num_cpus"=>8, 
#     "hwaddr_interfaces"=>{"lo"=>"00:00:00:00:00:00", "enp0s31f6"=>"54:bf:64:7f:f4:5b"}
#     "ip6_interfaces"=>{"lo"=>["::1"], "enp0s31f6"=>[]}, 
#     "ip4_interfaces"=>{"lo"=>["127.0.0.1"], "enp0s31f6"=>["137.204.134.52"]}, 
#     "lsb_distrib_description"=>"Debian GNU/Linux 9.9 (stretch)"
#     "osfullname"=>"Debian"
#     "ipv4"=>["127.0.0.1", "137.204.134.52"], 
#     "dns"=>{"domain"=>"dm.unibo.it"
#             "sortlist"=>[]
#             "nameservers"=>["137.204.25.213", "137.204.25.77", "137.204.25.71"], 
#             "ip4_nameservers"=>["137.204.25.213", "137.204.25.77", "137.204.25.71"], 
#             "search"=>["dm.unibo.it"], 
#             "ip6_nameservers"=>[], 
#             "options"=>[]}, 
#     "ipv6"=>["::1"]
#     "localhost"=>"str963-fablil"
#     "lsb_distrib_id"=>"Debian"
#     "username"=>"root"
#     "fqdn_ip4"=>["137.204.134.52"], 
#     "nodename"=>"str963-fablil"
#     "lsb_distrib_release"=>"9.9"
#     "server_id"=>1186780619, 
#     "osmajorrelease"=>"9"
#     "os_family"=>"Debian"
#     "oscodename"=>"stretch"
#     "osfinger"=>"Debian-9"
#     "num_gpus"=>1, 
#     "disks"=>["sdb", "sr0", "sda"], 
#     "cpu_model"=>"Intel(R) Xeon(R) CPU E3-1245 v5 @ 3.50GHz"
#     "fqdn"=>"str963-fablil.dm.unibo.it"
#     "biosreleasedate"=>"07/18/2018"
#     "productname"=>"Precision Tower 3620"
#     "osarch"=>"amd64"
#     "cpuarch"=>"x86_64"
#     "lsb_distrib_codename"=>"stretch"
#     "osrelease_info"=>[9, 9]
#     "locale_info"=>{"detectedencoding"=>"UTF-8"
#                     "defaultlanguage"=>"it_IT"
#                     "defaultencoding"=>"UTF-8"}, 
#     "gpus"=>[{"model"=>"HD Graphics P530", "vendor"=>"intel"}], 
#

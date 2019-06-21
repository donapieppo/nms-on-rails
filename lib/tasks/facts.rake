require 'msgpack'

def get_ip_from_grains(grains)
  # if ip not in /etc/hosts it is 127.0.1.1
  ip = grains['fqdn_ip4'].first
  if ip == '127.0.0.1' or ip == '127.0.1.1'
    grains["ip4_interfaces"].each do |interface, _ip|
      next if interface == 'lo'
      ip = _ip
    end
  end
  return ip
end

namespace :nms_on_rails do
  namespace :facts do

    desc "Load facts from yams"
    task load: :environment do
      ActiveRecord::Base.connection.instance_variable_get(:@connection).query("DELETE FROM facts")
      Dir.glob(NmsOnRails::Application.config.facts_dir + '/*/data.p') do |file|
        File.open(file) do |io|
          u = MessagePack::Unpacker.new(io)
          u.each do |obj|
            grains = obj['grains']
            _ip = get_ip_from_grains(grains)
            if ip = Ip.where(ip: _ip).first
              fact = ip.fact || ip.build_fact
              fact.host           = grains['host']
              fact.ssd            = grains['SSDs'].to_s
              fact.productname    = grains['productname']
              fact.processor      = grains['cpu_model'].gsub('Core(TM)', '').gsub('CPU', '')
              fact.processorcount = grains['num_cpus']
              fact.lsbdistrelease = grains['os_family']
              fact.lsbdistid      = grains['osrelease']
              fact.kernelrelease  = grains['kernelrelease']
              fact.date           = grains[:_timestamp]
              fact.memorysize     = (grains['mem_total'].to_f / 1000).round
              fact.save!
            else
              puts "Missing '%13s' with eth0 '%s' - '%s'" % [grains['host'], grains['fqdn_ip4'], grains['ip4_interfaces']]
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
############################
# WINDOWS 
# "grains"=>{"
#   biosversion"=>"1.10", 
#   "kernel"=>"Windows", 
#   "domain"=>"personale.dir.unibo.it", 
#   "zmqversion"=>"4.2.5", 
#   "kernelrelease"=>"10.0.17763", 
#   "motherboard"=>{"serialnumber"=>"IA16284632", "productname"=>"H310M PRO-VDH PLUS (MS-7C09)"}, 
#   "pythonpath"=>["C:\\salt\\bin\\Scripts", "C:\\salt\\bin\\python35.zip", "C:\\salt\\bin\\DLLs", "C:\\salt\\bin\\lib", "C:\\salt\\bin", "C:\\salt\\bin\\lib\\site-packages", "C:\\salt\\bin\\lib\\site-packages\\win32", "C:\\salt\\bin\\lib\\site-packages\\win32\\lib"], 
#   "serialnumber"=>"SIC9004415", 
#   "pid"=>11716, 
#   "fqdns"=>[], 
#   "ip_interfaces"=>{"Realtek PCIe GbE Family Controller"=>["137.204.135.30", "fe80::1901:a01:b011:390e"]}, 
#   "groupname"=>"", 
#   "fqdn_ip6"=>["fe80::1901:a01:b011:390e%4"], 
#   "ip4_interfaces"=>{"Realtek PCIe GbE Family Controller"=>["137.204.135.30"]}, 
#   "timezone"=>"(UTC+01:00) Amsterdam, Berlino, Berna, Roma, Stoccolma, Vienna", 
#   "zfs_support"=>false, 
#   "SSDs"=>["\\\\.\\PhysicalDrive0"], 
#   "id"=>"str963-a0", 
#   "osrelease"=>"10", 
#   "ps"=>"tasklist.exe", 
#   "locale_info"=>{"timezone"=>"ora legale Europa occidentale", "detectedencoding"=>"cp1252", "defaultlanguage"=>"it_IT", "defaultencoding"=>"cp1252"}, 
#   "ip6_interfaces"=>{"Realtek PCIe GbE Family Controller"=>["fe80::1901:a01:b011:390e"]}, 
#   "num_cpus"=>4,
#   "hwaddr_interfaces"=>{"Realtek PCIe GbE Family Controller"=>"00:D8:61:11:D0:36"}, 
#   "init"=>"Windows", 
#   "virtual"=>"physical", 
#   "osfullname"=>"Microsoft Windows 10 Pro", 
#   "osmanufacturer"=>"Microsoft Corporation", 
#   "master"=>"dmsalt.dm.unibo.it", 
#   "ipv4"=>["137.204.135.30"],
#   "ipv6"=>["fe80::1901:a01:b011:390e"], 
#   "osversion"=>"10.0.17763", 
#   "localhost"=>"str963-a0", 
#   "username"=>"root", 
#   "fqdn_ip4"=>["137.204.135.30"], 
#   "saltpath"=>"C:\\salt\\bin\\lib\\site-packages\\salt", "shell"=>"C:\\Windows\\system32\\cmd.exe", 
#   "nodename"=>"str963-a0", 
#   "saltversion"=>"2019.2.0", 
#   "saltversioninfo"=>[2019, 2, 0, 0], 
#   "osfinger"=>"Windows-10",
#   "server_id"=>1618414498,
#   "pythonversion"=>[3, 5, 4, "final", 0], 
#   "zfs_feature_flags"=>false, 
#   "host"=>"str963-a0", 
#   "os_family"=>"Windows", 
#   "gpus"=>[], 
#   "path"=>"C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Windows\\System32\\OpenSSH\\;C:\\Program Files (x86)\\NVIDIA Corporation\\PhysX\\Common;C:\\Program Files\\NVIDIA Corporation\\NVIDIA NvDLISR;C:\\Program Files\\MiKTeX 2.9\\miktex\\bin\\x64\\;C:\\Program Files\\MATLAB\\R2018b\\runtime\\win64;C:\\Program Files\\MATLAB\\R2018b\\bin;C:\\salt;C:\\Users\\root\\AppData\\Local\\Microsoft\\WindowsApps;;C:\\salt\\bin\\lib\\site-packages\\pywin32_system32",
#   "manufacturer"=>"SiComputer S.p.A.", 
#   "kernelversion"=>"10.0.17763",
#   "num_gpus"=>0, 
#   "osservicepack"=>nil,
#   "windowsdomaintype"=>"Domain",
#   "disks"=>[],
#   "cpu_model"=>"Intel(R) Core(TM) i3-8300 CPU @ 3.70GHz",
#   "fqdn"=>"str963-a0.personale.dir.unibo.it", 
#   "pythonexecutable"=>"C:\\salt\\bin\\python.exe", 
#   "productname"=>"One",
#   "cpuarch"=>"AMD64",
#   "osrelease_info"=>[10], 
#   "os"=>"Windows", 
#   "windowsdomain"=>"PERSONALE", 
#   "mem_total"=>16289}}


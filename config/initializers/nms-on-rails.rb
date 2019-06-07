# rsync -av root@newton.ciram.unibo.it:/var/lib/arpwatch/arp.dat /home/tmp/ciram_arp.dat
# rsync -av root@dmpuppet:/var/lib/arpwatch/arp.dat /home/tmp
module NmsOnRails
  class Application < Rails::Application
    config.before_initialize do 
      # Domains with server where you can get dig axfr
      # on your rails server should work `dig axfr domain_name`
      config.dns_domains = {'dm.unibo.it'    => '137.204.134.1', 
                            'ciram.unibo.it' => '137.204.132.20'}
      # Arpwatch
      config.arpwatch_files = ['/home/tmp/arp.dat', '/home/tmp/ciram_arp.dat']
      # Facts
      config.facts_dir = "/home/tmp/facts"
      # snmpwalk
      config.snmpwalkexe = '/usr/bin/snmpwalk'
      # nmap
      config.nmapexe = '/usr/bin/nmap'
    end
  end
end



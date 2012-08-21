module NmsOnRails
  class Application < Rails::Application
    config.before_initialize do 
      # Domains with server where you can get dig axfr
      config.dns_domains = {'dm.unibo.it'    => '137.204.134.1', 
                            'ciram.unibo.it' => '137.204.132.20'}
      # Arpwatch
      config.arpwatch_files = ['/var/lib/arpwatch/arp.dat', '/home/donatini/arp_ciram.dat']
      # Facts
      config.facts_dir = "/var/lib/puppet/yaml/facts"
    end
  end
end



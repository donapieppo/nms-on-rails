module NmsOnRails
  class Application < Rails::Application
    config.before_initialize do 
      # Domains with server where you can get dig axfr
      # on your rails server should work `dig axfr dm.unibo.it`
      config.dns_domains = {'example.com'    => '192.168.1.1', 
                            'example2.com'   => '192.168.2.1'}
      # Arpwatch
      config.arpwatch_files = ['/var/lib/arpwatch/arp.dat', '/tmp/arp_other.dat']
      # Facts
      config.facts_dir = "/var/lib/puppet/yaml/facts"
      # snmpwalk
      config.snmpwalkexe = '/usr/bin/snmpwalk'
    end
  end
end



module NmsOnRails
  class Application < Rails::Application
    config.before_initialize do 
      # Domains with server where you can get dig axfr
      # on your rails server should work `dig axfr domain_name`
      config.dns_domains = {'example.it'  => '111.112.113.1', 
                            'exmaple.com' => '111.112.112.2'}
      # Arpwatch
      config.arpwatch_files = ['/var/lib/arpwatch/arp.dat', '/tmp/arp_ciram.dat']
      # Facts
      config.facts_dir = "/var/lib/puppet/yaml/facts"
      # snmpwalk
      config.snmpwalkexe = '/usr/bin/snmpwalk'
      # nmap
      config.nmapexe = '/usr/bin/nmap'
      # dhcp
      config.dhcp_files = ['tmp/132_net_static', 'tmp/134_net_static', 'tmp/135_net_static']
    end
  end
end



NMS on Rails
=================

A basic Network Management System built with
Ruby on Rails, Backbone (and Bootstrap style)
in early stage.

Provides basic integration to:

* arpwatch (http://ee.lbl.gov/)
* puppet (https://github.com/puppetlabs/puppet)
* wakeonlan
* bind (reads domain with dig domani.net axfr)

and gives simple web interface to manage informations
about your network ips and to connect to clients using
ssh/rdp/http.

## Getting started

Clone the repository, "bundle install" everything and
configure the database (`config/database.yml`, for example
copy from `doc/database.yml`) as for a common rails project.

Then you can load the database schema

```console
bundle exec rake db:schema:load
```

edit the file `config/initializers/nms-on-rails.rb`
and then fire rails.

When you connect for the first time you are asked 
for a network (name, description) and then for a range
of ips for the new network.

## Editing

Double click on the name/description opens a window 
for editing.

Click on the 'proto' switches connection protocol
between ssh/rdp/http

## Rake

```console
 bundle exec rake -T NmsOnRails
```

The database can be populated with data from arpwatch and
puppet. Usually with cron jobs.

### Arpwatch

```console
bundle exec rake NmsOnRails:arpwatch
```

reads arpwatch data (directly from arpwatch files as listed in config/initializers/nms-on-rails.rb) 
and updates the database. 
Accordingly the web interface shows how many days ago the ip was used and the last mac address.

### Puppet

```
bundle exec rake NmsOnRails:facts:load
```

reads puppet data (facts in puppet language) and updates the database.
Provides information about the hardware and operating
system of the computers managed with puppet.

### Bind

``` 
bundle exec rake NmsOnRails:dns:update
```

reads domain records with axfr query (the dns server has to answer
`dig axfr`, for example in bind your rails server should be in 
`allow-recursion` hosts).

### SNMP

```
bundle exec rake NmsOnRails:snmp:snmpwalk
```
updates mac-address with port on the switch (uses `snmpwalk -On -v 2c -c #{community} #{clean_ip} .1.3.6.1.2.1.1.5.0`)

## Database structure

### Ips

* last_arp_id:  is the association to the last arp address seen with the ip (usually discovered by arpwatch)
* last_info_id: is the association to the last info (name, dns...). Some fields in infos table are seu by user.
* conn_proto: can be ssh/rdp/http (used to connect witha click to the pc)
* notify: boolean you set when you whant to be notified when the pc in reachable.

Ips has one_to_many relation with the arps, infos and facts tables.

### Arps

The arps table collects data from arpwatch (date and ip/mac-address association)

### Infos

Are the information you give to the ip. You can update or reset when the ip
is associated to other informations.

### Facts

Facts come from pc controlled by puppet (https://github.com/puppetlabs/puppet) and are 
gathered by facter (https://http://puppetlabs.com/puppet/related-projects/facter/).


NMS on Rails
=================

A basic Network Management System built with
Ruby on Rails, Angularjs (and Bootstrap style)
in early stage.

Provides basic integration to:

* arpwatch (http://ee.lbl.gov/)
* puppet (https://github.com/puppetlabs/puppet)
* wakeonlan
* bind (reads domain with dig domani.net axfr)
* nmap (tries to discover operating system)

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

Click on the name opens a submenu for actions.

Click on the 'proto' switches connection protocol
between ssh/rdp/http.

## Rake

```console
 bundle exec rake -T NmsOnRails
```
shows all the possible tasks.

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

### Snmp

```
bundle exec rake NmsOnRails:snmp:snmpwalk
```
updates mac-address with port on the switch (uses `snmpwalk -On -v 2c -c #{community} #{clean_ip} .1.3.6.1.2.1.1.5.0`)

### Nmap

```
bundle exec rake NmsOnRails:nmap:system
```

uses `/usr/bin/sudo /usr/bin/nmap -F --max-os-tries 1 -n -O ` to read operating system from the pcs. 
The user should have sudo privileges. 

## Database structure

### Ips

* ip: address (unique, for rails simplicity the key is id)
* last_arp_id:  is the association to the last arp address seen with the ip (usually discovered by arpwatch)
* last_info_id: is the association to the last info (name, dns...). Some fields in infos table are set by user.
* conn_proto: can be ssh/rdp/http (used to connect to the pc with a click)
* notify: boolean you set when you whant to be notified when the pc in reachable.
* network_id

Ips has **one_to_many** relation with the **arps**, **infos**, **systems** and **facts** tables.

| id | ip             | last_arp_id | last_info_id |  notify | network_id | last_system_id |
|----|----------------|-------------|--------------|--------|-------------|----------------|
|  1 | 192.168.1.1  |        4238 |            1 |      0 |          1  |             40 |
|  2 | 192.168.1.2  |        2633 |            2 |      0 |          1  |             41 |
|  3 | 192.168.1.3  |        4253 |            3 |      0 |          1  |             83 |

### Arps

The arps table collects data from arpwatch (date and ip/mac-address association). In this table you find the
last time a ip/mac-address couple has been seen in network.

| id   | ip_id | mac               | date                |
|------|-------|-------------------|---------------------|
| 1405 |     1 | 00:09:3d:14:c5:2f | 2012-01-24 14:29:03 |
| 1407 |     1 | 00:13:21:6b:a9:05 | 2012-03-29 13:32:20 |
| 1406 |     1 | 00:13:21:6b:ad:99 | 2009-10-07 08:44:57 |


### Infos

Are the information you give to the ip. You can update or reset when the ip is associated to other informations.
* date
* name: supplied by user
* dnsname: read from a dns server
* comment: supplied by user
* user_id: TODO
* dhcp: boolean (FIXME)

| id | ip_id | date                | name         | dnsname              | comment                  | dhcp |
|----|-------|---------------------|--------------|----------------------|--------------------------|------|
|  1 |     1 | 2014-04-10 07:26:29 | mypc         | mail.mydomain.it     | Server mail / dns / ldap | NULL |
|  2 |     2 | 2014-04-10 07:26:29 | mypc2        | www.mydomain.it      | Server WEB               | NULL |


### Facts

Facts come from pc controlled by puppet (https://github.com/puppetlabs/puppet) and are 
gathered by facter (https://http://puppetlabs.com/puppet/related-projects/facter/).

### Systems

OS 

### Ports

Information for switch/port and mac address association. 

=======

### Licence

NMS on Rails is released under the [MIT License](http://www.opensource.org/licenses/MIT).



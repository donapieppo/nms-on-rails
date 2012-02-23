NMS on Rails
=================

A basic Network Management System built with
Ruby on Rails, Backbone and styled with Bootstrap.

Provides integration to:

* arpwatch (when last seen ip)
* puppet (https://github.com/puppetlabs/puppet)
* wakeonlan

## Getting started

After you have cloned and "bundle installed" everything
you can load the database schema

```console
bundle exec rake db:load
```

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


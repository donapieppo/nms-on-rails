class NmsOnRails.Models.Arp extends Backbone.Model
  paramRoot: 'arp'
  urlRoot: '/arps'
  
  # Set 1 day in milliseconds one_day=1000*60*60*24
  one_day = 86400000
  today   = new Date()

  defaults:
    mac: null
    date: null

  last_seen: ->
    last_arp = new Date (@get('date'))
    Math.ceil((today.getTime()-last_arp.getTime())/(one_day))



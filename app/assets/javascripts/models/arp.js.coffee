angular.module('ngNms').factory('nmsArp', -> 
  one_day = 86400000
  today   = new Date()

  return (data) ->
    angular.extend(this, {
      mac: null
      date: null
      last_seen: ->
        last_arp = new Date (@date)
        Math.ceil((today.getTime()-last_arp.getTime())/(one_day))
    })
    angular.extend(this, data)
);


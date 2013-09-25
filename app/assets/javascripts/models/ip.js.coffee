angular.module('ngNms').factory('nmsIp', ['nmsInfo', 'nmsArp', (nmsInfo, nmsArp) -> 
  return (data) ->
    angular.extend(this, {
      ip: null
      arp: null
      info: null
      conn_proto: null
      notify: null
      info: null
      arp: null

      conn_link: ->
        if this.conn_proto
          proto = this.conn_proto
          proto = 'html' if proto == 'http'
          "/ips/#{@id}/connect.#{proto}"
        else
          ""

      wake_link: ->
        "/ips/#{@id}/wake.wol"
    })
    angular.extend(this, data)
    this.info = new nmsInfo(data.info)
    this.arp  = new nmsArp(data.arp)
    this
]);


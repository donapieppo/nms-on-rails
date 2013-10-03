angular.module('ngNms').factory('nmsIp', ['$resource', 'nmsInfo', 'nmsArp', ($resource, nmsInfo, nmsArp) -> 
  r = $resource('/nms-on-rails/networks/1/ips/:id.json', 
      { id:'@id' }, 
      { update: { method: 'PUT' }})

  r.prototype.conn_link = ->
    if this.conn_proto
      proto = this.conn_proto
      proto = 'html' if proto == 'http'
      "/ips/#{@id}/connect.#{proto}"
    else
      ""

  r.prototype.wake_link = ->
    "/ips/#{@id}/wake.wol"

  r.prototype.get_info = ->
    new nmsInfo(this.info)

  r.prototype.get_arp = ->
    new nmsArp(this.arp)

  r
])


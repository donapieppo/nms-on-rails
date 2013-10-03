angular.module('ngNms').factory('nmsIp', ['$resource', 'nmsInfo', 'nmsArp', ($resource, nmsInfo, nmsArp) -> 
  r = $resource('/nms-on-rails/networks/1/ips/:id.json', 
      { id:'@id' }, 
      { update: { method: 'PUT' }})

  r.prototype.conn_link = ->
    if @conn_proto
      proto = @conn_proto
      proto = 'html' if proto == 'http'
      "/ips/#{@id}/connect.#{proto}"
    else
      ""

  r.prototype.wake_link = ->
    "/ips/#{@id}/wake.wol"

  r.prototype.nmsinfo = ->
    if ! @singleton_info
      @singleton_info = new nmsInfo(@info)
    @singleton_info

  r.prototype.nmsarp = ->
    if ! @singleton_arp
      @singleton_arp = new nmsArp(@arp)
    @singleton_arp

  r
])


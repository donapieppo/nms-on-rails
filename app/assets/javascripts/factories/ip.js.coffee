angular.module('ngNms').factory('nmsIp', ['$resource', 'nmsInfo', 'nmsArp', ($resource, nmsInfo, nmsArp) -> 
  r = $resource('/nms-on-rails/networks/1/ips/:id.json', 
      { id:'@id' }, 
      { update: { method: 'PUT' }}
  )

  r.prototype.nmsinfo = ->
    if ! @singleton_info
      @singleton_info = new nmsInfo(@info)
    @singleton_info

  r.prototype.nmsarp = ->
    if ! @singleton_arp
      @singleton_arp = new nmsArp(@arp)
    @singleton_arp

  r.prototype.toggle_protocol = ->
    @conn_proto = switch @conn_proto
                  when null   then 'ssh'
                  when 'ssh'  then 'rdp'
                  when 'rdp'  then 'http'
                  when 'http' then 'ssh'

    @.$update()

  r.prototype.conn_link = ->
    if @conn_proto
      proto = @conn_proto
      proto = 'html' if proto == 'http'
      "/nms-on-rails/ips/#{@id}/connect.#{proto}"
    else
      ""

  r.prototype.wake_link = ->
    "/nms-on-rails/ips/#{@id}/wake.wol"

  r
])


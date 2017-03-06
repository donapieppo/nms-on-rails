angular.module('ngNms').factory('nmsFact', ['$resource', 'nmsIp', ($resource, nmsIp) -> 

  r = $resource(window.BASEURL + '/facts.json', 
      { id:'@id' }, 
      { update: { method: 'PUT' }}
  )

  r.prototype.nmsip = ->
    if ! @singleton_ip
      @singleton_ip = new nmsIp(@ip)
    @singleton_ip

  r

])


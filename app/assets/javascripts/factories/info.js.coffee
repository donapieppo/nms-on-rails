angular.module('ngNms').factory('nmsInfo', ['$resource', ($resource) -> 
  r = $resource('/nms-on-rails/infos/:id.json', 
      { id:'@id' }, 
      { update: { method: 'PUT' }})

  # r.prototype.conn_link = ->

  r
])


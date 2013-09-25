angular.module('ngNms').factory('nmsInfo', -> 
  return (data) ->
    angular.extend(this, {
      name:    null
      comment: null
    })
    angular.extend(this, data)
);


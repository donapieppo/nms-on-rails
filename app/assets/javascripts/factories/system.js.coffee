angular.module('ngNms').factory('nmsSystem', -> 
  return (data) ->
    angular.extend(this, {
      name: "UNDEF"
    })
    angular.extend(this, data)
);


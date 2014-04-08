angular.module('ngNms').factory('nmsOs', -> 
  return (data) ->
    angular.extend(this, {
      name: "UNDEF"
    })
    angular.extend(this, data)
);


angular.module('ngNms').factory('nmsSystem', -> 
  return (data) ->
    this.icon = ->
      switch this.name
        when "linux"   then "linux"
        when "macos"   then "apple"
        when "printer" then "print"
        when "win7"    then "windows"
        when "xp"      then "ambulance"

    angular.extend(this, {
      name: "UNDEF"
    })
    angular.extend(this, data)
);


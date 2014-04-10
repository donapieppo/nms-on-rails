angular.module('ngNms').directive( 'showIpActions', ($compile) -> 
  return {
    restrict: 'E',
    scope: { localip: "=" },
    template: '<div class="dropdown" >' +
              '  <a class="dropdown-toggle" data-toggle="dropdown">{{localip.ip}}<span class="caret"></span></a>' +
              '  <ul class="dropdown-menu"></ul>' +
              '</div>',
    link: (scope, element, attrs) ->
      element.bind('click', -> 
        # connect
        menu = '<li><a href="' + scope.localip.conn_link() + '" target="new"><i class="icon-eye-open"></i> Connect</a></li>' 

        # wake up
        if (scope.localip.arp.mac)
          menu = menu + '<li><a href="' + scope.localip.wake_link() + '" taget="new"><i class="icon-off"></i> Wake up</a></li>' 
        # notify
        if (! scope.localip.notify)
          menu = menu + '<li><a href="#" class="notify"><i class="icon-time"></i> Notify when online</a></li>' 

        # systems
        menu = menu + "<li class='divider'></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'linux')\"><i class='icon-linux'></i> Linux</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'win7')\"><i class='icon-windows'></i> Win7</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'xp')\"><i class='icon-windows'></i> XP</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'macos')\"><i class='icon-apple'></i> MacOs</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'printer')\"><i class='icon-print'></i> printer</a></li>"

        # reset
        menu = menu + "<li class='divider'></li>"
        menu = menu + "<li><a ng-click=\"$parent.reset(localip)\"><i class='icon-remove'></i> Reset</a></li>"

        menu = menu + "</ul>"

        elmnt = $compile( menu )( scope )

        element.find("ul.dropdown-menu").html(elmnt)
      )
  }
)


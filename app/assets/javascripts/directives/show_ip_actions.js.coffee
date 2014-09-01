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
        menu = '<li><a href="' + scope.localip.conn_link() + '" target="new"><i class="fa fa-eye"></i> Connect</a></li>' 

        # wake up
        if (scope.localip.arp)
          menu = menu + '<li><a href="' + scope.localip.wake_link() + '" taget="new"><i class="fa fa-bell-o"></i> Wake up</a></li>' 
        # notify
        if (! scope.localip.notify)
          menu = menu + '<li><a href="#" class="notify"><i class="fa fa-clock-o"></i> Notify when online</a></li>' 

        # systems
        menu = menu + "<li class='divider'></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'linux')\"><i class='fa fa-linux'></i> Linux</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'win7')\"><i class='fa fa-windows'></i> Win7</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'xp')\"><i class='fa fa-windows'></i> XP</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'macos')\"><i class='fa fa-apple'></i> MacOs</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'printer')\"><i class='fa fa-print'></i> printer</a></li>"
        menu = menu + "<li><a ng-click=\"$parent.set_system(localip, 'unset')\"><i class='fa fa-question'></i> unset</a></li>"

        # reset
        menu = menu + "<li class='divider'></li>"
        menu = menu + "<li><a ng-click=\"$parent.reset(localip)\"><i class='fa fa-remove'></i> Reset</a></li>"

        menu = menu + "</ul>"

        elmnt = $compile( menu )( scope )

        element.find("ul.dropdown-menu").html(elmnt)
      )
  }
)


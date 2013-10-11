angular.module('ngNms').directive( 'showIpActions', -> 
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

        # informations 
        if (scope.localip.fact)
          menu = menu + '<li><a href="/nms-on-rails/facts/' + scope.localip.fact.id + '" class="notify"><i class="icon-info"></i> Maggiori informazioni</a></li>' 

        menu = menu + "<li class='divider'></li>"
        # reset
        menu = menu + "<li><a href='#' class='ip-reset'><i class='icon-remove'></i> Reset</a></li>"

        menu = menu + "</ul>"

        element.find("ul.dropdown-menu").html(menu)
      )
  }
);




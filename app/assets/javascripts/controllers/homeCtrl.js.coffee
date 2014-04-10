@HomeCtrl = ($routeParams, $scope, $location, $http, nmsIp, nmsInfo, nmsArp, nmsFact, nmsSystem) ->
  console.log("richiesto network #{$routeParams.network_id}")
  $scope.BASEURL = window.BASEURL

  network_id = $routeParams.network_id || 1
  $scope.ips = nmsIp.query(network_id: network_id)

  $scope.$watch('search_string', ->
    if ($scope.search_string and $scope.search_string.length > 2)
      $scope.ips = nmsIp.query(search_string: $scope.search_string)
  )

  $scope.edit_ip = (ip) ->
    $http.get('ips/' + ip.id + '.json').success( (data) ->
      console.log(data)
      $scope.editable_ip = ip
      $scope.editable_info = ip.nmsinfo()
      $scope.alldata = data
      $("#modaleditor").modal('show')
    )

  $scope.submit_info = (ip, info) ->
    console.log(info)
    $("#modaleditor").modal('hide')
    info.$update();
    # FIXME

  $scope.toggle_protocol = (ip) ->
    ip.toggle_protocol()

  $scope.set_system = (ip, system_string) ->
    $http.put('ips/' + ip.id + '.json', { system: system_string}).success( (data) ->
      ip.nmssystem().name = system_string
    )

  $scope.reset = (ip) ->
    $http.put('ips/' + ip.id + '/reset.json').success( (data) ->
      ip.nmsinfo().name = "-"
      ip.nmsinfo().comment = ""
    )

  $scope.show_facts = (ip) ->
    $http.get('ips/' + ip.id + '/facts.json').success( (data) ->
      $("#modalfacts").modal('show')
      $scope.editable_ip = ip
      $scope.actual_facts = data
      console.log(data)
    )

  #$http.get('networks/1/ips.json').success( (data) ->
  #    $scope.ips = data.map (i) ->
  #      new nmsIp(i)
  #  ).error( ->
  #    console.error('Failed to load ips.')
  #  )



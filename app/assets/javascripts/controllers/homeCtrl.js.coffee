@HomeCtrl = ($routeParams, $scope, $location, nmsIp, nmsInfo, nmsArp) ->
  console.log("richiesto network #{$routeParams.network_id}")

  $scope.ips = nmsIp.query(network_id: $routeParams.network_id || 1)

  $scope.edit_ip = (ip) ->
    $scope.editable_ip = ip
    $scope.editable_info = ip.nmsinfo()
    $("#modaleditor").modal('show')

  $scope.submit_info = (ip, info) ->
    console.log(info)
    $("#modaleditor").modal('hide')
    info.$update();
    # FIXME

  $scope.toggle_protocol = (ip) ->
    ip.toggle_protocol()

  #$http.get('networks/1/ips.json').success( (data) ->
  #    $scope.ips = data.map (i) ->
  #      new nmsIp(i)
  #  ).error( ->
  #    console.error('Failed to load ips.')
  #  )



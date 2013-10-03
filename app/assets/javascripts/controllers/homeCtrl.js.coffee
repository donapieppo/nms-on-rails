@HomeCtrl = ($scope, $location, nmsIp, nmsInfo, nmsArp) ->
  $scope.ips = nmsIp.query()
  $scope.edit_ip = (ip) ->
    $scope.editable_ip = ip
    $("#modaleditor").modal('show')

  #$http.get('networks/1/ips.json').success( (data) ->
  #    $scope.ips = data.map (i) ->
  #      new nmsIp(i)
  #  ).error( ->
  #    console.error('Failed to load ips.')
  #  )



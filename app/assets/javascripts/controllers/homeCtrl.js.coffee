@HomeCtrl = ($scope, $location, nmsIp, nmsInfo, nmsArp) ->
  $scope.ips = nmsIp.query()

  $scope.edit_ip = (ip) ->
    $scope.editable_ip = ip
    $scope.editable_info = ip.nmsinfo()
    $("#modaleditor").modal('show')

  $scope.submit_info = (ip, info) ->
    console.log(info)
    $("#modaleditor").modal('hide')
    info.$update();
    # FIXME

  #$http.get('networks/1/ips.json').success( (data) ->
  #    $scope.ips = data.map (i) ->
  #      new nmsIp(i)
  #  ).error( ->
  #    console.error('Failed to load ips.')
  #  )



@FactsCtrl = ($routeParams, $scope, $location, $http, nmsIp, nmsInfo, nmsArp, nmsFact) ->
  console.log("richiesto facts ctrl")
  $scope.BASEURL = window.BASEURL

  $scope.facts = nmsFact.query()




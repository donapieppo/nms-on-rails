@HomeCtrl = ($scope, $http, $compile, nmsIp, nmsInfo, nmsArp) ->
  $http.get('networks/1/ips.json').success( (data) ->
      $scope.ips = data.map (i) ->
        new nmsIp(i)
    ).error( ->
      console.error('Failed to load ips.')
    )


@PostCtrl = ($scope, $http, $resource, $compile, nmsIp, nmsInfo, nmsArp) ->
  Post = $resource('/nms-on-rails/networks/1/ips/:id.json');
  console.log(Post);
  posts = Post.query( ->
    console.log(posts)
  )


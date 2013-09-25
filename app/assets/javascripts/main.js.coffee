# Creates new Angular module 
angular.module('ngNms', ['ngRoute', 'ngResource']).config( ($routeProvider, $locationProvider) ->
  # Route for '/post'
  $routeProvider.when('/post', { templateUrl: '/nms-on-rails/assets/mainPost.html', controller: 'PostCtrl' } )
  # Default
  $routeProvider.otherwise({ templateUrl: '/nms-on-rails/assets/homeIndex.html', controller: 'HomeCtrl' } )
)


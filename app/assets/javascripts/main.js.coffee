# Creates new Angular module 
angular.module('ngNms', ['ngRoute', 'ngResource']).config( ($routeProvider, $locationProvider, $httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');

  $routeProvider
    # Route for '/post'
    .when('/post', { templateUrl: '/nms-on-rails/assets/mainPost.html', controller: 'PostCtrl' })
    # Default
    .otherwise({ templateUrl: '/nms-on-rails/assets/homeIndex.html', controller: 'HomeCtrl' })
)


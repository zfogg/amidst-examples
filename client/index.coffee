angular.module("amidstExamples", [
  "ngAnimate"
  "ngCookies"
  "ngResource"
  "ngRoute"
])


  .config ($routeProvider, $locationProvider) ->

    $locationProvider.html5Mode(true)

    $routeProvider
      .when "/",
        templateUrl: "main/index.html"
        controller: "MainCtrl"

      .when "/proximity",
        templateUrl: "proximity/index.html"
        controller: "ProximityCtrl"
      .when "/follow-suggest",
        templateUrl: "follow-suggest/index.html"
        controller: "FollowSuggestCtrl"
      .when "/newsfeed-plus",
        templateUrl: "newsfeed-plus/index.html"
        controller: "NewsfeedPlusCtrl"
      .when "/meetups",
        templateUrl: "meetups/index.html"
        controller: "MeetupsCtrl"

      .when "/404",
        templateUrl: "layout/404/index.html"
        controller: "404Ctrl"
      .otherwise
        redirectTo: "/404"

    $("body").flowtype
      minimum   : 320
      maximum   : 1200
      minFont   : 17
      maxFont   : 22
      fontRatio : 40
      lineRatio : 1.45


  .controller "BodyCtrl", ($http, $scope, $rootScope, $window, $location, $timeout) ->

    $rootScope.isLoaded  = true
    $rootScope.viewReady = true

    $scope.animReady = true

    $rootScope.$on "$routeChangeStart", ->
      $rootScope.viewReady = false

    $rootScope.$on "$routeChangeSuccess", ->
      $rootScope.viewReady = true

      $window.ga? "set", "page", $location.path()
      $window.ga? "send", "pageview"


window.s = null

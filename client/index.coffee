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
      .when "/examples/proximity",
        templateUrl: "examples/proximity/index.html"
        controller: "ProximityCtrl"
      .when "/examples/auto-follow",
        templateUrl: "examples/auto-follow/index.html"
        controller: "AutoFollowCtrl"
      .when "/examples/livegraph",
        templateUrl: "examples/livegraph/index.html"
        controller: "LiveGraphCtrl"
      .when "/examples/foursquare-plus",
        templateUrl: "examples/foursquare-plus/index.html"
        controller: "FoursquarePlusCtrl"
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

  .factory "namespace", ->
    (target, name, block) ->
      [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
      top    = target
      target = target[item] or= {} for item in name.split '.'
      block target, top


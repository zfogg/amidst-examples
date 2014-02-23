angular.module('amidstExamples')

  .controller 'FollowSuggestCtrl', ($scope, $http) ->
    #START BOILERPLATE
    s = window.s
    if s then s.socket.reconnect()
    else s = io.connect "http://localhost:80/api"
    $scope.devices = {}
    s.on "devices", (devices) -> $scope.$apply ->
      console.log devices
      for d in devices
        $scope.devices[d.uuid] = d
    $scope.$on "$destroy", (ev) ->
      s.removeAllListeners()
      s.disconnect()
    #END BOILERPLATE


    $scope.user = "zfogg"

    $scope.meetingsNumber = 1
    $scope.daysNumber     = 1

    $scope.handles = {
      "Mark Nadal":            "marknadal",
      "Zach Fogg":             "zfogg",
      "Raphie Palefsky-Smith": "raphieps",
      "Jaydeep Singh":         "jsinghdreams"
    }
    $scope._handles = {
      "marknadal":    "Mark Nadal"
      "zfogg":        "Zach Fogg"
      "raphieps":     "Raphie Palefsky-Smith"
      "jsinghdreams": "Jaydeep Singh"
    }

    $scope.parseTime = (t) ->
      moment(t).fromNow()

    window.find = (friends) ->
      $scope.$apply ->
        $scope.friends = friends

    $scope.findFriends = () ->
      d = new Date()
      d.setDate(d.getDate() - 2)
      $.getScript "http://10.60.21.222:3000/twitter-friends?name=#{$scope._handles[$scope.user]}&times=#{$scope.meetingsNumber}&since=#{d.getTime()}&callback=find"


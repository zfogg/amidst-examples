socket = null

angular.module('amidstExamples')

  .controller 'AutoFollowCtrl', ($scope, $http) ->

    # Don't delete the following two lines.
    if   socket then socket.socket.reconnect()
    else socket = io.connect "http://localhost:80/api"
    $scope.$on "$destroy", (ev) ->
      socket.disconnect()
      socket.removeAllListeners()
    # OK, now you can delete stuff.

    $scope.devices = {}

    socket.on "devices", (devices) -> $scope.$apply ->
      for d in devices
        $scope.devices[d.uuid] = d

      socket.on "register", (d) -> $scope.$apply ->
        $scope.devices[d.uuid] = d

      a$ = null; b$ = null
      socket.on "meeting", (a, m, b) -> $scope.$apply ->
        a$ or= a; b$ or= b
        if a.uuid is a$.uuid
          console.log a.uuid



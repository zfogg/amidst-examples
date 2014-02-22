socket = null

angular.module('amidstExamples')

  .controller 'ProximityCtrl', ($scope, $http) ->
    $scope.devices = {}

    $scope.styles = {}

    if socket then socket.socket.reconnect()
    else socket = io.connect "http://localhost:80/api"

    # FIXME: Having one of the two devices be a host is necessary.
    # Otherwise, you'd get two socket.on "meeting" events that are
    # exactly the same, except a and b are swapped in the second event.
    # This leads rapidly to setting and then unsetting the same logic :(.
    host = null
    socket.on "devices", (devices) -> $scope.$apply ->
      host = devices[0]
      for d in devices
        $scope.devices[d.uuid] = d
        $scope.styles[d.uuid] = {}
      console.log $scope.styles

    socket.on "register", (d) -> $scope.$apply ->
      $scope.devices[d.uuid] = d

    socket.on "meeting", (a, m, b) -> $scope.$apply ->
      if a.uuid is host.uuid
        s = Math.pow(1.2, Math.abs(m.signal) / 4.5)
        $scope.styles[a.uuid]['-webkit-transform'] = "translateX(#{-40*s}px)"
        $scope.styles[b.uuid]['-webkit-transform'] = "translateX(#{+40*s}px)"
        console.log a.uuid[..5], $scope.styles[a.uuid]
        console.log b.uuid[..5], $scope.styles[b.uuid]

    $scope.$on "$destroy", (ev) ->
      socket.disconnect()
      socket.removeAllListeners()

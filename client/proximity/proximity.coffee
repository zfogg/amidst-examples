s = window.s

angular.module('amidstExamples')

  .controller 'ProximityCtrl', ($scope, $http) ->
    if s then s.socket.reconnect()
    else s = io.connect "http://localhost:80/api"

    $scope.devices = {}

    $scope.styles  = {}

    # FIXME: Having one of the two devices be a host is necessary.
    # Otherwise, you'd get two socket.on "meeting" events that are
    # exactly the same, except a and b are swapped in the second event.
    # This leads rapidly to setting and then unsetting the same logic :(.
    s.on "devices", (devices) -> $scope.$apply ->
      for d in devices
        $scope.devices[d.uuid] = d
        $scope.styles[d.uuid] = {}

      s.on "register", (d) -> $scope.$apply ->
        $scope.devices[d.uuid] = d

      a$ = null; b$ = null
      s.on "meeting", (a, m, b) -> $scope.$apply ->
        a$ or= a; b$ or= b
        if a.uuid is a$.uuid
          s = Math.pow(1.42, Math.abs(m.signal) / 9.5) - 5
          $scope.styles[a.uuid]["-webkit-transform"] = "translateX(#{+40*s}px)"
          $scope.styles[b.uuid]["-webkit-transform"] = "translateX(#{-40*s}px)"
          $scope.styles[a.uuid]["opacity"] = "1"
          $scope.styles[b.uuid]["opacity"] = "1"

    $scope.$on "$destroy", (ev) ->
      s.removeAllListeners()
      s.disconnect()

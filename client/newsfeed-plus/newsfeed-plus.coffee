angular.module('amidstExamples')

  .controller 'NewsfeedPlusCtrl', ($scope, $http) ->
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


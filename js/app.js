/// <reference path="../lib/angular.js" />
var connectedRepGen = angular.module("ConnectedRepGen", []);

connectedRepGen.controller("RemoteRepGenController", ["$scope", "$http", function ($scope, $http) {
    $scope.linkSession = function() {
        $http.get("/api/session/" + $scope.SessionId).success(function (data) {
            $scope.memberDetails = data;
        });
    };

    $scope.sendData = function () {
        $scope.memberDetails.SessionId = $scope.SessionId;
        $http.put("/api/session/" + $scope.SessionId, $scope.memberDetails);
    };
}]);

connectedRepGen.controller("RepGenController", ["$scope", "$http", "$timeout", "$window", function ($scope, $http, $timeout, $window) {

    var mytimeout;

    $scope.startSession = function(dataFromHost) {

        var promise = $http.post("/api/session", dataFromHost).success(function (data) {
            $scope.SessionId = data.SessionId;
        });


        $scope.onTimeout = function () {
            $http.get("/api/session/" + $scope.SessionId).success(function (data) {
                $scope.memberDetails = data;
            }).then(function () {
                mytimeout = $timeout($scope.onTimeout, 5000);
            });
        };


        promise.then(function () {
            mytimeout = $timeout($scope.onTimeout, 5000);
        });



    };
    
    $scope.$on('$destroy', function (e) {

    });

    $scope.stop = function () {
        $timeout.cancel(mytimeout);
    };

    $scope.start = function () {
        mytimeout = $timeout($scope.onTimeout, 5000);
    };

    $scope.finish = function () {
        $window.parent.postMessage($.toJSON($scope.memberDetails), '*')
    };

}]);

connectedRepGen.directive('datePick', function (dateFilter) {
    return {
        require: '^ngModel',
        restrict: 'A',
        link: function (scope, elm, attrs, ctrl) {
            ctrl.$formatters.unshift(function (modelValue) {
                scope = scope;
                if (!modelValue) return "";
                var retVal = dateFilter(modelValue, "MM/dd/yyyy");
                return retVal;
            });
        }
    };
});
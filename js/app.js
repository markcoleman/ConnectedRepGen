/// <reference path="../lib/angular.js" />
var connectedRepGen = angular.module("ConnectedRepGen", []);

connectedRepGen.controller("RemoteRepGenController", ["$scope", "$http", function ($scope, $http) {
    var originalData = {};
    $scope.linkSession = function () {
        $http.get("api/session/" + $scope.SessionId).success(function (data) {
            angular.copy(data, originalData);
            $scope.repgenSession = data;
        });
    };
    $scope.revertChanges = function () {
        angular.copy(originalData, $scope.memberDetails);
    };

    $scope.sendData = function () {
        $scope.repgenSession.Id = $scope.SessionId;
        $scope.repgenSession.Complete = true;
        $http.put("api/session/" + $scope.SessionId, $scope.repgenSession).success(function (data) {
            $scope.finished = true;
        });
    };
    $scope.restart = function() {
        location.reload();
    };
}]);

connectedRepGen.controller("RepGenController", ["$scope", "$http", "$timeout", "$window", function ($scope, $http, $timeout, $window) {

    var mytimeout;

    $scope.startSession = function (dataFromHost) {

        $scope.dataFromHost = dataFromHost;

        var promise = $http.post("api/session", dataFromHost).success(function (data) {
            $scope.SessionId = data.SessionId;
        });


        $scope.onTimeout = function () {
            $http.get("api/session/" + $scope.SessionId).success(function (data) {
                $scope.repgenSession = data;
            }).then(function () {
                mytimeout = $timeout($scope.onTimeout, 1000);
            });
        };


        promise.then(function () {
            mytimeout = $timeout($scope.onTimeout, 1000);
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
        $window.parent.postMessage($.toJSON($scope.repgenSession), '*')
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
connectedRepGen.directive("userDetails", function () {
    return {
        restrict: "E",
        scope: {
            userDetails: "=data"
        },
        replace: true,
        templateUrl: "templates/user-details.html",
        link: function (scope) {
            var s = scope;
        }
    };
});
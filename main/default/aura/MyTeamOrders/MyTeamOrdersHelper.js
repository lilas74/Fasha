/**
 * Created by lilas on 29/05/2021.
 */

({
    getOrderList: function (component, event, helper) {

        var action = component.get('c.getAllOrderByRole');


        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var arrayMapKeys = [];

                for (var key in result) {

                    var sum = 0;
                    var sumByOwner = 0;

                    var newResult = this.groupeBy(result[key], "OwnerId");
                    console.log(newResult);
                    for (var role in newResult) {

                        for (var a in newResult[role]) {

                            sumByOwner += newResult[role][a].TotalAmount;
                            newResult[role].sumByComm = sumByOwner;
                            newResult[role].owner = newResult[role][a].Owner.Name;
                        }

                    }
                    for (var a in result[key]) {
                        sum += result[key][a].TotalAmount;

                    }
                    var newOne = Object.keys(newResult)
                        .map(function (key) {
                            return newResult[key];
                        });
                    console.log(newOne);
                    //console.log(result[key]);
                    arrayMapKeys.push({key: key, value: newOne, sum: sum});
                    console.log(arrayMapKeys)
                }
                component.set("v.mapValues", arrayMapKeys);


            }
        });

        $A.enqueueAction(action);

    },
    groupeBy: function (tableauObjets, propriete) {
        return tableauObjets.reduce(function (acc, obj) {
            var cle = obj[propriete];
            if (!acc[cle]) {
                acc[cle] = [];
            }
            acc[cle].push(obj);
            return acc;
        }, {});
    },

    convertToArray: function (obj) {
        var array = Object.keys(obj).map(function (key) {
            return obj[key];
        });

    }
});
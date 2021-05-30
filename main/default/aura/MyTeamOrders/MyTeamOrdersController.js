/**
 * Created by lilas on 29/05/2021.
 */


({
    doInit: function (component, event, helper) {
        helper.getOrderList(component);
        //helper.getSumOfOrders(component);

    },
    goToRecord: function (component, event, helper) {
        // Fire the event to navigate to the contact record
        var ord = component.get("v.mapValues");
        var idx = event.target.id;
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": idx,
            "slideDevName": "detail"
        })


        sObjectEvent.fire();
    }
});
/**
 * Created by lilas on 31/05/2021.
 */

trigger UpdateNetOrderAmount on Order (before update,before insert) {
    for(Order ord : Trigger.New){
        if(ord.ShipmentCost__c == null) {
            ord.ShipmentCost__c = 0.00;
            ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
        }
        else{
            ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
        }
    }
}
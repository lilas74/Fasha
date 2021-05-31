/**
 * Created by lilas on 31/05/2021.
 */

trigger UpdateAccountOnOrder on Order (after insert, after update, after delete, after undelete) {

    Set<Id> accountIds = new Set<Id>();//Set of all of the account Id from the orders
    if(Trigger.old != null) {
        for(Order ord: Trigger.old) {
            accountIds.add(ord.AccountId);
        }
    }
    if(Trigger.new != null) {
        for(Order ord: Trigger.new) {

            accountIds.add(ord.AccountId);
        }
    }
    update [SELECT Id FROM Account WHERE Id IN :accountIds];
}
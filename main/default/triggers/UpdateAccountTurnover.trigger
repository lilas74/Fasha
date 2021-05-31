/**
 * Created by lilas on 31/05/2021.
 * @description this trigger is used to update the turnover in the account Ogject
 */

trigger UpdateAccountTurnover on Account (before insert, before update) {
    //For all account the sales revenue is set to null
    for(Account acc: Trigger.new) {
        acc.Chiffre_d_affaire__c = null;

    }
    /**
     * @description   Aggregate function to calculate the sum of all the order for an account where the status is activated (Ordered)
     */

    for(AggregateResult result: [SELECT SUM(TotalAmount) Amt, AccountId Id FROM Order WHERE AccountId IN :Trigger.new AND Status ='Activated'GROUP BY AccountId]) {
        Trigger.newMap.get((Id)result.get('Id')).Chiffre_d_affaire__c = (Decimal)result.get('Amt');
    }
}
/**
 * Created by lilas on 31/05/2021.
 * @description Batch to update Account in every account
 */

global class UpdateAccountTurnoverBatch implements Database.Batchable<sObject>, Database.Stateful {
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;
    /**
     * @description Select Id and Turnover field form account where there are one or more Activated order
     * colletc the batches of records or objects to be passed to execute
     *
     * @param info
     *
     * @return A Collection of account
     */
    global Database.QueryLocator start(Database.BatchableContext info) {

        return Database.getQueryLocator(
                'SELECT Id, chiffre_d_affaire__c,(SELECT Id FROM Orders WHERE Status =\'Activated\') FROM Account ');

    }
    /**
     * @description process each batch of records
     *
     * @param info
     * @param scope , List of Account to update
     */
    global void execute(Database.BatchableContext info, List<Account> scope) {

        List<Account> accountToUpdate = new List<Account>();
        for (Account account : scope) {
            account.chiffre_d_affaire__c = 0;

            List<Order> orders = [
                    SELECT Id, TotalAmount
                    FROM Order
                    WHERE AccountId = :account.Id AND Status = 'Activated'
            ];
            for (Order order : orders) {
                account.chiffre_d_affaire__c += order.TotalAmount;

            }

            recordsProcessed = recordsProcessed + 1;
        }
        update scope;

    }
    /**
     * @description execute any post-processing operations
     *
     * @param info
     */
    global void finish(Database.BatchableContext info) {
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [
                SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob
                WHERE Id = :info.getJobId()
        ];

    }
}

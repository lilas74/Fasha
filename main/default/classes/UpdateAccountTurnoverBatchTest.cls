/**
 * Created by lilas on 31/05/2021.
 */

@IsTest
private class UpdateAccountTurnoverBatchTest {
    /**
     * @description this method insert records with accounts and orders
     */
    @TestSetup
    static void setUpPerTest() {
        List<Account> acct = TestDataFactory.createAccounts(5);

        Product2 productOne = TestDataFactory.createProduct('Chemise longue XYX', 'Chemise');

        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);

        List<Order> ord = TestDataFactory.createOrders(2, acct, priceBook);

        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithRandomQuantity(ord, priceBook);

    }
    /**
     * @description method to test the batch
     */
    @isTest
    static void UpdateSalesRevenueBatchtest(){

        List<Order> orders = [SELECT Id,TotalAmount,AccountId FROM Order WHERE Name LIKE 'Order_%'];
        List<Order> updateOrders = new List<Order>();
        for(Order order : orders){
            order.Status = 'Activated';
            updateOrders.add(order);
        }
        update updateOrders;

        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Name LIKE 'TestAccount_%'];
        //here we set a wrong amount to turnover after orders were updated
        for(Account acc : accounts){
            acc.Chiffre_d_affaire__c = 10;
        }
        System.debug(accounts);
        Test.startTest();
        UpdateAccountTurnoverBatch ustb = new UpdateAccountTurnoverBatch();
        Id batchId = Database.executeBatch(ustb);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId ];
        System.debug(job);

        List<Account> accountsUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Name LIKE 'TestAccount_%'];

        AggregateResult[] liste = [SELECT AccountId, SUM(TotalAmount)attendu FROM Order WHERE Name LIKE 'Order_%' GROUP BY AccountId];
        Set<Id>accountId = new Set<Id>();
        Decimal expected = 0;
        Decimal actual = 0;
        for (AggregateResult ar : liste) {
            accountId.add((ID) ar.get('AccountId'));

            expected = (Decimal)ar.get('attendu');

            for (Id myAccountId : accountId) {
                Account accountsOne = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :myAccountId];

                actual = accountsOne.Chiffre_d_affaire__c;

            }
            System.debug('expected - '+expected);
            System.debug('actual - '+ actual);
            System.assertEquals(expected, actual);
        }

    }
}
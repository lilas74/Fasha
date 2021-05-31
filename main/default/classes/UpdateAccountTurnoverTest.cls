/**
 * Created by lilas on 31/05/2021.
 */

@IsTest
private class UpdateAccountTurnoverTest {
    @TestSetup
    static void setUpPerTest() {
        List<Account> acct = TestDataFactory.createAccounts(5);

        Product2 productOne = TestDataFactory.createProduct('Chemise longue XYX', 'Chemise');

        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);

        List<Order> ord = TestDataFactory.createOrders(2, acct, priceBook);

        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithRandomQuantity(ord, priceBook);

    }

    @isTest
    static void UpdateAccountTurnoverTest() {
        List<Order> orders = [SELECT Id,NetAmount__c,AccountId FROM Order WHERE Name LIKE 'Order_%'];
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Name LIKE 'TestAccount_%'];

        for (Order order : orders) {
            order.ShipmentCost__c = 100;
            order.Status = 'Activated';

        }
        Test.startTest();
        update orders;

        Test.stopTest();

        AggregateResult[] liste = [SELECT AccountId, SUM(TotalAmount)attendu FROM Order WHERE Name LIKE 'Order_%' GROUP BY AccountId];
        Set<Id>accountId = new Set<Id>();
        Decimal expected = 0;
        Decimal actual = 0;
        for (AggregateResult ar : liste) {
            accountId.add((ID) ar.get('AccountId'));

            expected = (Decimal)ar.get('attendu');

            for (Id myAccountId : accountId) {
                Account accountsOne = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :myAccountId];
                //System.debug('hello' + accountsOne.Chiffre_d_affaire__c);
                actual = accountsOne.Chiffre_d_affaire__c;

            }
            System.debug('expected1 - '+expected);
            System.debug('actual1 - '+ actual);
            System.assertEquals(expected, actual);
        }

    }
    @isTest
    static void UpdateAccountTurnoverWithWrongStatusTest() {
        List<Order> orders = [SELECT Id,TotalAmount,AccountId FROM Order WHERE Name LIKE 'Order_%'];
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Name LIKE 'TestAccount_%'];
        Integer num = 0;
        for (Order order : orders) {
            order.ShipmentCost__c = 100;
            if(Math.Mod(num,2) != 0){
                order.Status = 'Activated';
            } else {
                order.Status = 'Draft';
            }
            num+=1;

        }


        Test.startTest();
        update orders;

        Test.stopTest();

        AggregateResult[] liste = [SELECT AccountId, SUM(TotalAmount)attendu FROM Order WHERE Name LIKE 'Order_%' AND Status ='Activated' GROUP BY AccountId];
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
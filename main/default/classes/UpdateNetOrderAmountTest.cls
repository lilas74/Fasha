/**
 * Created by lilas on 03/05/2021.
 */
@isTest
public with sharing class UpdateNetOrderAmountTest {
    /**
     * @description set up per test using TestDataFactory
     */
    @TestSetup
    static void setUpPerTest() {
        List<Account> acct = TestDataFactory.createAccounts(5);

        Product2 productOne = TestDataFactory.createProduct('Chemise longue XYX', 'Chemise');

        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);

        List<Order> ord = TestDataFactory.createOrders(2, acct, priceBook);
        for (Order order : ord) {
            order.ShipmentCost__c = 10;
        }
        // List<OrderItem> orderItems = TestDataFactory.createOrderItems(2,ord,priceBook);
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithRandomQuantity(ord,priceBook);

    }
    /**
     * @description test with a List of Orders
     */
    @isTest
    static void NetAmountTestWithShipmentFilled() {
        /**
         * @description for each orders the shipmentCost is set to 100;
         * @expected For each order in the List the NetAmount expected should be equal to the TotalAmount minus ShipmentCost__c
        */
        List<Order> orders = [SELECT Id,ShipmentCost__c,TotalAmount,NetAmount__c FROM Order WHERE Name LIKE 'Order_%'];
        for(Order order : orders) {
            order.ShipmentCost__c = 100;

        }
        Test.startTest();
        update orders;
        Test.stopTest();
        orders = [SELECT Id,ShipmentCost__c,TotalAmount,NetAmount__c FROM Order WHERE Name LIKE 'Order_%'];

        /**
         * for each order the netAmount field should be equal to the TotalAmount minus ShipmentCost__c
        */
        for(Order order : orders){
            double netAmount = order.NetAmount__c;
            double expected = order.TotalAmount - order.ShipmentCost__c;
            System.debug('Order : ' + order);
            System.assertEquals(expected,netAmount);
        }
    }

    /**
     * @description Test with ShipmentCost__c equal to null
     * @expected The shipmentCost field should be equal to 0 and the netAmount equal to TotalAmount minus 0
     */
    @isTest
    static void NetAmountTestWithShipmentNull() {
        List<Order> orders = [SELECT Id,ShipmentCost__c,TotalAmount,NetAmount__c FROM Order WHERE Name LIKE 'Order_%'];
        for (Order order : orders) {
            order.ShipmentCost__c = null;

        }
        Test.startTest();
        update orders;
        Test.stopTest();
        orders = [SELECT Id,ShipmentCost__c,TotalAmount,NetAmount__c FROM Order WHERE Name LIKE 'Order_%'];

        for (Order order : orders) {
            double netAmount = order.NetAmount__c;
            double expected = order.TotalAmount - order.ShipmentCost__c;
            System.debug('Order : ' + order);
            System.assertEquals(expected, netAmount);
        }
    }
}

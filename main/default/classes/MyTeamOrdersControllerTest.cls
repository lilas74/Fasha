/**
 * Created by lilas on 29/05/2021.
 * @description class test for MyTeamOrdersControllerTest
 */

@IsTest
private class MyTeamOrdersControllerTest {
    /**
     * @description creates user with a specified team role
     */

    @TestSetup
    static void setUpPerTest() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Standard User'
        ];
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'MyTestRole');
        insert r;
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = uniqueUserName,
                UserRoleId = r.Id
        );
        /**
         * A user has been created with a specific UserRole
         * The account, product and pricebook and order has been created with the runAs User fonction
        **/
        System.runAs(u) {
            List<Account> acct = TestDataFactory.createAccounts(5);

            Product2 productOne = TestDataFactory.createProduct('Chemise longue XYX', 'Chemise');

            PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);

            List<Order> ord = TestDataFactory.createOrders(2, acct, priceBook);

            List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithRandomQuantity(ord, priceBook);

            for (Order o : ord) {
                o.Status = 'Activated';
            }
            update ord;
        }
    }

    /**
     * @description the test should return a value of the UserRole of u as selected
     * the size value should be 10 because we insert 5 accounts with 2 activated orders in it
     */
    @IsTest
    static void testMyTeamOrdersControllerWithRoleAndOrder() {

        User u = [
                SELECT Id, UserRoleId
                FROM User
                Where Alias LIKE 'standt'
        ];

        List<Order> orders = [
                SELECT Id, TotalAmount, AccountId
                FROM Order
                WHERE Name LIKE 'Order_%'
        ];

        System.runAs(u) {
            Test.startTest();
            Map<String, List<Order>> result = MyTeamOrdersController.getAllOrderByRole();
            Test.stopTest();
            /**
            * Iteration to get the key : role and the value
            */
            for (String role : result.keySet()) {
                System.assertEquals(role, 'MyTestRole');
                List<Order> value = result.get(role);
                System.assertEquals(value.size(), 10);
                System.debug(value.size());


            }
        }
    }
    /**
     * @description this test should return no result for the second user who is not in the same team as the first user.
     */
    @IsTest
    static void testMyTeamOrdersControllerWithRoleAndNoOrder() {
        /**
        * a new user is created with a second UserRole, this team has no record
        */
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + 5 + '@testorg.com';
        Profile p = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Standard User'
        ];
        UserRole r = new UserRole(DeveloperName = 'MySecond', Name = 'MySecond');
        insert r;
        User user2 = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = uniqueUserName,
                UserRoleId = r.Id
        );


        List<Order> orders = [
                SELECT Id, TotalAmount, AccountId
                FROM Order
                WHERE Name LIKE 'Order_%'
        ];

        System.runAs(user2) {
            Test.startTest();
            Map<String, List<Order>> result = MyTeamOrdersController.getAllOrderByRole();
            Test.stopTest();
            System.debug(result);
            System.assertEquals(result.size(), 0);

        }
    }
}
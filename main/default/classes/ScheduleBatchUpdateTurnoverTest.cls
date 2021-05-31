/**
 * Created by lilas on 31/05/2021.
 */

@IsTest
private class ScheduleBatchUpdateTurnoverTest {
   //CRON_EXP is the next time this schedule will run
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @TestSetup
    static void setUpPerTest() {
        List<Account> acct = TestDataFactory.createAccounts(5);

        Product2 productOne = TestDataFactory.createProduct('Chemise longue XYX', 'Chemise');

        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1000);

        List<Order> ord = TestDataFactory.createOrders(1, acct, priceBook);

        List<OrderItem>orderItems = TestDataFactory.createOrderItems(2, ord, priceBook) ;

    }
    /**
     * @description test the Scheduled Job
     */
    @IsTest
    static void testScheduledJob() {

        List<Order> orders = [SELECT Id,TotalAmount FROM Order WHERE Name LIKE 'Order_%'];
        for (Order ord : orders) {
            ord.Status = 'Activated';
        }
        update orders;

        Test.startTest();

        String jobId = System.schedule('ScheduleApexTest',
                CRON_EXP,
                new ScheduleBatchUpdateTurnover());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime,CronJobDetailId,State FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.debug(ct.NextFireTime);
        System.debug(ct.State);

        // Stopping the test will run the job synchronously
        Test.stopTest();

    }
}
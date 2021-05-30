/**
 * Created by lilas on 29/05/2021.
 *  @description Data factory to set up all the necessary data needed for all the tests.
 */

@isTest
public class TestDataFactory {
    /**
     * @description Create accounts with a integer as parameter.
     *
     * @param cnt is an integer
     *
     * @return cnt x account in a List of accounts
     */
    @TestVisible
    public static List<Account> createAccounts(Integer cnt) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0 ; i < cnt ; i++) {
            Account acc = new Account(name = 'TestAccount_' + i);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
    }
    public static Contract createContract(Id accountId) {
        Contract contract = new Contract(
                AccountId = accountId,
                ContractTerm = 12,
                StartDate = Date.today());
        insert contract;
        return contract;
    }
    /**
     * @description Create cnt orders with accounts parameter and priceBook entry parameter
     *
     * @param cnt is an integer to add cnt x order in each accounts
     * @param accts is the list of accounts where to add the order
     * @param pbEntry is the priceBook entry parameter necessary for the orders
     *
     * @return a list of cnt orders
     */
    public static List<Order> createOrders(Integer cnt, List<Account>accts, PricebookEntry pbEntry) {
        List<Order> orders = new List<Order>();
        for (Integer i = 0 ; i < accts.size() ; i++) {
            Account acct = accts[i];

            for (Integer j = 0 ; j < cnt ; j++) {
                Order ord = new Order();
                ord.name = 'Order_' + j;
                ord.AccountId = acct.Id;
                ord.EffectiveDate = System.today();
                ord.Status = 'Draft';
                ord.Pricebook2Id = pbEntry.Pricebook2Id;
                orders.add(ord);

            }
        }
        insert orders;
        return orders;
    }

    /**
     * @description this methode create a pricebook Entry with the specified productId and price
     *
     * @param productId is the product to add to the pricebook
     * @param amount is the price to add to the pricebook
     *
     * @return PricebookEntry
     */
    public static PricebookEntry createPricebookEntry(Id productId,
            Decimal amount) {
        PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = productId,
                UnitPrice = amount,
                IsActive = true
        );
        insert pbEntry;
        return pbEntry;
    }
    /**
     * @description this method create product with name as parameter and family as String
     *
     * @param name the name of the product
     * @param family the family of the product
     *
     * @return Product2
     */
    public static Product2 createProduct(String name, String family) {
        Product2 product = new Product2(
                Name = name,
                IsActive = true,
                Family = family
        );

        insert product;
        return product;
    }
    /**
     * @description this method create order items
     *
     * @param num is the parameter for the quantity of items
     * @param orders The list of orders where order items will be created
     * @param pbEntry is the pricebook entry associated with the order
     *
     * @return the order items added to the order
     */
    public static List<OrderItem> createOrderItems(Integer num, List<Order> orders, PriceBookEntry pbEntry) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : orders) {
            OrderItem orderItem = new OrderItem(
                    OrderId = ord.Id,
                    PricebookEntryId = pbEntry.Id,
                    UnitPrice = pbEntry.UnitPrice,
                    Quantity = num
            );
            orderItems.add(orderItem);
        }
        insert orderItems;
        return orderItems;
    }
    /**
     * @description  this method create order items with random quantity
     *
     * @param orders the list of orders where order items will be created
     * @param pbEntry is the pricebook entry associated with the order
     *
     * @return the order items added to the order
     */
    public static List<OrderItem> createOrderItemsWithRandomQuantity(List<Order> orders, PriceBookEntry pbEntry) {
        List<OrderItem> orderItems = new List<OrderItem>();
        Integer min = 1;
        Integer max = 10;
        Integer num;

        for (Order ord : orders) {
            num = (Integer) Math.floor(Math.random() * ( max - min + 1 ) + min);
            OrderItem orderItem = new OrderItem(
                    OrderId = ord.Id,
                    PricebookEntryId = pbEntry.Id,
                    UnitPrice = pbEntry.UnitPrice,
                    Quantity = num
            );
            orderItems.add(orderItem);
        }
        insert orderItems;
        return orderItems;
    }

}
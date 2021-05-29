/**
 * Created by lilas on 29/05/2021.
 * Class to Display Team Orders  display all orders by role according to the UserRole
 */

public with sharing class MyTeamOrdersController {
    /**
     * @description this method return a Map
     *
     * @return a Map<String,List<Order>> where the String containing the role and where the List contains all the order
     */
    @AuraEnabled
    public static Map<String, List<Order>> getAllOrderByRole() {
        /**********************************************************************************
        **** Represents a collection of unique roleName and the role of the current user***
        ***********************************************************************************/
        Set<String> profileName = new Set<String>();
        String uRoleId = UserInfo.getUserRoleId();
        /**
         *  @the result return a Map<String,List<Order>> where the key is the name and the value is an order
        */
        Map<String, List<Order>> result = new Map<String, List<Order>>();

        /**
         * The List of the order where the Roleid is the same that the user
        */
        List<Order> orders = new List<Order>();
        orders = [
                SELECT OwnerId, OrderNumber, Status, Id, TotalAmount, AccountId, Account.Name, Contract.ContractNumber, Name, Owner.Name, Owner.UserRole.Name, ShipmentCost__c, NetAmount__c
                FROM Order
                WHERE Status = 'Activated'
                AND Owner.UserRole.Id = :uRoleId
                ORDER BY Owner.UserRole.Name
        ];
        /**
        *for each order in the list , the result is set with a key and one list of orders as the value
         * the result is added to the result Map<String, List<Order>>
         *     @example Map("VP, North American Sales", List<Order>);
        */
        for (Order ord : orders) {
            profileName.add(ord.Owner.UserRole.Name);
            if (result.containsKey(ord.Owner.UserRole.Name)) {
                List<Order> orderList = result.get(ord.Owner.UserRole.Name);
                orderList.add(ord);
                result.put(ord.Owner.UserRole.Name, orderList);
            } else {
                result.put(ord.Owner.UserRole.Name, new List<Order>{
                        ord
                });
            }
        }

        return result;
    }

}
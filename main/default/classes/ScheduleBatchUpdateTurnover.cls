/**
 * Created by lilas on 31/05/2021.
 */

global class ScheduleBatchUpdateTurnover implements Schedulable {
    global void execute(SchedulableContext ctx) {
        UpdateAccountTurnoverBatch uppAcc = new UpdateAccountTurnoverBatch();
        Id batchId = Database.executeBatch(uppAcc,100);

    }
}
trigger OpportunityScheduleUpdate on OpportunityLineItemSchedule (after update, after delete, after insert) {
 
    if (Trigger.isDelete) {
        OpportunityLineItemScheduleHandler.storeDeletedSchedules(Trigger.old);
        System.debug('Deleted schedules stored: ' + Trigger.old);
    }
 
    if (Trigger.isInsert) {
        List<Id> newScheduleIds = new List<Id>();
        for (OpportunityLineItemSchedule newSchedule : Trigger.new) {
            newScheduleIds.add(newSchedule.Id);
        }
        System.debug('New Schedule IDs: ' + newScheduleIds);

        OpportunityLineItemScheduleHandler.enqueueNewScheduleUpdates(newScheduleIds);
    }
}
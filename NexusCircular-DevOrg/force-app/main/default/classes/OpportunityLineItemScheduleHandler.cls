//Author - Sunny Yadav
//Date - 12/01/2024
//Functionality - Opportunity line Item Schedule updates 


public class OpportunityLineItemScheduleHandler {
    private static Map<Date, OpportunityLineItemSchedule> deletedSchedulesMap = new Map<Date, OpportunityLineItemSchedule>();
    private static Map<Integer, OpportunityLineItemSchedule> SorteddeletedSchedulesMap = new Map<Integer, OpportunityLineItemSchedule>();
    private static Integer scheduleCounter = 1;
 
    public static void storeDeletedSchedules(List<OpportunityLineItemSchedule> deletedSchedules) {
        for (OpportunityLineItemSchedule oldSchedule : deletedSchedules) {
            deletedSchedulesMap.put(oldSchedule.ScheduleDate, oldSchedule);
            }
        List<Date> ListDates = new List<Date>();
        for(Date dates : deletedSchedulesMap.keySet()){
            ListDates.add(dates);
        }
        ListDates.Sort(); 
        for(date dates : ListDates){
            SorteddeletedSchedulesMap.put(scheduleCounter++,deletedSchedulesMap.get(dates));
            }
    }
    public class UpdateNewSchedulesQueueable implements Queueable {
        private List<Id> newScheduleIds;
        private Map<Integer, OpportunityLineItemSchedule> SorteddeletedSchedulesMap;
 
        public UpdateNewSchedulesQueueable(List<Id>  newScheduleIds, Map<Integer, OpportunityLineItemSchedule> SorteddeletedSchedulesMap) {
            this.newScheduleIds = newScheduleIds;
            this.SorteddeletedSchedulesMap = SorteddeletedSchedulesMap;
        }
 
        public void execute(QueueableContext context) {
            Date Today = Date.Today();
            Integer DayOfMonth = Today.day();
    		List<OpportunityLineItemSchedule> newSchedules = [
        	SELECT Id, OpportunityLineItemId, Actual_Cost__c, Delivered_Quantity__c, ScheduleDate
        	FROM OpportunityLineItemSchedule
        	WHERE Id IN :newScheduleIds
        	ORDER BY ScheduleDate ASC  
    ];
            List<OpportunityLineItemSchedule> schedulesToUpdate = new List<OpportunityLineItemSchedule>();
			Integer LoopCounter=0;
            for (OpportunityLineItemSchedule newSchedule : newSchedules) {
                LoopCounter = LoopCounter+1;
                OpportunityLineItemSchedule oldSchedule = SorteddeletedSchedulesMap.get(LoopCounter);
                if (oldSchedule != null) {
                    if(oldSchedule.Actual_Cost__c != null || oldSchedule.Delivered_Quantity__c != null){
                       
                        newSchedule.Actual_Cost__c = oldSchedule.Actual_Cost__c;
                        newSchedule.Delivered_Quantity__c = oldSchedule.Delivered_Quantity__c;
                        newSchedule.scheduleDate = oldSchedule.ScheduleDate;
                        
                        if (DayOfMonth>15 && oldSchedule.ScheduleDate.Month() == Today.Month()){
                             newschedule.Quantity = oldSchedule.Quantity;
                       		 
                        }
                        schedulesToUpdate.add(newSchedule);
                    
                        }
                    
                   
                   Else if (DayOfMonth>15 && oldSchedule.ScheduleDate.Month() == Today.Month()){
                    	newschedule.Quantity = oldSchedule.Quantity;
                        schedulesToUpdate.add(newSchedule);
                       
                }}
                }
            
            if (!schedulesToUpdate.isEmpty()) {
                update schedulesToUpdate;
            }
        }
    }
 
    public static void enqueueNewScheduleUpdates(List<Id> newScheduleIds) {
        System.enqueueJob(new UpdateNewSchedulesQueueable(newScheduleIds, SorteddeletedSchedulesMap));
    }
}
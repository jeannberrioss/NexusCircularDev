public class OpportunityScheduleUpdateDeleteHndler {
    
    public static void OpportunityAfterDelete(List<OpportunityLineItemSchedule> OldOppSchedule){
        List<OpportunityLineItemSchedule> NewOpp = new List<OpportunityLineItemSchedule>();
        Set<id> OppSchId = new Set<id>();
        Set<Id> OppId  = new Set<id>();
        System.debug('OldOppSchedule '+OldOppSchedule);
        for(OpportunityLineItemSchedule oppSch : OldOppSchedule ){
            OppId.add(oppSch.psi_Opportunity__c);
                    
        }
        System.debug('OppId '+OppId);
        //List<Opportunity> ListOppo = [Select id from Opportunity where id In :OppSchId];
        List<OpportunityLineItemSchedule> AllRelated = [Select id,psi_Opportunity__c from OpportunityLineItemSchedule where psi_Opportunity__c In : OppId];
        System.debug('AllRelated '+AllRelated);
        for(OpportunityLineItemSchedule OppUpdate : OldOppSchedule){
            OpportunityLineItemSchedule newOppSch = new OpportunityLineItemSchedule();
            
        }
        
        
    }

}
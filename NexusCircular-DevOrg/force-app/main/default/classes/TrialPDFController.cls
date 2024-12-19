public class TrialPDFController {
    public List<Trial__c> trials { get; private set; }

    
    public TrialPDFController(ApexPages.StandardController stdController) {
        Opportunity opp = (Opportunity)stdController.getRecord();
         
        
        trials = [SELECT Name, Related_Account__c, Description__c, Opportunity__r.Name, Opportunity_Owner__c, Trial_Type__c, Special_Requests_for_Lab_Testing__c
                  FROM Trial__c 
                  WHERE Opportunity__c = :opp.Id and Trial_Type__c = 'Bench'];
    }
}
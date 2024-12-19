//Date  - 09-13-2024
//Author - Sunny yadav
@isTest
public class TrialPDFControllerTest {
    
    @testSetup
    static void setupTestData() {
        
        Account acc = new Account(Name = 'Test Account',Account_Level__c = 'National',
                                 EndUseSegment__c = 'Automotive',Type = 'Feedstock Supplier',
                                 Status__c='Prospect');
        insert acc;
        
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', 
                                          CloseDate = Date.today(), 
                                          StageName = 'Prospecting', 
                                          AccountId = acc.Id,
                                         End_Use_Segment__c = 'Automotive',
                                         End_Use_Sub_Segment__c= 'Dunnage & Transport Packaging',
                                         Value_Chain_Position__c = 'End User');
        insert opp;
        
        Trial__c trial1 = new Trial__c(Opportunity__c = opp.Id, 
                                       Trial_Type__c = 'Bench', 
                                      
                                       Description__c = 'Trial 1 Description');
                                       
        Trial__c trial2 = new Trial__c( 
                                       Opportunity__c = opp.Id, 
                                       Trial_Type__c = 'Bench', 
                                        
                                       Description__c = 'Trial 2 Description');
        
        insert new List<Trial__c>{trial1, trial2};
    }

    @isTest
    static void testTrialPDFController() {
        
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpp);
        
        
        TrialPDFController controller = new TrialPDFController(stdController);
        
        
        System.assertNotEquals(null, controller.trials);
        System.assertEquals(2, controller.trials.size());
        
        
        for (Trial__c trial : controller.trials) {
            System.assertEquals('Bench', trial.Trial_Type__c);
            System.assertEquals(testOpp.Id, trial.Opportunity__r.Id);
        }
    }
}
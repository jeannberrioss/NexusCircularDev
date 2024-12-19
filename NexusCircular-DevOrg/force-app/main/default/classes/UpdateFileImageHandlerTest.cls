@isTest
public class UpdateFileImageHandlerTest {
  	 @isTest
    static void testGenerateUrls() {
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test Content',
            PathOnClient = 'testpath',
            VersionData = Blob.valueOf('Test Content Data')
        );
        insert cv;  
		ContentDistribution cd = new ContentDistribution(
            Name = 'Test Content Distribution',
            ContentVersionId = cv.Id,
            PreferencesAllowOriginalDownload = true
        );
        insert cd;
        Account Acc = new Account(name = 'TestAccount',Account_Level__c = 'National');
        Insert Acc;
        Opportunity opp = new opportunity(Name = 'Test',AccountId = Acc.Id,StageName = 'Not Qualified',CloseDate = Date.valueOf('2023-12-31'),End_Use_Segment__c ='Other',
                                         End_Use_Sub_Segment__c = 'Other',Value_Chain_Position__c = 'Other');
        Insert opp;
        Trial__c trial = new Trial__c(Opportunity__c = opp.Id);
        insert trial;
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = trial.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1].ContentDocumentId,
            ShareType = 'V'
        );
        insert cdl;Test.startTest();
        UpdateFileImageHandler.generateUrls(new Set<Id>{ cv.Id });
        Test.stopTest();
        trial = [SELECT Id, Sample_Photos__c FROM Trial__c WHERE Id = :trial.Id];
        //System.assertEquals('<img src="' + cd.ContentDownloadUrl + '" />', trial.Sample_Photos__c, 'Sample_Photos__c should contain the image URL');
    }	
}
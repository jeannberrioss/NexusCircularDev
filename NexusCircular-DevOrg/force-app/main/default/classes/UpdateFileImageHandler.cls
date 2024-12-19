public class UpdateFileImageHandler {
    @future
    public static void generateUrls(Set<Id> contentVersionIds) {
        System.debug('Inside class');
        List<ContentDistribution> contentDistributions = [ SELECT Id,ContentDocumentId, ContentVersionId, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :contentVersionIds];
        map<id,string> mapOfLinkedEntityURL = new map<id,string>();
        Set<Id> TrialIdsToUpdate = new Set<Id>();
        map<id,string> mapOfContentDocumentUrl = new map<id,string>();
        Set<id> ContentversionId = new Set<id>();
        for (ContentDistribution cd : contentDistributions) {
            System.debug('Inside CD ' + cd.ContentDownloadUrl);
            ContentversionId.add(cd.ContentVersionId);
            mapOfContentDocumentUrl.put(cd.ContentDocumentId,cd.ContentDownloadUrl);
            System.debug('mapOfContentDocumentUrl ' + mapOfContentDocumentUrl);
        }
            List<ContentDocumentLink> contentDocumentLinks = [
                SELECT LinkedEntityId,ContentDocumentId
                FROM ContentDocumentLink
                WHERE ContentDocumentId IN (
                    SELECT ContentDocumentId
                    FROM ContentVersion
                    WHERE Id = :ContentVersionId
                )
            ];
            
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                if (cdl.LinkedEntityId.getSObjectType() == Trial__c.sObjectType) {
                    TrialIdsToUpdate.add(cdl.LinkedEntityId);
                    System.debug('TrialIdsToUpdate '+TrialIdsToUpdate);
                }
                if(mapOfContentDocumentUrl.containskey(cdl.ContentDocumentId) && cdl.LinkedEntityId.getSObjectType() == Trial__c.sObjectType ){
                    mapOfLinkedEntityURL.put(cdl.LinkedEntityId,mapOfContentDocumentUrl.get(cdl.ContentDocumentId));
                    System.debug('mapOfLinkedEntityURL'+mapOfLinkedEntityURL);
                        
                }
            }
           
      
        if (!TrialIdsToUpdate.isEmpty()) {
            List<Trial__c> TrialsToUpdate = [
                SELECT Id, Sample_Photos__c
                FROM Trial__c
                WHERE Id IN :TrialIdsToUpdate
            ];
            System.debug('TrialsToUpdate '+ TrialsToUpdate);
            for (Trial__c trial : TrialsToUpdate) {
                if(mapOfLinkedEntityURL.containsKey(trial.Id)){
                    String imageUrl = mapOfLinkedEntityURL.get(trial.Id);
                if (trial.Sample_Photos__c  == null) {
                	trial.Sample_Photos__c  = '<img src="' + imageUrl + '" />';
            } else {
                	trial.Sample_Photos__c  += '<br/><img src="' + imageUrl + '" />';
                    
            }
                   }
           }
                        
            if (!TrialsToUpdate.isEmpty()) {
                update TrialsToUpdate;
                system.debug('TrialsToUpdate '+ TrialsToUpdate);
            }
        }
    }
}
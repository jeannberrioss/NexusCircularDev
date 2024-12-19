public with sharing class SamplePDF {

  public List<Trial__c> trial { get; set; }

  public SamplePDF() {
    trial = [SELECT Trial__c.Name, Trial__c.Related_Account__c, Trial__c.Description__c, Trial__c.Opportunity__c, Trial__c.Opportunity_Owner__c FROM Trial__c];
  }

}
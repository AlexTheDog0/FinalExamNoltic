/**
 * Created by Alexander on 08.01.2022.
 */

public with sharing class ControllerLwc {

    @AuraEnabled(cacheable=true)
    public static List<Interview__c> getRelatedInterviews(Id contactId){
        return [SELECT Id,Name,Company__r.Name,Vacancy__r.Name,Interview_Date__c,RecordTypeId
        From Interview__c
        WHERE Candidate__c =: contactId
        AND RecordType = 'Interview'
        WITH SECURITY_ENFORCED];
    }

}
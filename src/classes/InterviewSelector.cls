/**
 * Created by Alexander on 09.01.2022.
 */

public with sharing class InterviewSelector {
    public static List<Interview__c> getInterviewsByIds(List<Id> ids){
        return  [SELECT Id,Name,Company__r.Name,Vacancy__r.Name,Interview_Date__c,Status__c
        From Interview__c
        WHERE Candidate__c IN: ids
        AND Status__c = 'New'
        WITH SECURITY_ENFORCED];
    }
}
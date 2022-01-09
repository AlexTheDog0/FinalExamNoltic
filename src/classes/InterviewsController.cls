/**
 * Created by Alexander on 09.01.2022.
 */

public with sharing class InterviewsController {
    @AuraEnabled(cacheable=true)
    public static List<Interview__c> getRelatedInterviews(Id contactId){
        return InterviewSelector.getInterviewsByIds(new List<Id> { contactId });
    }
}
/**
 * Created by Alexander on 07.01.2022.
 */

trigger InterviewTrigger on Interview__c (before insert,before update ) {

    if(Trigger.isInsert) {
        for (Interview__c interview : Trigger.new) {


            //Evaluating the date of week beginning
            Date startOfWeek = Date.today().toStartOfWeek();
            Integer startDay = startOfWeek.day();
            Integer startMonth = startOfWeek.month();
            Integer startYear = startOfWeek.year();

            Date weekEnd = Date.newInstance(startYear, startMonth, startDay + 6);

            Id CurrentOwner = interview.OwnerId;

            AggregateResult[] results = [
                    SELECT COUNT(Id) amount
                    FROM Interview__c
                    WHERE OwnerId = :CurrentOwner
                    AND CreatedDate >= :startOfWeek
                    AND CreatedDate <= :weekEnd
            ];

            if ((Integer) results[0].get('amount') >= 3) {
                interview.addError('To much interviews on this week');
            }

            //Add this interview to general amount of interviews for related candidate
            Contact relatedCandidate = [SELECT Id,Amount_of_Interviews__c
            FROM Contact
            WHERE Id =: interview.Candidate__c
            LIMIT 1];

            relatedCandidate.Amount_of_Interviews__c += 1;

            update relatedCandidate;


        }
    }
    else if(Trigger.isUpdate){

        Map<Id,Interview__c> oldValues = Trigger.oldMap;

        for(Interview__c interview:Trigger.new){

            if(oldValues.get(interview.Id).Status__c != interview.Status__c){

                if(interview.Status__c == 'Selected') {
                    RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Offer' AND SobjectType = 'Interview__c' LIMIT 1];
                    interview.RecordTypeId = rt.Id;

                    Contact relatedCandidate = [SELECT Id,Successful_interview__c
                    FROM Contact
                    WHERE Id =: interview.Candidate__c
                    LIMIT 1];

                    relatedCandidate.Successful_interview__c += 1;

                    update relatedCandidate;
                }

                else if(interview.Status__c == 'Rejected'){
                    interview.Active__c = false;
                }

            }
        }
    }

}
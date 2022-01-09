/**
 * Created by Alexander on 09.01.2022.
 */

@IsTest
public with sharing class TestDataFactory {

    public static Interview__c getTestInterview(Integer hours) {
        Account testCompany = new Account(Name = 'SuperCompany');
        insert testCompany;
        Id testCompanyId = [SELECT Id FROM Account WHERE Name = 'SuperCompany'].Id;

        //Creating test Vacancy
        Vacancy__c testVacancy = new Vacancy__c(Company__c = testCompanyId, Name = 'SuperVacancy');
        insert testVacancy;
        Id testVacancyId = [SELECT Id FROM Vacancy__c WHERE Company__c = :testCompanyId AND Name = 'SuperVacancy'].Id;

        //Creating test candidate
        Contact testCandidate = new Contact(FirstName = 'Johny', LastName = 'Depp', Email = 'dotkaever41@gmail.com');
        insert testCandidate;
        Id testCandidateId = [SELECT Id FROM Contact WHERE FirstName = 'Johny' AND LastName = 'Depp'].Id;

        //Creating tes Interviews
        Id ownerId = '0057Q000002JxOEQA0';
        Datetime today = Date.today();
        today.addHours(hours);

        Interview__c inter = new Interview__c(
                Company__c = testCompanyId,
                Vacancy__c = testVacancyId,
                Candidate__c = testCandidateId,
                Interview_Date__c = today,
                OwnerId = ownerId);

        return inter;
    }



}
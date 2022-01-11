/**
 * Created by Alexander on 09.01.2022.
 */

@IsTest
public with sharing class TestTrigger {

    @IsTest
    static void PreventCreationTest(){
        //Creating Test Company
        Account testCompany = new Account(Name = 'SuperCompany');
        insert testCompany;
        Id testCompanyId = [SELECT Id FROM Account WHERE Name = 'SuperCompany'].Id;

        //Creating test Vacancy
        Vacancy__c testVacancy = new Vacancy__c(Company__c = testCompanyId,Name = 'SuperVacancy');
        insert  testVacancy;
        Id testVacancyId = [SELECT Id FROM Vacancy__c WHERE Company__c =: testCompanyId AND Name = 'SuperVacancy'].Id;

        //Creating test candidate
        Contact testCandidate = new Contact(FirstName = 'Johny' , LastName = 'Depp',Email = 'dotkaever41@gmail.com');
        insert testCandidate;
        Id testCandidateId = [SELECT Id FROM Contact WHERE FirstName = 'Johny' AND LastName = 'Depp'].Id;

        //Creating tes Interviews
        Id ownerId = '0057Q000002JxOEQA0';
        Datetime today = Date.today();

        Interview__c inter1 = new Interview__c(
                Company__c = testCompanyId,
                Vacancy__c = testVacancyId,
                Candidate__c = testCandidateId,
                Interview_Date__c = today,
                OwnerId = ownerId);

        Interview__c inter2 = new Interview__c(
                Company__c = testCompanyId,
                Vacancy__c = testVacancyId,
                Candidate__c = testCandidateId,
                Interview_Date__c = today,
                OwnerId = ownerId);

        Interview__c inter3 = new Interview__c(
                Company__c = testCompanyId,
                Vacancy__c = testVacancyId,
                Candidate__c = testCandidateId,
                Interview_Date__c = today,
                OwnerId = ownerId);

        List<Interview__c> interviews = new List<Interview__c>{inter1,inter2,inter3};
        insert inter1;
        insert inter2;
        insert inter3;

        Interview__c inter4 = new Interview__c(
                Company__c = testCompanyId,
                Vacancy__c = testVacancyId,
                Candidate__c = testCandidateId,
                Interview_Date__c = today,
                OwnerId = ownerId);

        Test.startTest();
        try{
            Database.insert(inter4);
            System.assert(false,'Should failed due to bigger amount of interviews per week');
        }
        catch (DmlException ex){
            System.assert(ex.getMessage().contains('To much interviews on this week'));
        }
        Test.stopTest();


    }

    @IsTest
    static void updateOperationTestInterviewSelected(){
        Interview__c inter = TestDataFactory.getTestInterview(2);
        Id candidate = inter.Candidate__c;
        insert inter;
        inter = [SELECT Id,Status__c,RecordTypeId FROM Interview__c WHERE Candidate__c =: candidate];
        Test.startTest();
        inter.Status__c = 'Selected';
        update inter;
        Test.stopTest();

        inter = [SELECT Id,Status__c,RecordTypeId FROM Interview__c WHERE Candidate__c =: candidate];
        RecordType rt = [SELECT Id FROM RecordType WHERE Name='Offer' AND SobjectType='Interview__c'];

        System.assertEquals(inter.RecordTypeId,rt.Id);
    }

    @IsTest
    static void updateOperationTestInterviewRejected(){
        Interview__c inter = TestDataFactory.getTestInterview(2);
        Id candidate = inter.Candidate__c;
        insert inter;
        inter = [SELECT Id,Status__c,Active__c FROM Interview__c WHERE Candidate__c =: candidate];
        Test.startTest();
        inter.Status__c = 'Rejected';
        update inter;
        Test.stopTest();

        inter = [SELECT Id,Status__c,Active__c FROM Interview__c WHERE Candidate__c =: candidate];

        //After Status__c changed to Rejected its expected field Active__c to be FALSE
        //That`s why ! operator is chosen
        System.assert(!inter.Active__c);
    }

}

/**
 * Created by Alexander on 09.01.2022.
 */

@IsTest
public with sharing class TestDataFactory {

    public static Id getTestInterviewRecord(String firstName,String lastName){

        return [SELECT Id From Contact WHERE FirstName =: firstName AND LastName =: lastName].Id;
    }

    private void createTestContact(){
        insert new Contact(FirstName = 'Test',LastName = 'Testovych');
    }

}
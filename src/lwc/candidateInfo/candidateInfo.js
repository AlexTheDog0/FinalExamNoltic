/**
 * Created by Alexander on 07.01.2022.
 */

import {LightningElement,api,wire,track} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';


import getRelatedInterviews from '@salesforce/apex/ControllerLwc.getRelatedInterviews';

const FIELDS = [
    'Contact.FirstName',
    'Contact.LastName',
    'Contact.Amount_of_Interviews__c',
    'Contact.Successful_interview__c'
];

const COLUMNS = [
    { label: 'Interview Id', fieldName: 'Name', type: 'text' },
    { label: 'Company', fieldName: 'Company__r.Name', type: 'text' },
    { label: 'Vacancy', fieldName: 'Vacancy__r.Name', type: 'text' },
    { label: 'Date', fieldName: 'Interview_Date__c', type: 'date' }
];

export default class CandidateInfo extends LightningElement {

    @api recordId;
    @track allActivitiesData;

    columns = COLUMNS;
    @wire(getRelatedInterviews,{contactId: '$recordId'})
    wireddata({error,data}){
        if(data){
            this.allActivitiesData = data.map(
                record => Object.assign(
                    {"Company__r.Name":record.Company__r.Name,"Vacancy__r.Name":record.Vacancy__r.Name},record
                )
            );
        }
        else if (error){
            this.error = error;
            this.allActivitiesData = undefined;
        }
    }


    @wire(getRecord,{recordId:'$recordId',fields: FIELDS})
    candidate;



    get firstName() {
        return this.candidate.data.fields.FirstName.value;
    }

    get lastName() {
        return this.candidate.data.fields.LastName.value;
    }

    get amountOfInterviews() {
        return this.candidate.data.fields.Amount_of_Interviews__c.value;
    }

    get successfulInterviews() {
        return this.candidate.data.fields.Successful_interview__c.value;
    }

    get percentage(){
        if(this.amountOfInterviews === 0) return 0;
        return ((this.successfulInterviews*100)/this.amountOfInterviews).toFixed(1);
    }

}


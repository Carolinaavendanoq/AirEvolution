import { LightningElement, api, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import FLIGHTNUMBER_FIELD from '@salesforce/schema/Product2.Name';
import PILOT_FIELD from '@salesforce/schema/Product2.Piloto__c';
import COPILOT_FIELD from '@salesforce/schema/Product2.Copiloto__c';
import getFlightAttendants from '@salesforce/apex/RequiredCrew.getFlightAttendants';
import saveFlightAttendants from '@salesforce/apex/RequiredCrew.saveFlightAttendants';

export default class ChooseCrewMembers extends LightningElement {
    @api flightId;
    flightNumber = FLIGHTNUMBER_FIELD;
    pilot = PILOT_FIELD;
    copilot = COPILOT_FIELD;
    
    confirmHandle(event){
        const evt = new ShowToastEvent({
            title: "Vuelo actualizado",
            // message: "",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }

}
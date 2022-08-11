import { LightningElement} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import RESERVEHOLDER_FIELD from '@salesforce/schema/Opportunity.Titular_de_reserva__c';



export default class CreateReservation extends LightningElement {
    objectApiName = OPPORTUNITY_OBJECT;
    fields = [RESERVEHOLDER_FIELD];


    
    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.StageName = "Pre-venta";
        fields.CloseDate = new Date().toISOString().slice(0, 10);
        fields.Name = "Crear";
        this.template.querySelector("lightning-record-form").submit(fields);
    }

    confirmHandle(event){
        const toastEvent = new ShowToastEvent({
            title: "Reserva creada",
            variant: "success",
        });
        this.dispatchEvent(toastEvent);
    }

}
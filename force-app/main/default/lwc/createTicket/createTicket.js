import { LightningElement, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import checkContact from '@salesforce/apex/obtainFlights.verifyContact';
import createNewTicket from '@salesforce/apex/obtainFlights.createTicket';

import OPPORTUNITYLINEITEM_OBJECT from '@salesforce/schema/OpportunityLineItem';
import PASSENGER_FIELD from '@salesforce/schema/OpportunityLineItem.Pasajero__c';
import BOARDINGATE_FIELD from '@salesforce/schema/OpportunityLineItem.Puerta_de_embarque__c';
import ALLOWEDLUGGAGE_FIELD from '@salesforce/schema/OpportunityLineItem.Equipaje_permitido__c';
import ADDITIONALLUGGAGE_FIELD from '@salesforce/schema/OpportunityLineItem.Equipaje_de_bodega_adicional__c';


export default class CreateTicket extends LightningElement {
    objectApiName = OPPORTUNITYLINEITEM_OBJECT;
    fields = [PASSENGER_FIELD, BOARDINGATE_FIELD , ALLOWEDLUGGAGE_FIELD, ADDITIONALLUGGAGE_FIELD];


    @api idReserve;
    @api idFlight;

    searchClients;
    value = 'Cédula de ciudadanía';
    identityNumber; // almacena cada valor ingresado
    showCreateContact;
    customer;
    error;
    contactId;
    showButton;
    newTicket;

    get options(){
        return[{
            label: 'Cédula de ciudadanía', value: 'Cédula de ciudadanía'
        }, {
            label: 'Cédula de extranjería', value: 'Cédula de extranjería'
        }, {label: 'Tarjeta de identidad', value: 'Tarjeta de identidad'}]
    }

    handleSubmit(event){
        event.preventDefault();
        this.showButton = true;
        const fields = event.detail.fields;
        fields.OpportunityId = this.idReserve;
        fields.Product2Id = this.idFlight;
        this.template.querySelector("lightning-record-form").submit(fields);
    }

    confirmHandle(event){
        const evt = new ShowToastEvent({
            title: "Tiquete creado",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }

    addTicket(event){
        this.searchClients = true;
    }

    searchClient(event){
        checkContact({idType: this.value, idNumber: this.identityNumber})
        .then((result) => {
            this.customer = result;
            this.error = undefined;
            this.contactId = this.customer.Id;
            this.showCreateContact = false;
            this.createNewTickets();
        }).catch((error)=> {
            this.customer = undefined;
            this.error = error;
            this.showCreateContact = true;
        });
    }

    createNewTickets(event){
        createNewTicket({bookingId: this.idReserve, flightId: this.idFlight, customerId: this.contactId})
        .then((result)=>{
            this.newTicket = result;
            const evt = new ShowToastEvent({
                title: 'Tiquete creado',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        }).catch((error) => {

        });
    }

    handleChange(event){
        switch (event.target.name) {
            case 'typeId':
                this.value = event.detail.value;
                break;
        
            case 'idNum':
                this.identityNumber =  event.detail.value;
                break;
        }
    }

    confirmClient(event){
        const toastEvent = new ShowToastEvent({
            title: 'Contacto creado',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }

}
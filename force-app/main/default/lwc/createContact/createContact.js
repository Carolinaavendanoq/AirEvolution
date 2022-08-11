import { LightningElement, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import checkContact from '@salesforce/apex/obtainFlights.verifyContact';
import checkReservation from '@salesforce/apex/obtainFlights.verifyReservation';
import obtainPricebooks from '@salesforce/apex/obtainFlights.obtainPricebooks';
import updateBooking from '@salesforce/apex/obtainFlights.updateReservation'; 
import finalBooking from '@salesforce/apex/obtainFlights.finalBooking'; 

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import PASSPORTNUMBER_FIELD from '@salesforce/schema/Contact.Numero_de_pasaporte__c';
import NATIONALITY_FIELD from '@salesforce/schema/Contact.Nacionalidad__c';
import BIRTHDATE_FIELD from '@salesforce/schema/Contact.Birthdate';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import ADDRESS_FIELD from '@salesforce/schema/Contact.MailingAddress';
import CELLPHONENUMBER_FIELD from '@salesforce/schema/Contact.Phone';
import HOMEPHONE_FIELD from '@salesforce/schema/Contact.HomePhone';

import NAME_FIELD from '@salesforce/schema/Pricebook2.Name';


const actions = [
    {label: 'Asignar lista de precios', name: 'pricebook'},
];

const COLUMNS = [
    {label: "Nombre de la lista de precios", fieldName: NAME_FIELD.fieldApiName, type:"text"},
    {type: 'action', typeAttributes: {rowActions: actions}},
];

export default class CreateContact extends NavigationMixin (LightningElement) {
    value = 'Cédula de ciudadanía';
    identityNumber; // almacena cada valor ingresado
    showCreateContact;
    contact;
    error;
    contactId;
    newReserve;
    reservationCreated;
    id;
    columns = COLUMNS;
    pricebookId;
    isModalOpen = false;
    finalBookingId;

    @wire(obtainPricebooks)
    pricebooks;

    objectApiName = CONTACT_OBJECT;
    fields = [FIRSTNAME_FIELD, LASTNAME_FIELD,PASSPORTNUMBER_FIELD, NATIONALITY_FIELD,BIRTHDATE_FIELD, EMAIL_FIELD, ADDRESS_FIELD,CELLPHONENUMBER_FIELD, HOMEPHONE_FIELD];


    get options(){
        return[{
            label: 'Cédula de ciudadanía', value: 'Cédula de ciudadanía'
        }, {
            label: 'Cédula de extranjería', value: 'Cédula de extranjería'
        }, {label: 'Tarjeta de identidad', value: 'Tarjeta de identidad'}]
    }

    get reserveId(){
        return this.id;
    }

    get id2Pricebook(){
        return this.pricebookId;
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

    searchContact(event){
        checkContact({idType: this.value, idNumber: this.identityNumber})
        .then((result) => {
            this.contact = result;
            this.error = undefined;
            this.contactId = this.contact.Id;
            this.showCreateContact = false;
            this.createReservation();
        }).catch((error)=> {
            this.contact = undefined;
            this.error = error;
            this.showCreateContact = true;
        });

    }


    createReservation(event){
        checkReservation({idContact: this.contactId})
        .then((result) => {
            if (result != null) {
                this.newReserve = result;
                this.reservationCreated = true;
                this.id = result.Id;
            }else{
                const evt = new ShowToastEvent({
                    title: 'Reserva Existente',
                    message: 'Cliente con reserva pendiente',
                    variant: 'warning',
                });
                this.dispatchEvent(evt);
                this[NavigationMixin.Navigate]({type: 'standard__recordPage', attributes: {recordId: this.contactId,  actionName: 'view'}});
            }
        }).catch((err) => {

        });
    }

    handleRowAction(event){
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'pricebook':
                this.pricebookId = row.Id;
                this.bookingUpdated();
                break;
        }

    }

    bookingUpdated(event){
        updateBooking({idReserve: this.id, idPricebook2: this.pricebookId})
        .then((result) => {
            this.isModalOpen = true;
        }).catch((err) => {

        });
    }


    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Tipo_de_Identificacion__c = this.value;
        fields.Numero_de_identificacion__c = this.identityNumber;
        this.template.querySelector("lightning-record-form").submit(fields);
    }

    confirmHandle(event){
        const toastEvent = new ShowToastEvent({
            title: 'Contacto creado',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }


    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }


    handleSelect(){
        finalBooking({idReserve: this.id})
        .then((result) => {
            this.isModalOpen = false;
            this.reservationCreated = false;
            this.finalBookingId = result.Id;
            this[NavigationMixin.Navigate]({type: 'standard__recordPage', 
            attributes: {recordId: this.finalBookingId,  actionName: 'view'},
         });
        }).catch((err) =>{

        });
    }

}
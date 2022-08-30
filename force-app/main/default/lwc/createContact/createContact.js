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

 /* Un servicio de cable que está llamando al método obtainPricebooks. */
    @wire(obtainPricebooks)
    pricebooks;

    objectApiName = CONTACT_OBJECT;
    fields = [FIRSTNAME_FIELD, LASTNAME_FIELD,PASSPORTNUMBER_FIELD, NATIONALITY_FIELD,BIRTHDATE_FIELD, EMAIL_FIELD, ADDRESS_FIELD,CELLPHONENUMBER_FIELD, HOMEPHONE_FIELD];


    /**
     * La función devuelve una lista de opciones, cada opción tiene una etiqueta y una propiedad de
     * valor
     */
    get options(){
        return[{
            label: 'Cédula de ciudadanía', value: 'Cédula de ciudadanía'
        }, {
            label: 'Cédula de extranjería', value: 'Cédula de extranjería'
        }, {label: 'Tarjeta de identidad', value: 'Tarjeta de identidad'}]
    }

/**
 * Devuelve el valor de la propiedad id.
 */
    get reserveId(){
        return this.id;
    }

/**
 * La función devuelve el valor de la propiedad 'pricebookId'
 */
    get id2Pricebook(){
        return this.pricebookId;
    }

/**
 * La función toma un evento y, según el nombre del evento, establecerá el valor de typeId o
 * IdentityNumber.
 */
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

/**
 * La función se llama cuando el usuario hace clic en el botón buscar. Llama a la función
 * checkContact, que retorna un contacto. La propiedad contacto recibe el
 * resultado, el error se establece en indefinido, a contactId se le establece el Id. del
 * contacto, la variable showCreateContact se establece en falso y se llama a la función
 * createReservation. Si hay un error, el contacto se establece en indefinido, el error se
 * establece en el error, la variable showCreateContact se establece en verdadero
 */
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


/**
 * La función crea una reserva para un contacto.
 */
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
                // Redirige a la página de contacto del cliente que ya tiene reserva
                this[NavigationMixin.Navigate]({type: 'standard__recordPage', attributes: {recordId: this.contactId,  actionName: 'view'}});
            }
        }).catch((err) => {

        });
    }

 /**
  * La función se llama cuando un usuario hace clic en una acción de la tabla. Luego, la función llama a
  * la función bookingUpdated()
  */
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

/**
 * La función se llama cuando el usuario hace clic en la acción "asignar a reserva". Llama al
 * controlador de Apex para actualizar la reserva
 */
    bookingUpdated(event){
        updateBooking({idReserve: this.id, idPricebook2: this.pricebookId})
        .then((result) => {
            this.isModalOpen = true;
            this.reservationCreated = false;
        }).catch((err) => {

        });
    }


/**
 * La función se llama cuando el usuario hace clic en el botón Enviar. Impide la acción predeterminada
 * del botón de envío, que es enviar el formulario. Luego asigna el value de la opción seleccionada al
 * campo Tipo_de_Identificacion__c y el valor la propiedad identityNumber al campo
 * Numero_de_identificacion__c. Finalmente, envía el formulario
 */
    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Tipo_de_Identificacion__c = this.value;
        fields.Numero_de_identificacion__c = this.identityNumber;
        this.template.querySelector("lightning-record-form").submit(fields);
    }

/**
 * Crea un mensaje de Toast cuando el usuario hace clic en el botón Guardar.
 */
    confirmHandle(event){
        const toastEvent = new ShowToastEvent({
            title: 'Contacto creado',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }


/**
 * La función closeModal() establece el valor de isModalOpen en falso, lo que cierra el modal
 */
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.reservationCreated = true;
    }


 /**
  * La función se llama cuando el usuario hace clic en el botón "Finalizar" en el modal. Llama al
  * método de Apex finalBooking() y pasa el id de reserva. El método de Apex
  * devuelve el id del registro de reserva final. La función luego navega a la página de
  * registro de reserva final
  */
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
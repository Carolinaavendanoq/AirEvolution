import { LightningElement, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import checkContact from '@salesforce/apex/obtainFlights.verifyContact';
import createNewTicket from '@salesforce/apex/obtainFlights.createTicket';

import OPPORTUNITYLINEITEM_OBJECT from '@salesforce/schema/OpportunityLineItem';
import PASSENGER_FIELD from '@salesforce/schema/OpportunityLineItem.Pasajero__c';
import BOARDINGATE_FIELD from '@salesforce/schema/OpportunityLineItem.Puerta_de_embarque__c';
import ALLOWEDLUGGAGE_FIELD from '@salesforce/schema/OpportunityLineItem.Equipaje_permitido__c';
import ADDITIONALLUGGAGE_FIELD from '@salesforce/schema/OpportunityLineItem.Equipaje_de_bodega_adicional__c';


export default class CreateTicket extends LightningElement{
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

/**
 * Devuelve lista de opciones, cada elemento tiene una etiqueta y una propiedad de valor
 */
    get options(){
        return[{
            label: 'Cédula de ciudadanía', value: 'Cédula de ciudadanía'
        }, {
            label: 'Cédula de extranjería', value: 'Cédula de extranjería'
        }, {label: 'Tarjeta de identidad', value: 'Tarjeta de identidad'}]
    }

/**
 * La función se llama cuando el usuario hace clic en el botón Enviar en el formulario. Impide la
 * acción predeterminada del botón, que es enviar el formulario. Luego establece la variable showButton
 * en verdadero, lo que hará que el botón aparezca. Luego establece los campos OpportunityId y
 * Product2Id en los valores de las variables idReserve e idFlight, que se establecieron en la función
 * handleSuccess. Finalmente, envía el formulario
 */
    handleSubmit(event){
        event.preventDefault();
        this.showButton = true;
        const fields = event.detail.fields;
        fields.OpportunityId = this.idReserve;
        fields.Product2Id = this.idFlight;
        this.template.querySelector("lightning-record-form").submit(fields);
    }

/**
 * Crea un mensaje de Toast que aparece en la pantalla cuando el usuario hace clic en el botón
 * Enviar.
 */
    confirmHandle(event){
        const evt = new ShowToastEvent({
            title: "Tiquete creado",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }

 /**
  * Esta función se llama cuando el usuario hace clic en el botón "Agregar ticket". Establece el valor
  * de la variable searchClients en verdadero
  */
    addTicket(event){
        this.searchClients = true;
    }

/**
 * La función se llama cuando el usuario hace clic en el botón de buscar. Llama al método de Apex
 * 'checkContact' y pasa el valor de la propeidad 'identityNumber' y el valor de la propiedad 'value' del
 * elemento 'select'. El método 'checkContact' devuelve un contacto que se resuelve con el registro
 * de contacto si existe, o se rechaza con un mensaje de error si no existe. Si devuelve el contacto se
 * la propiedad 'customer' se establece en el registro de contacto, el atributo 'error' se
 * establece en 'indefinido', la propeidad 'contactId' se establece en el Id. del contacto, el atributo
 * 'showCreateContact' se establece a 'false', y se llama al método 'createNewTickets'. 
 */
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

/**
 * Crea un nuevo ticket para el cliente.
 */
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

/**
 * La función toma un evento y, según el nombre del evento, establecerá el valor de la variable en el
 * valor del evento.
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

    confirmClient(event){
        const toastEvent = new ShowToastEvent({
            title: 'Contacto creado',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }

}
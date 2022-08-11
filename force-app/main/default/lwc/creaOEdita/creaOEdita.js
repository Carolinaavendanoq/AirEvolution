import { api, LightningElement, wire } from 'lwc';
import {createRecord,  getRecord, getFieldValue} from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact'
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import TITULARDERESERVA_FIELD from '@salesforce/schema/Opportunity.Titular_de_reserva__c';
import ESTADO_FIELD from '@salesforce/schema/Opportunity.StageName';
import NOMBREDERESERVA_FIELD from '@salesforce/schema/Opportunity.Name';
import NUMERODERESERVA_FIELD from '@salesforce/schema/Opportunity.Numero_de_reserva__c';
import FECHADEPAGO_FIELD from '@salesforce/schema/Opportunity.CloseDate';



export default class creaOEdita extends LightningElement {
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields: [NAME_FIELD]}) record;


    objectApiName = OPPORTUNITY_OBJECT;
    opportunityId;
    estado = 'Pre-venta';
    fecha = new Date().toISOString().slice(0, 10);

    get contactName(){
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD) : '';
    }

    createOpportunity(){
        const fields = {}
        fields[TITULARDERESERVA_FIELD.fieldApiName] = this.recordId;
        fields[ESTADO_FIELD.fieldApiName] = this.estado;
        fields[NOMBREDERESERVA_FIELD.fieldApiName] = this.contactName + this.numeroAleatorio;
        // fields[NUMERODERESERVA_FIELD.fieldApiName] = this.numeroAleatorio;
        fields[FECHADEPAGO_FIELD.fieldApiName] = this.fecha;
       
        const recordInput ={apiName: OPPORTUNITY_OBJECT.objectApiName, fields };
        console.log(recordInput);
        createRecord(recordInput)
        .then(opportunity => {
            this.opportunityId = opportunity.id;
            console.log(fields);
            console.log('Cuenta agregada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }

}
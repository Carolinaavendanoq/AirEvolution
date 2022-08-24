import { LightningElement, api, wire } from 'lwc';
// import {ShowToastEvent} from 'lightning/platformShowToastEvent';
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
    options = [];
    values = [];
    _selected = [];

/**
 * Se llama a la función cuando se carga el componente y llama al método getFlightAttendants de Apex,
 * que devuelve una lista de auxiliares de vuelo. Luego, la lista se asigna a una lista de opciones y
 * valores para el componente lightning-dual-listbox
 */
    @wire(getFlightAttendants, {idFlight: '$flightId'})
    crewMembers({error, data}){
        if (data) {
            this.options = data.map(key => ({value: key.value, label: key.label}));
            this.values = data.filter(element => element.selected == true).map(key => key.value);
        } else if(error){
            console.log('error-->'+JSON.stringify(error));
        }
    }

/**
 * La función se llama cuando el usuario selecciona un nuevo valor del menú
 * desplegable. Establece la propiedad '_selected' al valor de la opción seleccionada
 */
    handleChange(e){
        this._selected = e.detail.value;
    }

/**
 * Guarda los asistentes de vuelo seleccionados en la base de datos.
 */
    handleSuccess(event){
        if(this._selected.length == 0){
            this._selected = this.values;
        }
        saveFlightAttendants({flightAttendants : this._selected, idFlight : this.flightId})
        .then((result)=> {
            this.error = undefined;
        })
        .catch((error)=> {
            this.error = error;
        });

    }

    /*
    confirmHandle(event){
        const evt = new ShowToastEvent({
            title: "Actualización exitosa",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }
    */
}
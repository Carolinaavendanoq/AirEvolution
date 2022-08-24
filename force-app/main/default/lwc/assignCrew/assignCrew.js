import { LightningElement, wire } from 'lwc';
import obtainFlights from '@salesforce/apex/RequiredCrew.obtainFlights';

const actions = [
    {label: 'Asignar', name: 'asignar'},
];

const columns = [
    { label: 'Código', fieldName: 'flightCode' },
    { label: 'Auxiliares Requeridos', fieldName: 'flightAttendantsNum', type: 'number' },
    { label: 'Auxiliares Faltantes', fieldName: 'leftoverFlighAttendants', type: 'number' },
    { label: 'Tiene Piloto', fieldName: 'pilot', type: 'boolean' },
    { label: 'Tiene Copiloto', fieldName: 'copilot', type: 'boolean' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];

export default class AssignCrew extends LightningElement {
    isModalOpen;
    columns = columns;
    flightNumber;
    requiredFlightAttend;
    lackingFlightAttend;
    hasPilot;
    hasCopilot;
    id;
    _selected = [];
    
/**
 * Devuelve el valor de la propiedad id
 */
    get idFlight(){
        return this.id;
    }

    @wire(obtainFlights)
    flights;

/**
 * Esta función se llama cuando el usuario hace clic en la acción "Asignar" en la tabla. Abre el modal y
 * establece los valores del modal a los valores de la fila en la que el usuario hizo clic
 */
    handleRowAction(event){
        this.isModalOpen = true;
        const row  = event.detail.row;
        this.flightNumber = row.flightCode;
        this.requiredFlightAttend = row.flightAttendantsNum;
        this.lackingFlightAttend = row.leftoverFlighAttendants;
        this.hasPilot = row.pilot;
        this.hasCopilot = row.copilot;
        this.id = row.flightId;
    }

/**
 * La función se llama cuando el usuario hace clic en el encabezado de una sección. Luego, la función
 * actualiza la propiedad activeSectionMessage con el nombre de la sección en la que se hizo clic.
 */
    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }
    
/**
 * La función se llama cuando el usuario hace clic en el botón Cerrar en el modal. Establece la
 * propiedad isModalOpen en falso, lo que hace que el modal se cierre
 */
    closeModal(event){
        this.isModalOpen = false;
    }

/**
 * > El getter 'selected' devuelve la propiedad '_selected' si tiene una longitud, de lo contrario
 * devuelve la cadena 'none'
 */
    get selected(){
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e){
        this._selected = e.detail.value;
    }
}
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
    
    get idFlight(){
        return this.id;
    }

    @wire(obtainFlights)
    flights;

    handleRowAction(event){
        this.isModalOpen = true;
        const row  = event.detail.row;
        console.log(row);
        this.flightNumber = row.flightCode;
        this.requiredFlightAttend = row.flightAttendantsNum;
        this.lackingFlightAttend = row.leftoverFlighAttendants;
        this.hasPilot = row.pilot;
        this.hasCopilot = row.copilot;
        this.id = row.flightId;
    }

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }
    
    closeModal(event){
        this.isModalOpen = false;
    }
}
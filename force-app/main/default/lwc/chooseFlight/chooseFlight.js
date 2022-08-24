import { LightningElement, wire, api } from 'lwc';
import getFlights from '@salesforce/apex/obtainFlights.getFlights';

const actions = [
    {label: 'Asignar a reserva', name: 'assign'},
];

const COLUMNS = [
    {label: "Número de vuelo", fieldName: 'flightName', type: "text"},
    {label: "Aeropuerto de partida", fieldName: 'departureAirport', type: "text", wrapText: true},
    {label: "País de partida", fieldName: 'originCountry', type: "text", wrapText: true},
    {label: "Ciudad de partida", fieldName: 'originCity', type: "text", wrapText: true},
    {label: "Aeropuerto de llegada", fieldName: 'arrivalAirport', type: "text", wrapText: true},
    {label: "País de llegada", fieldName: 'destinationCountry', type: "text", wrapText: true},
    {label: "Ciudad de llegada", fieldName: 'destinationCity', type: "text", wrapText: true},
    {label: "Fecha y hora de partida", fieldName: 'departureDate', type: "date", wrapText: true},
    {label: "Precio de venta", fieldName: 'price', type: 'currency', wrapText: true},
    {type: 'action', typeAttributes: {rowActions: actions}},
];

export default class ChooseFlight extends LightningElement{
    columns = COLUMNS;
    id;
    isModalOpen;
    alphabet;
    filteredResults = [];
    currentLetter;
    elements = [];
    filtered = [];
   
    @api reservationId;
    @api pricebook2Id;

    @wire(getFlights,{pricebookId: '$pricebook2Id'}) 
    flights({data, error}){
        if (data) {
            this.filteredResults = data.filter(function(el){
                return el;
            }
          );
        } else if(error){
            
        }
    }

    connectedCallback() {
        this.alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        this.handleFilterChange();
    }

    get currentPage() {
        return this.filtered;
    }
    
    handleFilterChange(event) {
        if(event) {
            this.currentLetter = event.target.dataset.filter;
        }
        if (this.currentLetter) {
            this.filtered = this.filteredResults.filter(ele =>
                ele.destinationCountry.startsWith(this.currentLetter)
            );
        } else {
            this.filtered = [...this.filteredResults];
        }
        // this.filtered.sort((a,b) => a<b ? -1:1);
    }

    get fId(){
        return this.id;
    }

    handleRowAction(event){
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'assign':
                this.id = row.flightId;
                this.isModalOpen = true;
                break;
        }
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    submitDetails(){
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('select'));
    }
}
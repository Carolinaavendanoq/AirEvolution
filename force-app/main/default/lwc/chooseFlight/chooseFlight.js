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
    data = [];
    columns = COLUMNS;
    id;
    isModalOpen;
    alphabet;
    currentLetter;
    filteredResults = [];
    country = [];
   
    @api reservationId;
    @api pricebook2Id;

    @wire(getFlights,{pricebookId: '$pricebook2Id'})
    flights(result){
        if (result.data) {
            console.log('Entro al if');
            this.data = result.data;
            for (let i = 0; i < this.data.length; i++) {
                this.country.push(this.data[i].destinationCountry);
                console.log('pais ' + this.country);
            }
        }else if(result.error){
            console.log('Entro al error');
            this.error = result.error;
        }
    };


    get fId(){
        return this.id;
    }

    connectedCallback(){
        this.alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        this.handleFilterChange();
    }

    
    handleFilterChange(event){
        if(event){
            this.currentLetter = event.target.dataset.filter;
            console.log('letra ' + this.currentLetter);
        }
        if(this.currentLetter){
            this.filteredResults = this.data.filter((country) => country.startsWith(this.currentLetter));
            console.log('letra ' + this.currentLetter);
            console.log('array ' + this.filteredResults);
        }else{
            this.filteredResults = [...this.data];
            console.log('array ' + this.filteredResults);
        }
        this.filteredResults.sort((a,b) => a<b ? -1:1);
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
        console.log('datos ' + this.data);
    }

    submitDetails(){
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('select'));
    }
}
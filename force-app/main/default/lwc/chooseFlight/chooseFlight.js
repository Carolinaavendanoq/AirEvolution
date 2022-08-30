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

/**
 * Se llama a la función cuando se cambia la propiedad pricebook2Id. Llama al adaptador de cable
 * getFlights, que devuelve una lista de vuelos.
 */
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

    /**
     * Se llama a la función connectedCallback() cuando el elemento se inserta en el DOM
     */
    connectedCallback() {
        this.alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        this.handleFilterChange();
    }

    /**
     * La función devuelve la página actual con el filtrado.
     */
    get currentPage() {
        return this.filtered;
    }
    
/**
 * Si el evento no es nulo, establezca currentLetter en la letra en la que se hizo clic. Si
 * currentLetter no es nulo, filtre los resultados para mostrar solo los países que comienzan con
 * currentLetter. Si currentLetter es nulo, establezca los resultados filtrados en los resultados
 * filtrados originales
 */
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

/**
 * Devuelve el valor de la propiedad id.
 */
    get fId(){
        return this.id;
    }

/**
 * La función se llama cuando un usuario hace clic en una acción en el datatable. Luego, la función
 * establece la identificación del vuelo  en el que se hizo clic en la propiedad id y
 * abre el modal
 */
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

/**
 * La función closeModal() establece la propiedad isModalOpen en falso
 */
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

/**
 * La función 'submitDetails()' se llama cuando el usuario hace clic en el botón 'Enviar' en el modal.
 * Cierra el modal y envía un evento 'select'
 */
    submitDetails(){
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('select'));
    }
}
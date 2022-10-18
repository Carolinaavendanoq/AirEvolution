public with sharing class obtainFlights {

    // Obtiene los vuelos y sus precios de acuerdo a la categoría de lista de precio que se le da, retornando sólo aquellos vuelos con esa lista de precios, que estén activos y que su estado sea "En venta" o "Check in"
    @AuraEnabled(cacheable = true)
    public static List<Flight> getFlights(String pricebookId){
        try {

            List<Product2> flightList = [SELECT Id, Name,Aeropuerto_de_partida__r.Name,Aeropuerto_de_partida__r.Pais__c, Aeropuerto_de_partida__r.Ciudad__c, Aeropuerto_de_llegada__r.Name,Aeropuerto_de_llegada__r.Pais__c, Aeropuerto_de_llegada__r.Ciudad__c, Fecha_y_hora_de_partida__c, (SELECT UnitPrice FROM pricebookEntries WHERE Pricebook2Id =: pricebookId ) FROM Product2 WHERE IsActive = true AND Estado__c IN ('En venta', 'Check in')];

            List<Flight> obtainedFlights = new List<Flight>();

            for (Product2 flight : flightList) {
                if (flight.PricebookEntries.size() > 0) {
                    obtainedFlights.add(new Flight((String)flight.Id, flight.Name, flight.Aeropuerto_de_partida__r.Name, flight.Aeropuerto_de_partida__r.Pais__c, flight.Aeropuerto_de_partida__r.Ciudad__c, flight.Aeropuerto_de_llegada__r.Name, flight.Aeropuerto_de_llegada__r.Pais__c, flight.Aeropuerto_de_llegada__r.Ciudad__c, flight.Fecha_y_hora_de_partida__c, flight.PricebookEntries[0].UnitPrice));
                }
            }
            return obtainedFlights;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Retorna las listas de precios activas
    @AuraEnabled(cacheable = true)
    public static List<Pricebook2> obtainPricebooks(){
        try {
            return [SELECT Id, Name  FROM Pricebook2 WHERE IsActive = true];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Verifica la existencia de un cliente dentro de la organización, determinándolo de acuerdo al tipo y número de identificación dados.
    @AuraEnabled
    public static Contact verifyContact(String idType, String idNumber ){
        try {
            Contact existingContact = [SELECT Id, Name,  Tipo_de_Identificacion__c,  Numero_de_identificacion__c FROM Contact WHERE Tipo_de_Identificacion__c =: idType AND Numero_de_identificacion__c =: idNumber LIMIT 1]; 
        
            return existingContact;
        } catch (Exception e) {
            return null;
        }
    }

    // Comprobar si un cliente tiene reservas en estado "Pre-venta" o "Completado", en caso de no tener se inserta una nueva reserva teniendo como titular a este cliente
    @AuraEnabled
    public static Opportunity verifyReservation(String idContact){
        
        try {
            date currentDate = date.today();
            List<Opportunity> contactReservation = [SELECT Id FROM Opportunity WHERE Titular_de_reserva__c =: idContact AND StageName IN ('Pre-venta', 'Completado')];
            
            if (contactReservation.size() == 0) {
                Opportunity reserve = new Opportunity( Titular_de_reserva__c = idContact, Name = 'New Reservation', StageName = 'Pre-venta', CloseDate = currentDate);
                insert reserve;
                return reserve;
                
            }else {
                return null;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    // Asigna una lista de precios a una reserva
    @AuraEnabled
    public static Opportunity updateReservation(String idReserve, String idPricebook2){
        try {
            Opportunity reservation = new Opportunity(Id = idReserve, Pricebook2Id = idPricebook2);

            update reservation;
            return reservation;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Actualiza el estado de la reserva a "Completado"
    @AuraEnabled
    public static Opportunity finalBooking(String idReserve){
        try {
            Opportunity reservation = new Opportunity(Id = idReserve, StageName = 'Completado');
            update reservation;
            return reservation;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Inserta tiquete, asignándole una reserva, un vuelo y un pasajero
    @AuraEnabled
    public static OpportunityLineItem createTicket(String bookingId, String flightId, String customerId){
        try {
            OpportunityLineItem ticket = new OpportunityLineItem(OpportunityId = bookingId, Product2Id = flightId, Pasajero__c = customerId);
            insert ticket;
            return ticket;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class Flight{
        @AuraEnabled 
        public String flightId;
        @AuraEnabled 
        public String flightName;
        @AuraEnabled 
        public String departureAirport;
        @AuraEnabled
        public String originCountry;
        @AuraEnabled
        public String originCity;
        @AuraEnabled 
        public String arrivalAirport;
        @AuraEnabled 
        public String destinationCountry;
        @AuraEnabled 
        public String destinationCity;
        @AuraEnabled 
        public Datetime departureDate;
        @AuraEnabled 
        public Decimal price;

        public flight(String flightId, String flightName, String departureAirport, String originCountry, String originCity, String arrivalAirport, String destinationCountry, String destinationCity, Datetime departureDate, Decimal price){
            this.flightId = flightId;
            this.flightName = flightName;
            this.departureAirport = departureAirport;
            this.originCountry = originCountry;
            this.originCity = originCity;
            this.arrivalAirport = arrivalAirport;
            this.destinationCountry = destinationCountry;
            this.destinationCity = destinationCity;
            this.departureDate = departureDate;
            this.price = price;
        }

    }

}
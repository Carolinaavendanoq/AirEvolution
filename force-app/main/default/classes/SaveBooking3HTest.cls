@isTest
public with sharing class SaveBooking3HTest {
    @testSetup
    static void makeData(){
        Datetime departureDate = datetime.now();
        Datetime arrivalDate = datetime.now();
        Date currentDate = date.today();
        // Obtener lista de precio estándar y crear listas de precios
        String pricebookId = Test.getStandardPricebookId();
        Pricebook2 tourist = new Pricebook2(Name = 'Clase turista',IsActive = true);
        insert tourist;
        
        Pricebook2 business = new Pricebook2(Name = 'Clase negocio',IsActive = true);
        insert business;
        Pricebook2 cargo = new Pricebook2(Name = 'Carga');
        insert cargo;
 
        // Crear contacto
        Contact customer = new Contact(firstName = 'Contact', LastName = 'Test', Numero_de_identificacion__c = '1235245', Tipo_de_Identificacion__c = 'Cédula de Ciudadanía', email = 'contact@mail.com');
        insert customer;

        // Crear reserva a contacto
        Opportunity booking = new Opportunity(Titular_de_reserva__c =customer.Id , StageName = 'Pre-venta', CloseDate = currentDate, Name = 'w', Pricebook2Id = business.Id);
        insert booking;

        // Creaar avión
        Avion__c plane = new Avion__c(Tipo__c = 'Airbus A330', Numero_de_pasajeros_clase_turista__c = 46, Numero_de_pasajeros_clase_negocios__c = 202);
        insert plane;
        
        // Crear aeropuerto
        list<Aeropuerto__c> airports = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c airport = new Aeropuerto__c(Codigo_IATA__c = 'AI' + i, Name='Airport' + i , Pais__c = 'Colombia', Ciudad__c = 'Cali');
            airports.add(airport);
        }
        insert airports;
        
        // Crear vuelo
        Product2 flight = new Product2(Name = 'AE-7453', Avion__c = plane.Id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = departureDate.addDays(1), Fecha_y_hora_real_de_llegada__c = arrivalDate.addDays(2),Aeropuerto_de_partida__c = airports[0].Id, Aeropuerto_de_llegada__c = airports[1].id, IsActive = true);
        insert flight;

        // Crear las entradas de lista de precios al vuelo
        PricebookEntry pricEntry = new PricebookEntry(Pricebook2Id = pricebookId, UnitPrice = 25346,Product2Id = flight.Id, IsActive = true);
        insert pricEntry;
        
        PricebookEntry touristEntry = new PricebookEntry(Pricebook2Id = tourist.Id, UnitPrice = 45345, Product2Id = flight.Id, IsActive = true);
        insert touristEntry;

        PricebookEntry businessEntry = new PricebookEntry(Pricebook2Id = business.Id, UnitPrice = 45345, Product2Id = flight.Id, IsActive = true);
        insert businessEntry;

        PricebookEntry cargoEntry = new PricebookEntry(Pricebook2Id = cargo.Id, UnitPrice = 45345, Product2Id = flight.Id, IsActive = true);
        insert cargoEntry;

        // Creo el tiquete para el vuelo, pasajero y la reserva
        OpportunityLineItem newTicket = new OpportunityLineItem(OpportunityId = booking.Id, Quantity = 1, Product2Id = flight.Id, Pasajero__c = customer.Id, PricebookEntryId = businessEntry.Id);
        insert newTicket;
    }
    
    @isTest
    public static void endBooking(){
        Test.startTest();
        SaveBooking3H batch = new SaveBooking3H();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        List<Opportunity> booking = [SELECT StageName FROM Opportunity WHERE StageName = 'No Pagado'];
        
        System.assertEquals(1, booking.size());   
    }
}
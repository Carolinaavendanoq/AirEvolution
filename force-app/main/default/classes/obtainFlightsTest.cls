@isTest
public class obtainFlightsTest {
    @TestSetup
    static void makeData(){
        Contact testcon = new Contact(FirstName = 'Contact', LastName = 'Test', Tipo_de_Identificacion__c = 'Tarjeta de identidad', Numero_de_identificacion__c = '25325');
        insert testcon;
        
        List<Contact> addContacts = new List<Contact>();
        for(Integer i = 0; i < 20; i++){
            Contact newContact = new Contact(FirstName = 'Contact' + i, LastName = 'Test', Tipo_de_Identificacion__c = 'Tarjeta de identidad', Numero_de_identificacion__c = '25325' + i);
            addContacts.add(newContact);
        }
        insert addContacts;
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Clase negocio', IsActive = true);
        insert newPricebook;
        Pricebook2 newPricebook2 = new Pricebook2(Name = 'Clase turista');
        insert newPricebook2;
        Pricebook2 newPricebook3 = new Pricebook2(Name = 'Carga');
        insert newPricebook3;
        
        String pricebookId = Test.getStandardPricebookId();
        
        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 46, Tipo__c  ='Airbus A330');
        insert plane;
        
        Aeropuerto__c airport = new Aeropuerto__c(Name = 'Airport1', Codigo_IATA__c = 'AI1');
        Aeropuerto__c airport2 = new Aeropuerto__c(Name = 'Airport2', Codigo_IATA__c = 'IA2');
        insert airport;
        insert airport2;
        
        Product2 flight = new Product2(Name = 'AE-2432', Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now()+ 4, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id, Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta');
        
        insert flight;
        
        PricebookEntry newPricEntry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = flight.Id, UnitPrice = 234233);
        insert newPricEntry2;
      	PricebookEntry newPricEntry = new PricebookEntry(Pricebook2Id = newPricebook.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry;
        PricebookEntry newPricEntry3= new PricebookEntry(Pricebook2Id =newPricebook2.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry3;
        PricebookEntry newPricEntry4=new PricebookEntry(Pricebook2Id =newPricebook3.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry4;
        
    }
    
    @isTest
    static void getFlightsTest(){
        String pricebookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        List<obtainFlights.Flight> result = obtainFlights.getFlights(pricebookId);
        
      	System.assertEquals(1,result.size());
    }
    
    @isTest
    static void obtainPricebooksTest(){
        List<Pricebook2> result = obtainFlights.obtainPricebooks();
        
      	System.assertEquals(1,result.size());
    }
    
    @isTest
    static void verifyContactTest(){
        String idType;
        String idNumber;
        Contact testcon = [SELECT Id, Name, Tipo_de_Identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];
        idType = testcon.Tipo_de_Identificacion__c;
        idNumber = testcon.Numero_de_identificacion__c;
        
        
        Contact result = obtainFlights.verifyContact(idType, idNumber);
      	System.assertEquals(testcon, result);
    }
    
    @isTest
    static void verifyReservationTest(){
        Contact testcon = [SELECT Id, Name, Tipo_de_Identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];
        String contactId = testcon.Id;
        Opportunity result = obtainFlights.verifyReservation(contactId);
      	System.assertEquals(result.Titular_de_reserva__c, testcon.Id);
    }
    
    @isTest
    static void existReservationTest(){
        Contact testcon = [SELECT Id, Name, Tipo_de_Identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];
        String contactId = testcon.Id;
        
        Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta');
        insert booking;
        
        Opportunity result = obtainFlights.verifyReservation(contactId);
      	System.assertEquals(null, result);
    }
    
    @isTest
    static void updateReservationTest(){
        Contact testcon = [SELECT Id, Name, Tipo_de_Identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];
        String contactId = testcon.Id;
        
        Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta');
        insert booking;
        
        String bookingId = booking.Id;
        
        String pricebookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        
        Opportunity result = obtainFlights.updateReservation(bookingId, pricebookId);
      	System.assertEquals(booking.Id, result.Id);
    }
    
    @isTest
    static void finalBookingTest(){
        String contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        String pricebookId = [SELECT Id FROM Pricebook2 WHERE IsActive = true].Id;
        String flightId = [SELECT Id FROM Product2].Id;
        
        Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = pricebookId);
        insert booking;
        String bookingId = booking.Id;
        
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flightId,OpportunityId =bookingId);
        insert ticket;
        
        Opportunity result = obtainFlights.finalBooking(bookingId);
      	System.assertEquals(booking.Id, result.Id);
    }
    
    @isTest
    static void createTickeTest(){ 
        String contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        String pricebookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        String flightId = [SELECT Id FROM Product2].Id;
        
        Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = pricebookId);
        insert booking;
        
        String bookingId = booking.Id;
       
        
        OpportunityLineItem result = obtainFlights.createTicket(bookingId, flightId, contactId);
      	System.assertEquals(booking.Id, result.OpportunityId);
    }
    
    @isTest
    static void createThrowTest(){
        try{
            String contactId = [SELECT Id FROM Contact LIMIT 1].Id;
            String pricebookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
            
            Product2 myFlight = new Product2(Name = 'AE-2652');
            insert myFlight;
            String flightId = myFlight.Id;
            
            Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = pricebookId);
            insert booking;
            String bookingId = booking.Id;
           
            
            OpportunityLineItem result = obtainFlights.createTicket(bookingId, flightId, contactId);
            
        }catch(exception e){
            system.assert(e.getMessage().contains('exception'));
        }
		
        
    }
    
    @isTest
    static void finalThrowTest(){
        try{
            String contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        	Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta');
        	insert booking;
        	String bookingId = booking.Id;

        	Opportunity result = obtainFlights.finalBooking(bookingId);
        }catch(exception e){
            system.assert(e.getMessage().contains('exception'));
        } 	
    }
    
    @isTest
    static void updateThrowTest(){
        try{
            Contact testcon = [SELECT Id, Name, Tipo_de_Identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];
        	String contactId = testcon.Id;
        
        	Opportunity booking = new Opportunity(Titular_de_reserva__c = contactId, Name = 'a', CloseDate = Date.today(), StageName = 'Pagado');
        	insert booking;
        
        	String bookingId = booking.Id;
        
        	String pricebookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        
        	Opportunity result = obtainFlights.updateReservation(bookingId, pricebookId);
      	
        }catch(exception e){
            system.assert(e.getMessage().contains('exception'));
        }
    } 
    
}
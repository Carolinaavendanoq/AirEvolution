@isTest
public class OpportunityLineItemTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Contact testcon = new Contact(FirstName = 'Contact', LastName = 'Test');
        insert testcon;
        
        List<Contact> addContacts = new List<Contact>();
        for(Integer i = 0; i < 20; i++){
            Contact newContact = new Contact(FirstName = 'Contact' + i, LastName = 'Test');
            addContacts.add(newContact);
        }
        insert addContacts;
        
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Clase negocio');
        insert newPricebook;
        Pricebook2 newPricebook2 = new Pricebook2(Name = 'Clase turista');
        insert newPricebook2;
        Pricebook2 newPricebook3 = new Pricebook2(Name = 'Carga');
        insert newPricebook3;
        String pricebookId = Test.getStandardPricebookId();
        
        Opportunity testbook= new Opportunity(Titular_de_reserva__c = testcon.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = newPricebook.Id);
        insert testbook;
        
        List<Opportunity> bookings = new List<Opportunity>();
        for(Contact oneContact : addContacts){
                Opportunity booking = new Opportunity(Titular_de_reserva__c = oneContact.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = newPricebook.Id);
                bookings.add(booking);                                       
        }
   
        insert bookings;
        
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
        
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flight.Id,OpportunityId =testbook.Id);
        insert ticket;
    }
    
    @isTest
    static void addPassengerTest(){
        List<Opportunity> bookings = [SELECT Id FROM Opportunity];
        String flightId = [SELECT Id FROM Product2].Id;
 
        List<OpportunityLineItem> tickets = new List<OpportunityLineItem>();
        for(Opportunity booking: bookings){
            OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flightId, OpportunityId = booking.Id);
            tickets.add(ticket);
        }
        insert tickets;
        
        
        List<OpportunityLineItem> ticketPassenger = [SELECT id from OpportunityLineItem];
      	System.assertEquals(22,ticketPassenger.size());
    }
    
    @isTest
    static void updPassengerTest(){
        Contact newContact = new Contact(FirstName = 'Contact', LastName = 'Update');
        insert newContact;
        String bookingId=[SELECT Id FROM Opportunity LIMIT 1].Id;
        String flightId = [SELECT Id FROM Product2].Id;
        Opportunity booking = new Opportunity(Titular_de_reserva__c = newContact.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Id = bookingId);
        update booking;
        
        String ticketId = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =:bookingId].Id;
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flightId, OpportunityId = bookingId,Id = ticketId);
        update ticket;
        
        
        List<OpportunityLineItem> ticketPassenger = [SELECT id from OpportunityLineItem];
      	System.assertEquals(1,ticketPassenger.size());
    }
    
    @isTest
    static void touristCategoryTest(){
        String myContact = [SELECT Id FROM Contact LIMIT 1].Id;
        String touristPricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Clase Turista' LIMIT 1].Id;
        Opportunity booking = new Opportunity(Titular_de_reserva__c = myContact, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = touristPricebook);
        insert booking;
		String flight = [SELECT Id FROM Product2 LIMIT 1].Id;
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id = flight, OpportunityId= booking.Id, Equipaje_permitido__c = 'Personal;Maleta de cabina;Maleta de bodega');
        insert ticket;
        OpportunityLineItem ticket1= new OpportunityLineItem(Product2Id = flight, OpportunityId= booking.Id, Equipaje_permitido__c = 'Personal;Maleta de cabina');
        insert ticket1;
        OpportunityLineItem ticket2= new OpportunityLineItem(Product2Id = flight, OpportunityId= booking.Id, Equipaje_permitido__c = 'Maleta de cabina;Maleta de bodega');
        insert ticket2;
        OpportunityLineItem ticket3= new OpportunityLineItem(Product2Id = flight, OpportunityId= booking.Id, Equipaje_permitido__c = 'Personal;Maleta de bodega');
        insert ticket3;
        
        List<OpportunityLineItem> ticketPassenger = [SELECT id from OpportunityLineItem];
      	System.assertEquals(5, ticketPassenger.size());
        
    }
    
    @isTest
    static void cargoCategoryTest(){
        String myContact = [SELECT Id FROM Contact LIMIT 1].Id;
        String cargoPricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Carga' LIMIT 1].Id;
        Opportunity booking = new Opportunity(Titular_de_reserva__c = myContact, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = cargoPricebook);
        insert booking;
		String flight = [SELECT Id FROM Product2 LIMIT 1].Id;
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id = flight, OpportunityId= booking.Id);
        insert ticket;
        
        List<OpportunityLineItem> ticketPassenger = [SELECT id from OpportunityLineItem];
      	System.assertEquals(2, ticketPassenger.size());
        
    }
    
    @isTest
    static void deleteTickeTest(){
        OpportunityLineItem ticket = [SELECT Id FROM OpportunityLineItem];
        delete ticket;
        
        List<OpportunityLineItem> result = [SELECT Id FROM OpportunityLineItem];
        System.assertEquals(0, result.size());
        
    }
    
}
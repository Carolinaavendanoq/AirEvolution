@isTest
public class OpportunityTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Contact testContact = new Contact(FirstName = 'Contact', LastName = 'Test');
        insert testContact;
        
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
        
        Opportunity testBooking = new Opportunity(Titular_de_reserva__c = testContact.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id= newPricebook.Id);
        insert testBooking;
        
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
    static void bookingNameTest(){
        List<Contact> customers = [SELECT Id FROM Contact];
        List<Opportunity> bookings = new List<Opportunity>();
        for(Contact customer: customers){
            Opportunity booking = new Opportunity(Titular_de_reserva__c = customer.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta');
            bookings.add(booking);
        }
        insert bookings;
        
        
        List<Opportunity> results = [SELECT Id FROM Opportunity];
      	System.assertEquals(22, results.size());
    }
    
    @isTest
    static void withouthFlight(){
        String bookingId = [SELECT Id From Opportunity LIMIT 1].Id;
        Opportunity updateBooking = new Opportunity(Id = bookingId, StageName = 'Completado');
        update updateBooking;  
        
        List<Opportunity> results = [SELECT Id FROM Opportunity];
      	System.assertEquals(1, results.size());
        
    } 
    
    @isTest
    static void paidBooking(){
        String bookingId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        String flightId = [SELECT Id FROM Product2 LIMIT 1].Id;
        
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flightId, OpportunityId = bookingId);
        insert ticket;
        
        Opportunity updateBooking = new Opportunity(Id= bookingId, StageName = 'Pagado');
        update updateBooking;
        
        List<Opportunity> results = [SELECT Id FROM Opportunity WHERE StageName = 'Pagado'];
      	System.assertEquals(1, results.size());
        
    } 
    
    @isTest
    static void deleteBooking(){
        Opportunity booking = [SELECT Id FROM Opportunity LIMIT 1];
        delete booking;
        
        List<Opportunity> results = [SELECT Id FROM Opportunity];
      	System.assertEquals(0, results.size());
    } 
    
}
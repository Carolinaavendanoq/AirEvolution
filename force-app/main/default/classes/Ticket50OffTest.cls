@isTest
public class Ticket50OffTest {
    @TestSetup
    static void makeData(){
        Contact testcon = new Contact(FirstName = 'Contact', LastName = 'Test', Email = 'test@mail.com');
        insert testcon;
        
        List<Contact> addContacts = new List<Contact>();
        for(Integer i = 0; i < 20; i++){
            Contact newContact = new Contact(FirstName = 'Contact' + i, LastName = 'Test', Email = 'test'+ i + '@mail.com');
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
        
        Opportunity testbook= new Opportunity(Titular_de_reserva__c = testcon.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = pricebookId);
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
        
        Product2 flight = new Product2(Name = 'AE-2432', Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now().addDays(1), Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id, Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta');
        
        insert flight;
        PricebookEntry newPricEntry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = flight.Id, UnitPrice = 34634 , IsActive = true, Descuento_50__c = false, Descuento_35__c = false);
        insert newPricEntry2;
      	PricebookEntry newPricEntry = new PricebookEntry(Pricebook2Id = newPricebook.Id, Product2Id = flight.Id, UnitPrice = 200000, IsActive = true, Descuento_50__c = false,Descuento_35__c = true);
      	insert newPricEntry;
        PricebookEntry newPricEntry3= new PricebookEntry(Pricebook2Id =newPricebook2.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry3;
        PricebookEntry newPricEntry4=new PricebookEntry(Pricebook2Id =newPricebook3.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry4;
        
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flight.Id,OpportunityId =testbook.Id);
        insert ticket;
      
    }
    
    
    
    @isTest
    static void testBatch(){
        Test.startTest();
        Ticket50Off batchTest = new Ticket50Off();
        Id processId = Database.executeBatch(batchTest);
        Test.stopTest();
        
        List<PricebookEntry> pricEntry = [SELECT Id, UnitPrice FROM PricebookEntry];
        
        System.assertEquals(4, pricEntry.size());
    }
}
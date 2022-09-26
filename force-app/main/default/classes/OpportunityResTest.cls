@isTest
public class OpportunityResTest {
    @testSetup
    static void makeData(){
        Datetime departureDate = Datetime.now();
        Datetime arriveDate = Datetime.now();
        Avion__c plane = new Avion__c(Tipo__c = 'ATR-72', Numero_de_pasajeros_clase_turista__c = 76, Numero_de_pasajeros_clase_negocios__c = 0);
        insert plane;
        list<Aeropuerto__c> airports = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c airport = new Aeropuerto__c(Codigo_IATA__c = 'ABC', Name='Airport'+ i , Pais__c = 'Portugal', Ciudad__c = 'Lisboa');
            airports.add(airport);
        }
        insert airports;
        Product2 flight = new Product2(Name = 'AE-3623', Avion__c = plane.Id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = departureDate.addDays(1),
                                       Fecha_y_hora_real_de_llegada__c = arriveDate.addDays(2), Aeropuerto_de_partida__c =airports[0].Id, 
                                      Aeropuerto_de_llegada__c = airports[1].Id, IsActive = true);
        insert flight;
        
        Contact oldContact = new Contact(FirstName = 'Contact', LastName = 'Test', Tipo_de_Identificacion__c = 'Tarjeta de identidad', Numero_de_identificacion__c = '25325', Birthdate = Date.newInstance(1987, 08, 12),Email = 'test@mail.com',Nacionalidad__c = 'Brasileño',Numero_de_pasaporte__c = '23634734');
        insert oldContact;
        Contact oldCustomer = new Contact(FirstName = 'Contact', LastName = 'withoutBooking', Tipo_de_Identificacion__c = 'Tarjeta de identidad', Numero_de_identificacion__c = '23532632', Birthdate = Date.newInstance(2000, 03, 12),Email = 'withoutbooking@mail.com',Nacionalidad__c = 'Brasileño',Numero_de_pasaporte__c = '36436');
        insert oldCustomer;
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Clase negocio', IsActive = true);
        insert newPricebook;
        Pricebook2 newPricebook2 = new Pricebook2(Name = 'Clase turista');
        insert newPricebook2;
        Pricebook2 newPricebook3 = new Pricebook2(Name = 'Carga');
        insert newPricebook3;
        
        String pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry newPricEntry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = flight.Id, UnitPrice = 234233);
        insert newPricEntry2;
      	PricebookEntry newPricEntry = new PricebookEntry(Pricebook2Id = newPricebook.Id, Product2Id = flight.Id, UnitPrice = 200, IsActive = true);
      	insert newPricEntry;
        PricebookEntry newPricEntry3= new PricebookEntry(Pricebook2Id =newPricebook2.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry3;
        PricebookEntry newPricEntry4=new PricebookEntry(Pricebook2Id =newPricebook3.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry4;
        
        Opportunity booking = new Opportunity(Titular_de_reserva__c =oldContact.Id , StageName = 'Pre-venta', CloseDate = Date.newInstance(1987, 08, 12), Name = 'w', Pricebook2Id = newPricebook.Id);
        insert booking;
        
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flight.Id, OpportunityId =booking.Id);
        insert ticket;
    }
    
    @isTest
    static void existingContact(){
        String flight = [SELECT Id FROM Product2 LIMIT 1].Id;
        Contact oldContact = [SELECT Id, Birthdate, Email, FirstName, LastName, Nacionalidad__c, Numero_de_identificacion__c, Numero_de_pasaporte__c, Tipo_de_Identificacion__c FROM Contact LIMIT 1];
        Date birthDateFormat= oldContact.Birthdate;
        String birthToString = birthDateFormat.format();
        String priceBookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        WrapperToRest results =OpportunityRest.createBooking(oldContact.Numero_de_identificacion__c, oldContact.Tipo_de_Identificacion__c, oldContact.FirstName, oldContact.LastName, oldContact.Numero_de_pasaporte__c, birthToString, oldContact.Email, oldContact.Nacionalidad__c, priceBookId, flight);
        System.assertEquals('Reserva actualizada y tiquete creado exitosamente', results.message);
        
    }
    
    @isTest
    static void nonExistingContact(){
        String flight = [SELECT Id FROM Product2 LIMIT 1].Id;
        String priceBookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        Contact oldContact = new Contact(FirstName = 'New', LastName = 'Contactest', Tipo_de_Identificacion__c = 'Cédula de ciudadanía', Numero_de_identificacion__c = '23687340', Birthdate = Date.newInstance(1992, 09, 22),Email = 'contactest@mail.com',Nacionalidad__c = 'Brasileño',Numero_de_pasaporte__c = '457346');
        Date birthDateFormat= oldContact.Birthdate;
        String birthToString = birthDateFormat.format();
        WrapperToRest results = OpportunityRest.createBooking(oldContact.Numero_de_identificacion__c, oldContact.Tipo_de_Identificacion__c, oldContact.FirstName, oldContact.LastName, oldContact.Numero_de_pasaporte__c, birthToString, oldContact.Email, oldContact.Nacionalidad__c, priceBookId, flight);
        System.assertEquals('Reserva, contacto y tiquetes creados exitosamente', results.message);
    }
    
    @isTest
    static void errorThrowFlight(){
        try{
            String flight = '23529359nd';
        	String priceBookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        	Contact oldContact = new Contact(FirstName = 'New', LastName = 'Contactest', Tipo_de_Identificacion__c = 'Cédula de ciudadanía', Numero_de_identificacion__c = '23687340', Birthdate = Date.newInstance(1992, 09, 22),Email = 'contactest@mail.com',Nacionalidad__c = 'Brasileño',Numero_de_pasaporte__c = '457346');
        	Date birthDateFormat= oldContact.Birthdate;
        	String birthToString = birthDateFormat.format();
        	WrapperToRest results = OpportunityRest.createBooking(oldContact.Numero_de_identificacion__c, oldContact.Tipo_de_Identificacion__c, oldContact.FirstName, oldContact.LastName, oldContact.Numero_de_pasaporte__c, birthToString, oldContact.Email, oldContact.Nacionalidad__c, priceBookId, flight);
        }catch(exception e){
            System.assert(e.getMessage().contains('exception'));
        }
    }
    
    @isTest
    static void withouthBooking(){
        String flight = [SELECT Id FROM Product2 LIMIT 1].Id;
        Contact oldContact = [SELECT Id, Birthdate, Email, FirstName, LastName, Nacionalidad__c, Numero_de_identificacion__c, Numero_de_pasaporte__c, Tipo_de_Identificacion__c FROM Contact WHERE Tipo_de_Identificacion__c = 'Tarjeta de identidad' AND  Numero_de_identificacion__c='23532632' LIMIT 1];
        Date birthDateFormat= oldContact.Birthdate;
        String birthToString = birthDateFormat.format();
        String priceBookId = [SELECT Id FROM Pricebook2 LIMIT 1].Id;
        WrapperToRest results =OpportunityRest.createBooking(oldContact.Numero_de_identificacion__c, oldContact.Tipo_de_Identificacion__c, oldContact.FirstName, oldContact.LastName, oldContact.Numero_de_pasaporte__c, birthToString, oldContact.Email, oldContact.Nacionalidad__c, priceBookId, flight);
        System.assertEquals('Reserva y tiquete creados exitosamente', results.message);
    }
    
    @isTest
    static void paidBooking(){
        String bookingId = [SELECT Id FROM Opportunity].Id;
        String result = OpportunityRest.paidReservation(bookingId);
        System.assertEquals('Reserva Pagada', result);
    }
    
    @isTest
    static void throwPaidBooking(){
        String bookingId = '352352hbfej';
        String result = OpportunityRest.paidReservation(bookingId);
        System.assertEquals('Ocurrió un error con el Id de la reserva', result);
    }
 
}
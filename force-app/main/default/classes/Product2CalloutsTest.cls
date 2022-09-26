@isTest
private class Product2CalloutsTest {
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
    static void flightsTest(){
        string firstDate = '05-09-2022';
        string seconDate = '15-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('firstDate', firstDate);
        request.addParameter('seconDate', seconDate);
        request.addParameter('departureCity', 'Lisboa');
        request.addParameter('arriveCity', 'Lisboa');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        WrapperToRest results = Product2Rest.getFlights();
        System.assertEquals(true, results.result);
    }
    
    @isTest 
    static void errorFirstDate(){
        string firstDate = '04-09-20234';
        string seconDate = '16-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('firstDate', firstDate);
        request.addParameter('seconDate', seconDate);
        request.addParameter('departureCity', 'Lisboa');
        request.addParameter('arriveCity', 'Lisboa');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        WrapperToRest results =Product2Rest.getFlights();
        System.assert(results.message.contains('El formato de la fecha inicial es incorrecta'));
    }
    
    @isTest 
    static void errorSeconDate(){
        string firstDate = '04-09-2022';
        string seconDate = '16-09-202234';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('firstDate', firstDate);
        request.addParameter('seconDate', seconDate);
        request.addParameter('departureCity', 'Lisboa');
        request.addParameter('arriveCity', 'Lisboa');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        WrapperToRest results =Product2Rest.getFlights();
        System.assert(results.message.contains('El formato de la fecha final es incorrecta'));
    }
    
    @isTest 
    static void errorDepartureCity(){
        string firstDate = '04-09-2022';
        string seconDate = '16-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('firstDate', firstDate);
        request.addParameter('seconDate', seconDate);
        request.addParameter('departureCity', 'Lisb');
        request.addParameter('arriveCity', 'Lisboa');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        WrapperToRest results =Product2Rest.getFlights();
        System.assertEquals('Ciudad de partida no disponible', results.message);
    }
    
    @isTest 
    static void errorAriveCity(){
        string firstDate = '04-09-2022';
        string seconDate = '16-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('firstDate', firstDate);
        request.addParameter('seconDate', seconDate);
        request.addParameter('departureCity', 'Lisboa');
        request.addParameter('arriveCity', 'Lisboan');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        WrapperToRest results =Product2Rest.getFlights();
        System.assertEquals('Ciudad de llegada no disponible', results.message);
    }
 
}
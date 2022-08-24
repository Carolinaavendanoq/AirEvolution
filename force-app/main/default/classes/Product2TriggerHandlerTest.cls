@isTest
public class Product2TriggerHandlerTest {
     @TestSetup
    static void makeData(){
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Clase negocio');
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
    static void disableFlightTest(){
        try{
            String flightId = [SELECT Id FROM Product2 LIMIT 1].Id;
        	Product2 flight = new Product2(Id = flightId, Estado__c = 'Cancelado');
        	update flight;
        	List<Product2> result = [SELECT id from Product2];
        }catch(exception e){
            System.assert(e.getMessage().contains('exception'));
        }
    }
    
    @isTest
    static void cancelFlightTest(){
        String flightId = [SELECT Id FROM Product2 LIMIT 1].Id;
        Product2 flight = new Product2(Id = flightId, Estado__c = 'Cancelado', Motivo_de_cancelacion__c = 'Sobreventa');
        update flight;
        List<Product2> result = [SELECT id from Product2];
      	System.assertEquals(1,result.size());
    }
    
    @isTest
    static void flightNumberTest(){
        String planeId = [Select Id FROM Avion__c LIMIT 1].Id;
        Product2 flight = new Product2(Name = 'AE-2355', Avion__c = planeId, Fecha_y_hora_de_partida__c = datetime.now()+ 6, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 8).addHours(4), IsActive = true, Estado__c = 'En venta');
        insert flight;
        
        List<Product2> result = [SELECT id from Product2];
      	System.assertEquals(2,result.size());
    }
    
    @isTest
    static void deleteFlightTest(){
        Product2 flight = [SELECT Id FROM Product2 LIMIT 1];
        delete flight;
        
        List<Product2> result = [SELECT id from Product2];
      	System.assertEquals(0,result.size());
    }
}
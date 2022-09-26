@isTest
public class departureAirportWeatherTest {
    @testSetup
    static void makeData(){
        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 46, Tipo__c  ='Airbus A330');
        insert plane;
        
        Aeropuerto__c airport = new Aeropuerto__c(Name = 'Airport1', Codigo_IATA__c = 'AI1', Localizacion__Latitude__s = 38.53, Localizacion__Longitude__s = -28.61);
        Aeropuerto__c airport2 = new Aeropuerto__c(Name = 'Airport2', Codigo_IATA__c = 'IA2');
        insert airport;
        insert airport2;
        
        Product2 flight = new Product2(Name = 'AE-2432', Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now().addDays(1), Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id, Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta');
        
        insert flight;
    }
    
    @isTest
    static void testBatch(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('responseWeather');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);  
        
        Test.startTest();
      	Database.executeBatch(new departureAirportWeather()); 
        Test.stopTest();
		
        String airport = [SELECT Id From Aeropuerto__c LIMIT 1].Id;        
        List<Clima__c> weathers = [SELECT Id From Clima__c WHERE Aeropuerto__c =: airport];
        System.assertEquals(1, weathers.size());
    }
    
}
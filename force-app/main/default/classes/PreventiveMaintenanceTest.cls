@isTest
public class PreventiveMaintenanceTest {
    @TestSetup
    static void makeData(){
        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 46, Tipo__c  ='Airbus A330');
        insert plane;
        
        List<Product2> flights = new List<Product2>();
        for(Integer i = 0; i < 50; i++){
            flights.add(new Product2(Name = 'AE' + i, Avion__c = plane.Id, IsActive = true, Fecha_y_hora_de_partida__c = (datetime.now()).addHours(i)));
        }
        insert flights;
      
    }
    
    
    @isTest
    static void testBatch(){
        Test.startTest();
        PreventiveMaintenance batchTest = new PreventiveMaintenance();
        Id processId = Database.executeBatch(batchTest);
        Test.stopTest();
        
        List<Product2> flight = [SELECT Id FROM Product2];
        
        System.assertEquals(50, flight.size());
    }
}
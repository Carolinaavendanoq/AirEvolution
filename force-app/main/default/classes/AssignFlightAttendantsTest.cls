@isTest
public with sharing class AssignFlightAttendantsTest {
    @TestSetup
    static void makeData(){
        List<Product2> flights = new List<Product2>();
        for(Integer i = 0; i < 50; i++){
            flights.add(new Product2(Name = 'AE' + i, IsActive = true, Fecha_y_hora_de_partida__c = (datetime.now()).addDays(i)));
        }
        insert flights;
    }
    
    
    @isTest
    static void testBatch(){
        Test.startTest();
        AssignFlightAttendants batchTest = new AssignFlightAttendants();
        Id processId = Database.executeBatch(batchTest);
        Test.stopTest();
        
        List<Product2> flights = [SELECT Id FROM Product2];
        
        System.assertEquals(50, flights.size());
    }
    
}
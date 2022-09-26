@isTest
public class ScPreventiveMaintenanceTest {
    @testSetup 
    static void makeData(){
        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 46, Tipo__c  ='Airbus A330');
        insert plane;
        
        List<Product2> flights = new List<Product2>();
        for(Integer i = 0; i < 200; i++){
            flights.add(new Product2(Name = 'AE' + i, Avion__c = plane.Id, IsActive = true, Fecha_y_hora_de_partida__c = (datetime.now()).addHours(i)));
        }
        insert flights;
        
    }
    
    @isTest static void weatherSchedule(){
        Test.startTest();
        String CronExp = '0 6 * * * ?';
        System.schedule('Preventive Maintenance', cronExp, new ScPreventiveMaintenance());
        Integer numberOfJobs = [SELECT Count() FROM crontrigger WHERE cronjobdetail.jobtype = '7'];
        System.assert(numberOfJobs == 1);
        Test.stopTest();
    }
}
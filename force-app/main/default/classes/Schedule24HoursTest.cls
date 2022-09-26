@isTest
public class Schedule24HoursTest {
    @testSetup 
    static void makeData(){
        List<Avion__c> planes = new List<Avion__c>();
        List<Aeropuerto__c> departureAirports = new List<Aeropuerto__c>();
        List<Aeropuerto__c> arriveAirports = new List<Aeropuerto__c>();
        Integer desNumber = 400;
        for(Integer i = 0; i < 200; i++ ){
            Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 46, 
                                          Tipo__c  ='Airbus A330');
            planes.add(plane);
           	Aeropuerto__c departureAirport = new Aeropuerto__c(Name = 'Airport' + i, Codigo_IATA__c = 'AI' + i, 
                                                               Localizacion__Latitude__s = 38.53, Localizacion__Longitude__s = -28.61);
            departureAirports.add(departureAirport);
        	Aeropuerto__c arriveAirport = new Aeropuerto__c(Name = 'Airport' + (desNumber-i), Codigo_IATA__c = 'AI' + (desNumber-i));
            arriveAirports.add(arriveAirport);
        }
             
        insert planes;
        insert departureAirports;
        insert arriveAirports;

        List<Product2> flights = new List<Product2>();
        Integer counter = 0;
        for(Avion__c plane : planes){
            Product2 flight = new Product2(Name = 'AE-243' + counter, Avion__c = plane.Id, 
                                           Fecha_y_hora_de_partida__c = datetime.now().addDays(1).addHours(counter), 
                                           Aeropuerto_de_partida__c = departureAirports[counter].Id, IsActive = true, 
                                           Aeropuerto_de_llegada__c = arriveAirports[counter].Id, Estado__c = 'En venta');
            flights.add(flight);
            counter +=1;
        }
                
        insert flights;  
        
    }
    
    @isTest static void weatherSchedule(){
        Test.startTest();
        APIMimicTest.createApiData();
        String CronExp = '0 6 * * * ?';
        System.schedule('Setup Schedule', cronExp, new Schedule24Hours());
        Integer numberOfJobs = [SELECT Count() FROM crontrigger WHERE cronjobdetail.jobtype = '7'];
        System.assert(numberOfJobs >= 1);
        Test.stopTest();
    }
    
    @isTest static void departureAirportWeather(){
        APIMimicTest.createApiData();
        Test.startTest();
        ClimaModel.departureAirports();
        Test.stopTest();
        
        List<Clima__c> weathers = [SELECT Id FROM Clima__c];
        System.assert(!weathers.isEmpty());
    }
    
}
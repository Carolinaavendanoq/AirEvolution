@isTest
public with sharing class RequiredCrewTest {
    @TestSetup
    static void makeData(){
        
        Contact flightAttendant = new Contact(LastName = 'Jonas', Nacionalidad__c = 'Paraguayo', 
                                       Tipo_de_identificacion__c = 'Cédula de Ciudadanía', Numero_de_identificacion__c = '364363', RecordTypeId = '0128a000000N3efAAC');
        Contact flightAttendant2 = new Contact(LastName = 'Morales', Nacionalidad__c = 'Colombiano', 
                                       Tipo_de_identificacion__c = 'Cédula de Ciudadanía', Numero_de_identificacion__c = '4624252', RecordTypeId = '0128a000000N3efAAC');
        insert flightAttendant;
        insert flightAttendant2;

        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 55, Tipo__c  ='Airbus A330');
        insert plane;

        Aeropuerto__c airport = new Aeropuerto__c(Name = 'Airport1', Codigo_IATA__c = 'AI1');
        Aeropuerto__c airport2 = new Aeropuerto__c(Name = 'Airport2', Codigo_IATA__c = 'IA2');
        insert airport;
        insert airport2;

        Product2 flight = new Product2(Name = 'AE-2353',
                                 Avion__c = plane.Id,
                                 Fecha_y_hora_de_partida__c = datetime.now()+ 4, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id,
                                 Aeropuerto_de_llegada__c = airport2.Id,
                                 IsActive = true,
                                 Estado__c = 'En venta');
        insert flight;

        Auxiliares_de_vuelo__c crewMember = new Auxiliares_de_vuelo__c(Auxiliares_de_vuelo__c = flightAttendant.Id, Vuelo__c = flight.Id);
        insert crewMember;
    }

    @isTest
    static void onlyOneFlight(){
        List<RequiredCrew.Flight> flight = RequiredCrew.obtainFlights();
        System.assertEquals(1, flight.size());
    }

    @isTest
    static void masiveFlights(){
        List<Product2> flights = new List<Product2>();
        Avion__c plane = [SELECT Id FROM Avion__c LIMIT 1];
        Aeropuerto__c airport = [SELECT Id FROM Aeropuerto__c WHERE Name = 'Airport1' LIMIT 1];
        Aeropuerto__c airport2 =[SELECT Id FROM Aeropuerto__c WHERE Name = 'Airport2' LIMIT 1];

        for (Integer i = 0; i < 20; i++) {
            flights.add(new Product2(Name = 'AE-107'+ i, Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now()+ 4, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4), Aeropuerto_de_partida__c = airport.Id , Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta'));
        }
        insert flights;
  
        List<RequiredCrew.Flight> verifyFlights = RequiredCrew.obtainFlights();
        System.assertEquals(21, verifyFlights.size());

    }

    @isTest
    static void flightAttendants(){
        List<Product2> flights = [SELECT Id FROM Product2 LIMIT 1];
        String flightId;
        
        for (Product2 flight : flights) {
            flightId = (String)flight.Id;
        }
        List<RequiredCrew.Option> options = RequiredCrew.Option.getFlightAttendants(flightId);
        System.assertEquals(3, options.size());
        
    }

    @isTest
    static void flightAttendantSaved(){
        List<Contact> flightAttendants = new List<Contact>();
        for (Integer i = 0; i < 20; i++) {
            flightAttendants.add(new Contact(FirstName = 'Flight', LastName = 'Attendant' + i , Tipo_de_identificacion__c = 'Cédula de Ciudadanía', Numero_de_identificacion__c = '364363' + i, RecordTypeId = '0128a000000N3efAAC'));
        }
        insert flightAttendants;

        List<Product2> flights = [SELECT Id FROM Product2 LIMIT 1];
        String flightId;
        
        for (Product2 flight : flights) {
            flightId = (String)flight.Id;
        }



    }
}
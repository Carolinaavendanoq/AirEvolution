@isTest
public class AuxiliaresVueloTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        
        List<Contact> addContacts = new List<Contact>();
        for(Integer i = 0; i < 10; i++){
            Contact newContact = new Contact(FirstName = 'Contact' + i, LastName = 'Test', RecordTypeId = '0128a000000N3efAAC');
            addContacts.add(newContact);
        }
        insert addContacts;
        
   
        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 222, Tipo__c  ='Airbus A330');
        insert plane;
        
        Aeropuerto__c airport = new Aeropuerto__c(Name = 'Airport1', Codigo_IATA__c = 'AI1');
        Aeropuerto__c airport2 = new Aeropuerto__c(Name = 'Airport2', Codigo_IATA__c = 'IA2');
        insert airport;
        insert airport2;
        
        Product2 flight = new Product2(Name = 'AE-2432', Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now()+ 4, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id, Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta');
        
        insert flight;
        
        List<Auxiliares_de_vuelo__c> flightAttendants = new List<Auxiliares_de_vuelo__c>();
        for(Contact myContact: addContacts){
            Auxiliares_de_vuelo__c flightAttendant = new Auxiliares_de_vuelo__c(Vuelo__c = flight.Id, Auxiliares_de_vuelo__c = myContact.Id);
            flightAttendants.add(flightAttendant);
        }
        insert flightAttendants;
        
    }
    
    @isTest
    static void stopAllocationTest(){
        try{
            String getContact = [SELECT Id FROM Contact LIMIT 1].Id;
        	String flightId = [SELECT Id FROM Product2].Id;
        
        	Auxiliares_de_vuelo__c flightAttendant = new Auxiliares_de_vuelo__c(Vuelo__c = flightId, Auxiliares_de_vuelo__c = getContact);
        	insert flightAttendant;
        
        	List<Auxiliares_de_vuelo__c> flightAttResult = [SELECT Id from Auxiliares_de_vuelo__c];
      	
        }catch(exception e){
            System.assert(e.getMessage().contains('exception'));
        }
    }
    
    @isTest
    static void deleteFlightAttendant(){
        Auxiliares_de_vuelo__c flightAttendant = [SELECT Id FROM Auxiliares_de_vuelo__c LIMIT 1];
        delete flightAttendant;
        
        List<Auxiliares_de_vuelo__c> result = [SELECT Id FROM Auxiliares_de_vuelo__c];
        System.assertEquals(9, result.size());
    }
    
    @isTest
    static void updateFlightAttendant(){
        Contact newContact = new Contact(FirstName = 'Contact', LastName = 'Test', RecordTypeId = '0128a000000N3efAAC');
        insert newContact;
                                              
        String flightAttendant = [SELECT Id FROM Auxiliares_de_vuelo__c LIMIT 1].Id;
        Auxiliares_de_vuelo__c updFlightAttendant = new Auxiliares_de_vuelo__c(Id= flightAttendant, Auxiliares_de_vuelo__c = newContact.Id);
        update updFlightAttendant;
        
        List<Auxiliares_de_vuelo__c> result = [SELECT Id FROM Auxiliares_de_vuelo__c];
        System.assertEquals(10, result.size());
    }
    
}
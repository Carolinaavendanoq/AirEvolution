public with sharing class RequiredCrew {
    @AuraEnabled(cacheable = true) 
    public static List<Flight> obtainFlights(){
        try {
            DateTime limitDate = DateTime.now().addDays(7);
            List<Product2> flights = [SELECT Id, Name, Copiloto__c, Piloto__c, Fecha_y_hora_de_partida__c, Avion__r.Auxiliares_de_vuelo_requeridos__c, (SELECT id FROM Auxiliares_de_vuelo__r) FROM Product2 WHERE IsActive = true AND Estado__c = 'En venta' AND Fecha_y_hora_de_partida__c > today And Fecha_y_hora_de_partida__c <: limitDate];

            List<Flight> flightResponse = new List<Flight>();

            for (Product2 flight : flights) {
                flightResponse.add(new Flight((String)flight.Id, flight.Name, (Integer)flight.Avion__r.Auxiliares_de_vuelo_requeridos__c, flight.Copiloto__c, flight.Piloto__c, flight.Auxiliares_de_vuelo__r.size()));
            }
            System.debug(flightResponse);
            return flightResponse;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Option> getFlightAttendants(String flightId){
        try {
            List<Contact> availableFlightAttendants = [SELECT Id, Name FROM Contact WHERE RecordType.Name = 'Auxiliar de vuelo' LIMIT 20];

            List<Auxiliares_de_vuelo__c> crewMembers = [SELECT Id, Auxiliares_de_vuelo__c, Auxiliares_de_vuelo__r.Name FROM Auxiliares_de_vuelo__c WHERE Vuelo__c =: flightId];

            list<Option> options = new list<Option>();
            for(Contact flightAttendant : availableFlightAttendants){
                options.add(new option(flightAttendant.Name, flightAttendant.Id, false));
            }

            for(Auxiliares_de_vuelo__c crewMember : crewMembers){
                options.add(new Option(crewMember.Auxiliares_de_vuelo__r.Name , crewMember.Auxiliares_de_vuelo__c, true));
            }
            return options;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveFlightAttendants(List<String> flightAttendants, String flightId){
        try {
            List<Auxiliares_de_vuelo__c> crewMembers = [SELECT Id, Auxiliares_de_vuelo__c, Auxiliares_de_vuelo__r.Name 
                                                FROM Auxiliares_de_vuelo__c
                                                WHERE Vuelo__c =: flightId];
            
            set<String> noFound = new set<String>();
            for(Auxiliares_de_vuelo__c crewMember : crewMembers){
                for(integer i = 0; i < flightAttendants.size(); i++){
                    if(crewMember.Auxiliares_de_vuelo__c == flightAttendants[i]){
                        flightAttendants.remove(i);
                        if(noFound.contains(crewMember.Id)){
                            noFound.remove(crewMember.Id);
                        }
                    } else {
                        noFound.add(crewMember.Id);
                    }
                }
            }
            
            List<Auxiliares_de_vuelo__c> newCrewMembers = new List<Auxiliares_de_vuelo__c>();
            for(String flightAttendant : flightAttendants){
                newCrewMembers.add(new Auxiliares_de_vuelo__c(Vuelo__c = flightId, Auxiliares_de_vuelo__c = flightAttendant));
            }
            System.debug('New Crew Members-->' + newCrewMembers);
            insert newCrewMembers;

            System.debug('No found-->'+ noFound);
            List<Auxiliares_de_vuelo__c> toDelete = new List<Auxiliares_de_vuelo__c>();
            for(String idT : noFound){
                toDelete.add(new Auxiliares_de_vuelo__c(Id = idT));
            }
            delete toDelete;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class Flight{
        @AuraEnabled
        public string flightId;
        @AuraEnabled
        public string flightCode;
        @AuraEnabled
        public decimal flightAttendantsNum;
        @AuraEnabled
        public integer leftoverFlighAttendants;
        @AuraEnabled
        public boolean copilot;
        @AuraEnabled
        public boolean pilot;

        public Flight(string id, String name, integer flightAttendants, string copilotId, string pilotId, integer flightAttendantSize){
            flightId = id;
            flightCode = name;
            flightAttendantsNum = flightAttendants;
            leftoverFlighAttendants = flightAttendants - flightAttendantSize;
            copilot = !String.isBlank(copilotId);
            pilot = !String.isBlank(pilotId);
        } 
    }

    public class Option{
        @AuraEnabled 
        public String label;
        @AuraEnabled 
        public String value;
        @AuraEnabled 
        public boolean selected;

        public Option(String label, String value, boolean selected){
            this.label = label;
            this.value = value;
            this.selected = selected;
        }

    }
}
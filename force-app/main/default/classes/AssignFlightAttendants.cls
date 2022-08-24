public with sharing class AssignFlightAttendants implements Database.Batchable<sObject> {

    Date todayDate = Date.today();

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Fecha_y_hora_de_partida__c, Name FROM Product2 WHERE IsActive = true AND Fecha_y_hora_de_partida__c != null';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Product2> flights){
        List<Product2> assignFlights = new List<Product2>();
        Date flightDate;
        for (Product2 flight : flights) {
            Datetime flightDateTime = flight.Fecha_y_hora_de_partida__c;
            flightDate = flightDateTime.date();
            if (todayDate.daysBetween(flightDate) == 7) {
                assignFlights.add(flight);
            }
        }
        for (Product2 flight : assignFlights) {
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Assign_Crew_Members'];
            
            List<User> users = [SELECT Id, Name FROM User WHERE UserRole.Name = 'Gestión de vuelos'];
            
            set<String> userId = new set<String>();
            for (User myUser : users) {
                userId.add(myUser.Id);
            }

            notification.setTitle('Asignar Tripulación');
            notification.setBody('Es momento de asignar la tripulación de un vuelo');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(flight.Id);

            try {
                notification.send(userId);
            } catch (Exception e) {
                System.debug('There are a problem: ' + e.getMessage());
            } 
        }
    }

    public void finish(Database.BatchableContext bc){
        
    }
}
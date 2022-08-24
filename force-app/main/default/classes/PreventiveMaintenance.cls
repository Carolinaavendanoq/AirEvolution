public class PreventiveMaintenance implements Database.Batchable<sObject>{
    Datetime nowDate = Datetime.now();

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Fecha_y_hora_de_partida__c, Avion__c FROM Product2 WHERE IsActive = true AND Fecha_y_hora_de_partida__c = TODAY';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Product2> flights){
        Integer nowHour = nowDate.hour();
        System.debug('nowHour ' + nowHour);
        Integer flightHour;
        List<Product2> assignFlights = new List<Product2>();
        for (Product2 flight : flights) {
            flightHour= flight.Fecha_y_hora_de_partida__c.hour();
            System.debug('flightHour ' + flightHour);
            if ((flightHour - nowHour) == 1) {
                assignFlights.add(flight);
            }
        }
        
        for (Product2 flight : assignFlights) {
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Aircraft_Maintenance'];
            
            List<User> users = [SELECT Id, Name FROM User WHERE UserRole.Name = 'Gestión de vuelos'];
            
            set<String> userId = new set<String>();
            for (User myUser : users) {
                userId.add(myUser.Id);
            }

            notification.setTitle('Mantenimiento Preventivo');
            notification.setBody('Hay una aeronave a punto de salir, requiere mantenimiento preventivo');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(flight.Avion__c);

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
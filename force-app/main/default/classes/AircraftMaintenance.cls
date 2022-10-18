public class AircraftMaintenance {
    // Envía notificación al rol "Gestión de vuelos", informándoles qué aviones requieren mantenimiento preventivo cada hora
    public static void preventiveMaintenance(){
        Datetime nowDate = Datetime.now();
        List<Product2> flights = [SELECT Id, Fecha_y_hora_de_partida__c, Avion__c FROM Product2 WHERE IsActive = true AND Fecha_y_hora_de_partida__c = TODAY];
        Integer nowHour = nowDate.hour();
        
        Integer flightHour;
        List<Product2> assignFlights = new List<Product2>();
        for (Product2 flight : flights) {
            flightHour= flight.Fecha_y_hora_de_partida__c.hour();
            if (flightHour == nowHour) {
                assignFlights.add(flight);
            }
        }
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        set<String> userId = new set<String>();
        for (Product2 flight : assignFlights) {
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Aircraft_Maintenance'];
            
            List<User> users = [SELECT Id, Name FROM User WHERE UserRole.Name = 'Gestión de vuelos'];
            
            for (User myUser : users) {
                userId.add(myUser.Id);
            }

            notification.setTitle('Mantenimiento Preventivo');
            notification.setBody('Hay una aeronave a punto de salir, requiere mantenimiento preventivo');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(flight.Avion__c);
        }
        notification.send(userId);

    }
}
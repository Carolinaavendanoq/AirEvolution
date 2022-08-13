public with sharing class ScAssignFlightAttendants implements Schedulable {

    public String flightId;
    Messaging.CustomNotification notification = new Messaging.CustomNotification();

    public ScAssignFlightAttendants(String flightId) {
        this.flightId = flightId;
    }

    public void execute(SchedulableContext ctx){
        CustomNotificationType notificationType = 
        [SELECT Id, DeveloperName 
         FROM CustomNotificationType 
         WHERE DeveloperName='Assign_Crew_Members'];

         List<User> users = [SELECT Id, Name FROM User WHERE UserRole.Name = 'Gestión de vuelos'];
         set<String> userId = new set<String>();
         for (User myUser : users) {
            userId.add(myUser.Id);
         }

         notification.setTitle('Asignar Tripulación');
         notification.setBody('Es momento de asignar la tripulación de un vuelo');
         notification.setNotificationTypeId(notificationType.Id);
         notification.setTargetId(flightId);

         try {
            notification.send(userId);
            
         } catch (Exception e) {
            System.debug('There are a problem: ' + e.getMessage());
         } 
    }  

}

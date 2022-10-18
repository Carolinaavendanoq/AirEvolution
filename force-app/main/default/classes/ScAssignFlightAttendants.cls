public with sharing class ScAssignFlightAttendants implements Schedulable {

   // Se ejecuta todos los días para verificar que vuelos salen en 7 días, para así notificarles la asgnación de tripulantes
   public void execute(SchedulableContext ctx){
      AssignFlightAttendants batchTest = new AssignFlightAttendants();
      Id processId = Database.executeBatch(batchTest);
   }  
}
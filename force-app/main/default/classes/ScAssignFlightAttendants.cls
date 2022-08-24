public with sharing class ScAssignFlightAttendants implements Schedulable {
   public void execute(SchedulableContext ctx){
      AssignFlightAttendants batchTest = new AssignFlightAttendants();
      Id processId = Database.executeBatch(batchTest);
   }  
}
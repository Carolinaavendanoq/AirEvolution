public class ScPreventiveMaintenance implements Schedulable{
    public void execute(SchedulableContext ctx){
      PreventiveMaintenance batchTest = new PreventiveMaintenance();
      Id processId = Database.executeBatch(batchTest);
   }  
}
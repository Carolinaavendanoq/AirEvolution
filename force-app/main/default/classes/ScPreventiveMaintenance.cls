public class ScPreventiveMaintenance implements Schedulable{
    public void execute(SchedulableContext ctx){
        AircraftMaintenance.preventiveMaintenance();
   }  
}
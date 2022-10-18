public class ScPreventiveMaintenance implements Schedulable{

    // Ejecuta cada hora el método que notifica el mantenimiento preventivo para las aeronaves que están a punto de partir
    public void execute(SchedulableContext ctx){
        AircraftMaintenance.preventiveMaintenance();
   }  
}
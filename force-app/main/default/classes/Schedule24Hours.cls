public class Schedule24Hours implements Schedulable {

    public void execute(SchedulableContext ctx){
        ClimaModel.departureAirports();   
    }
}
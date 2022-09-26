public class ClimaSchedule1Hour implements Schedulable {
    public void execute(SchedulableContext ctx){
        ClimaModel.arriveAirports();
    }
}
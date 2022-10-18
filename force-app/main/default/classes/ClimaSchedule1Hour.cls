public class ClimaSchedule1Hour implements Schedulable {

    // Ejecuta el método que obtiene los aeropuertos de llegada cada hora, para crear los climas
    public void execute(SchedulableContext ctx){
        ClimaModel.arriveAirports();
    }
}
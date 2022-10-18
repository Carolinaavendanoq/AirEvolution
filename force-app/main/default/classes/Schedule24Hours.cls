public class Schedule24Hours implements Schedulable {

    // Cada 24 horas ejecuta el método que obtiene los vuelos que partirán ese día, para crearle el clima a la ciudad donde se encuentra el aeropuerto desde el cual el vuelo partirá
    public void execute(SchedulableContext ctx){
        ClimaModel.departureAirports();   
    }
}
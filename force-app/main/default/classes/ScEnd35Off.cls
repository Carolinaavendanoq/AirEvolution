public with sharing class ScEnd35Off  implements Schedulable {

    // Se ejecutará cada martes a las 15:00 para quitar el descuento del 35% a la venta de tiquetes
    public void execute(SchedulableContext ctx){
        End35Off batchTest = new End35Off();
        Id processId = Database.executeBatch(batchTest);
    }
}
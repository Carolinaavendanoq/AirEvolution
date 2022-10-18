public with sharing class ScTickect35Off implements Schedulable {
    // Ejecuta el descuento del 35% cada martes a las 00:00
    public void execute(SchedulableContext ctx){
        Ticket35Off batchTest = new Ticket35Off();
        Id processId = Database.executeBatch(batchTest);
    }
}
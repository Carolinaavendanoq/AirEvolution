public with sharing class ScTicket50Off  implements Schedulable {
    // Ejecuta el descuento del 50% cuando a un vuelo le faltan 24 horas para partir
    public void execute(SchedulableContext ctx){
        Ticket50Off batchTest = new Ticket50Off();
        Id processId = Database.executeBatch(batchTest);
        
    }
}
public with sharing class ScTicket50Off  implements Schedulable {

    public void execute(SchedulableContext ctx){
        Ticket50Off batchTest = new Ticket50Off();
        Id processId = Database.executeBatch(batchTest);
        
    }
}
public with sharing class ScTickect35Off implements Schedulable {
    public void execute(SchedulableContext ctx){
        Ticket35Off batchTest = new Ticket35Off();
        Id processId = Database.executeBatch(batchTest);
    }
}

public with sharing class ScEnd35Off  implements Schedulable {
    public void execute(SchedulableContext ctx){
        End35Off batchTest = new End35Off();
        Id processId = Database.executeBatch(batchTest);
    }
}
public with sharing class SCSaveBooking3H implements Schedulable{
    public void execute(SchedulableContext ctx){
        SaveBooking3H batchTest = new SaveBooking3H();
        Id processId = Database.executeBatch(batchTest);
     }  
}
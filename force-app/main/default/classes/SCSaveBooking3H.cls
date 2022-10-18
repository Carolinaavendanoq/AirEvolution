public with sharing class SCSaveBooking3H implements Schedulable{
    // Cada hora se ejecuta para verificar si el estado de la reserva ha cambiado
    public void execute(SchedulableContext ctx){
        SaveBooking3H batchTest = new SaveBooking3H();
        Id processId = Database.executeBatch(batchTest);
     }  
}
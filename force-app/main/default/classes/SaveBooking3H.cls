public with sharing class SaveBooking3H implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        Datetime past = Datetime.now().addHours(-3);
        Datetime present = Datetime.now();
        return Database.getQueryLocator('SELECT Id, StageName, LastModifiedDate FROM Opportunity WHERE  (LastModifiedDate >=: past AND LastModifiedDate <=: present) AND StageName IN (\'Pre-venta\', \'Completado\')');
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> bookings){
        Datetime lastModification = Datetime.now();
        Integer currentHour = lastModification.hour();
        Integer bookingHour;
        Set<Id> bookingsId = new Set<Id>();
        try {


            for (Opportunity booking : bookings) {
                    bookingHour = (booking.LastModifiedDate).hour();
                    // Diferencia entre la hora actual y la hora de la última modificación hecha  a la reserva, si es igual a 3 horas, la reserva es modificada
                    if(currentHour - bookingHour == 3){
                        booking.StageName = 'No pagado';
                        bookingsId.add(booking.Id);
                    }
                    
            }
            update bookings;

            // Busco los tiquetes pertenecientes a la reserva que cambió a estado "No Pagado", para eliminarlos y liberar asientos
            List<OpportunityLineItem> deleteTickets = [SELECT Id From OpportunityLineItem 
            WHERE OpportunityId =: bookingsId];
            delete deleteTickets;

        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }

    public void finish(Database.BatchableContext BC){
    }
}
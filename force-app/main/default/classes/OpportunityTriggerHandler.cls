public without sharing class OpportunityTriggerHandler implements TriggerHandler{

    private boolean triggerIsExecuting;
    private integer triggerSize;

    public OpportunityTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Opportunity> newOpportunities){
        // code
        bookingName(newOpportunities);
    }

    public void beforeUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap){
        // code
        withoutFlight(newOpportunities);
        paidBooking(newOpportunities);
    }

    public void beforeDelete(List<Opportunity> oldOpportunities, Map<ID, SObject> oldOpportunityMap){

    }

    public void afterInsert(List<Opportunity> newOpportunities, Map<ID, SObject> newOpportunityMap){
        
    }

    public void afterUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap){
        
    }

    public void afterDelete(List<Opportunity> oldOpportunities, Map<ID, SObject> oldOpportunityMap){
        
    }

    public void afterUndelete(List<Opportunity> newOpportunities, Map<ID, SObject> newOpportunityMap){

    }

    public static void bookingName(List<Opportunity> opportunitiesNew){
        Set<Id> holdersId = new Set<Id>();
        for (Opportunity opportunityNew : opportunitiesNew) {
            holdersId.add(opportunityNew.Titular_de_reserva__c);
        }
        Map<Id, Contact> holders = new Map<Id, Contact>([SELECT Name FROM Contact WHERE Id =: holdersId]);

        for (Opportunity opportunityNew : opportunitiesNew) {
            if (String.isNotEmpty(opportunityNew.Name)) {
                String bookingNumber = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 6);
                
                opportunityNew.Name = holders.get(opportunityNew.Titular_de_reserva__c).Name.replace(' ', '') + bookingNumber;
            }
        }
    }

    public static void withoutFlight(List<Opportunity> opportunitiesNew){
        for(Opportunity booking : opportunitiesNew){
            if((booking.Numero_de_vuelos__c < 1 && booking.StageName == 'Pagado') || (booking.Numero_de_vuelos__c < 1 && booking.StageName == 'Completado')){
                booking.Numero_de_vuelos__c.addError('Para cambiar el estado de la reserva, esta debe tener asignado al menos un vuelo');
            } 
        }
    }

    // If a booking' state is 'Pagada', update "Fecha de pago" field and send an email to the passenger with the info of his booking.
    public static void paidBooking(List<Opportunity> opportunitiesNew){
        for (Opportunity booking : opportunitiesNew){
            if (booking.StageName == 'Pagado') {
                booking.Fecha_de_pago__c = Date.newInstance(Date.today().year(), date.today().month(), Date.today().day());
               
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // Send mail
                String[] toAddresses = new String[] { 'carolina.avendanoq@gmail.com' };                
                mail.setToAddresses(toAddresses);
                // Reply email
                mail.setReplyTo('support@acme.com');
                // Name to display
                mail.setSenderDisplayName('Salesforce Support');
                // Subject
                mail.setSubject('CONFIRMACIÓN DE RESERVA');
                // Body
                mail.setPlainTextBody('Hola '+ booking.Titular_de_reserva__c +' para nosotros es un placer informale que su reserva número ' 
                                    + booking.Numero_de_reserva__c + ' ha sido pagada exitosamente');
                // Signature
                mail.setUseSignature(false);
                // Message
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });
                // Call test method
                inspectResults(results);
            }            
        }
    }
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
}
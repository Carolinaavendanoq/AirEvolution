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
}
public without sharing class AuxiliaresVueloTriggerHandler implements TriggerHandler{

    private boolean triggerIsExecuting;
    private integer triggerSize;

    public AuxiliaresVueloTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Auxiliares_de_vuelo__c> newFlightAttendant){
        // code
    }

    public void beforeUpdate(List<Auxiliares_de_vuelo__c> oldFlightAttendants, List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> oldFlightAttendantMap, Map<ID, SObject> newFlightAttendantMap){
        // code

    }

    public void beforeDelete(List<Auxiliares_de_vuelo__c> oldFlightAttendants, Map<ID, SObject> oldFlightAttendantMap){

    }

    public void afterInsert(List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> newFlightAttendantMap){
        
    }

    public void afterUpdate(List<Auxiliares_de_vuelo__c> oldFlightAttendants, List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> oldFlightAttendantMap, Map<ID, SObject> newFlightAttendantMap){
        
    }

    public void afterDelete(List<Auxiliares_de_vuelo__c> oldFlightAttendants, Map<ID, SObject> oldFlightAttendantMap){
        
    }

    public void afterUndelete(List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> newFlightAttendantMap){

    }

    public void stopAllocation(List<Auxiliares_de_vuelo__c> flightAttendantsNew){

    }

}

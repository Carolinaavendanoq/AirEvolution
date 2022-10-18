public without sharing class AuxiliaresVueloTriggerHandler implements TriggerHandler{

    private boolean triggerIsExecuting;
    private integer triggerSize;

    public AuxiliaresVueloTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    // Método ejecutado antes de que se inserte un Auxiliar de Vuelo
    public void beforeInsert(List<Auxiliares_de_vuelo__c> newFlightAttendant){
        
        stopAllocation(newFlightAttendant);
    }

    // Método ejecutado antes de que se actualice un Auxiliar de Vuelo
    public void beforeUpdate(List<Auxiliares_de_vuelo__c> oldFlightAttendants, List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> oldFlightAttendantMap, Map<ID, SObject> newFlightAttendantMap){
        

    }

    // Método ejecutado antes de que se elimine un Auxiliar de Vuelo
    public void beforeDelete(List<Auxiliares_de_vuelo__c> oldFlightAttendants, Map<ID, SObject> oldFlightAttendantMap){

    }

    // Método ejecutado después de que se inserte un Auxiliar de Vuelo
    public void afterInsert(List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> newFlightAttendantMap){
        
    }

    // Método ejecutado después de que se actualice un Auxiliar de Vuelo
    public void afterUpdate(List<Auxiliares_de_vuelo__c> oldFlightAttendants, List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> oldFlightAttendantMap, Map<ID, SObject> newFlightAttendantMap){
        
    }

    // Método ejecutado después de que se elimine un Auxiliar de Vuelo
    public void afterDelete(List<Auxiliares_de_vuelo__c> oldFlightAttendants, Map<ID, SObject> oldFlightAttendantMap){
        
    }

    // Método ejecutado después de que se elimine un Auxiliar de Vuelo
    public void afterUndelete(List<Auxiliares_de_vuelo__c> newFlightAttendant, Map<ID, SObject> newFlightAttendantMap){

    }

    // Realiza el conteo de auxiliares de vuelo agrupados por vuelo y los contrasta con el número de auxiliares requeridos de la aeronave para cada uno de esos vuelos. En el momento en que el número de auxilaires requeridos y asignados sea igual y se intente asignar otro tripulante, se mostrará un error en pantalla impidiendo que se inserte un nuevo auxiliar de vuelo
    public void stopAllocation(List<Auxiliares_de_vuelo__c> flightAttendantsNew){
        Set<Id> flightsId = new set<Id>();
        for (Auxiliares_de_vuelo__c flightAttendant : flightAttendantsNew) {
            flightsId.add(flightAttendant.Vuelo__c);
        }

        AggregateResult[] groupedResults = [SELECT COUNT(Auxiliares_de_vuelo__c), Vuelo__c FROM Auxiliares_de_vuelo__c WHERE Vuelo__c IN: flightsId GROUP BY Vuelo__c];

        List<Product2> flights = [SELECT Id, Avion__r.Auxiliares_de_vuelo_requeridos__c FROM Product2 WHERE Id IN: flightsId];

        for (AggregateResult ar : groupedResults) {
            for (Product2 flight : flights) {
                if (ar.get('Vuelo__c') == flight.Id) {
                    if (ar.get('expr0') == flight.Avion__r.Auxiliares_de_vuelo_requeridos__c) {
                        for (Auxiliares_de_vuelo__c flightAttendant : flightAttendantsNew) {
                            if (flightAttendant.Vuelo__c == flight.Id) {
                                flightAttendant.addError('Asignación de Auxiliares de vuelo completada');
                            }
                        }
                    }
                }
            }
        }
    }

}
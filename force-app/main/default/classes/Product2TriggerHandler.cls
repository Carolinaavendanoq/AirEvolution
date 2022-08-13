public without sharing class Product2TriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    
    public Product2TriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Product2> newProduct2s){
        // code
        flightNumber(newProduct2s);
    }

    public void beforeUpdate(List<Product2> oldProduct2s, List<Product2> newProduct2s, Map<ID, SObject> oldProduct2Map, Map<ID, SObject> newProduct2Map){
        // code
        disableFlight(newProduct2s);
        
    }

    public void beforeDelete(List<Product2> oldProduct2s, Map<ID, SObject> oldProduct2Map){

    }

    public void afterInsert(List<Product2> newProduct2s, Map<ID, SObject> newProduct2Map){

    }

    public void afterUpdate(List<Product2> oldProduct2s, List<Product2> newProduct2s, Map<ID, SObject> oldProduct2Map, Map<ID, SObject> newProduct2Map){

    }

    public void afterDelete(List<Product2> oldProduct2s, Map<ID, SObject> oldProduct2Map){
        
    }

    public void afterUndelete(List<Product2> newProduct2s, Map<ID, SObject> newProduct2Map){

    }

    public static void disableFlight(List<Product2> product2New){
        for (Product2 p2 : product2New) {
            if (p2.IsActive != false && (p2.Estado__c == 'Cancelado' || p2.Estado__c == 'Terminado')) {
                p2.IsActive = false;
                if (p2.Estado__c == 'Cancelado' && String.isNotEmpty(p2.Motivo_de_cancelacion__c)) {
                    date currentDate = date.today();
                    p2.Fecha_de_cancelacion__c = currentDate;
                }else if(p2.Estado__c == 'Cancelado'){
                    p2.Motivo_de_cancelacion__c.addError('Debe asignar un motivo de cancelación a los vuelos en estado cancelado');
                }
            }
        }
    }

    public static void flightNumber(List<Product2> product2New){
        for (Product2 flight : product2New) {
            if (flight.Name != null) {
                String flightNumber = 'AE-' + Integer.valueOf(Math.random() * 10000);
                flight.Name = flightNumber;
                flight.IsActive = true;
            }
        }
    }


    public static void apply50Off(List<Product2> product2New){
        for (Product2 flight : product2New) {
            DateTime launchDate = (flight.Fecha_y_hora_de_partida__c).addDays(-1);
            Integer second = launchDate.second();
            Integer minute = launchDate.minute();
            Integer hour = launchDate.hour();
            Integer dia = launchDate.day();
            Integer mes = launchDate.month();
            String customName = 'Discount to ' + flight.Name;

            ScTicket50Off s = new ScTicket50Off(flight.Id);
            String sch = second + ' ' + minute + ' ' + hour + ' ' + dia + ' ' + mes + ' ? *';
            String jobID = system.schedule(customName, sch, s);
        }
    }

    public static void assignCrewMembers(List<Product2> product2New){
        for (Product2 flight : product2New) {
            DateTime launchDate = (flight.Fecha_y_hora_de_partida__c).addDays(-7);
            Integer second = launchDate.second();
            Integer minute = launchDate.minute();
            Integer hour = launchDate.hour();
            Integer dia = launchDate.day();
            Integer mes = launchDate.month();
            String customName = 'Notification to ' + flight.Name;

            ScAssignFlightAttendants s = new ScAssignFlightAttendants(flight.Id);
            String sch = second + ' ' + minute + ' ' + hour + ' ' + dia + ' ' + mes + ' ? *';
            String jobID = system.schedule(customName, sch, s);
        }
    }

}
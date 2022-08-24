public without sharing class OpportunityLineItemTriggerHandler implements TriggerHandler {

    private boolean triggerIsExecuting;
    private integer triggerSize;

    public OpportunityLineItemTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<OpportunityLineItem> newOpportunityLineItems){
        // code
        addPassenger(newOpportunityLineItems);
        oversell(newOpportunityLineItems);
        assignBusinessClass(newOpportunityLineItems);
        departureDate(newOpportunityLineItems);
        touristCategory(newOpportunityLineItems);
        cargoCategory(newOpportunityLineItems);
    }

    public void beforeUpdate(List<OpportunityLineItem> oldOpportunityLineItems, List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> oldOpportunityLineitemMap, Map<ID, SObject> newOpportunityLineitemMap){
        // code
        addPassenger(newOpportunityLineItems);
    }

    public void beforeDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<ID, SObject> oldOpportunityLineitemMap){

    }

    public void afterInsert(List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> newOpportunityLineitemMap){
    }

    public void afterUpdate(List<OpportunityLineItem> oldOpportunityLineItems, List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> oldOpportunityLineitemMap, Map<ID, SObject> newOpportunityLineitemMap){
        
    }

    public void afterDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<ID, SObject> oldOpportunityLineitemMap){
        
    }

    public void afterUndelete(List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> newOpportunityLineitemMap){

    }

    public static void addPassenger(List<OpportunityLineItem> opportunityLineItemNeW){
        List<Opportunity> opportunities = new List<Opportunity>([SELECT Id,Titular_de_reserva__c FROM Opportunity WHERE StageName = 'Pre-venta']);
        for (Opportunity opportunity: opportunities){
            for (OpportunityLineItem oli : opportunityLineItemNew) {
                if(oli.OpportunityId == opportunity.Id && oli.Pasajero__c == null){
                    oli.Pasajero__c = opportunity.Titular_de_reserva__c;  
                }
            }
        }
    }

    public void oversell(List<OpportunityLineItem> opportunityLineItemNeW){
        
        set <Id> idFlights = new set<Id>();
        for (opportunityLineItem oli : opportunityLineItemNeW)
        {
            idFlights.add(oli.Product2Id);
        }
        
        map<Id , Product2> flights = new map<Id , Product2>([SELECT Id,Avion__r.Numero_de_pasajeros_clase_negocios__c, Avion__r.Numero_de_pasajeros_clase_turista__c FROM Product2 WHERE Id IN :idFlights]); 

        AggregateResult[] groupedResults = [SELECT Count(Id),Product2Id FROM OpportunityLineItem WHERE Product2Id IN :idFlights GROUP BY Product2Id];

        List<Product2> addFlights = new List<Product2>();
        for (AggregateResult ar : groupedResults){
            
            decimal totalPassengers = flights.get((String)ar.get('Product2Id')).Avion__r.Numero_de_pasajeros_clase_negocios__c + flights.get((String)ar.get('Product2Id')).Avion__r.Numero_de_pasajeros_clase_turista__c;

            if ((totalPassengers * 1.1) < (Integer)ar.get('expr0')) {
                addFlights.add(new Product2(Id = (String)ar.get('Product2Id')));
            }
            
        }
        for(opportunityLineItem oli: opportunityLineItemNeW){
            for(Product2 flight: addFlights){
                if (oli.Product2Id == flight.Id){
                    oli.addError('No está permitido sobrevender tiquetes');
                }
            }
        }
    }

    public static void assignBusinessClass(List<OpportunityLineItem> opportunityLineItemNeW){
        Pricebook2 businessId = [SELECT Id FROM Pricebook2 WHERE Name = 'Clase negocio' LIMIT 1];

        Set<Id> idBookings= new Set<Id>();
        for (OpportunityLineItem oli : opportunityLineItemNeW){
            idBookings.add(oli.OpportunityId);
        }

        List<Opportunity> bookings = [SELECT Id FROM Opportunity WHERE Id IN :idBookings AND Pricebook2Id = :businessId.Id];

        for (OpportunityLineItem oli : opportunityLineItemNeW) {
            for (Opportunity booking : bookings){
                if (oli.OpportunityId == booking.Id) {
                    oli.Equipaje_permitido__c = 'Personal;Maleta de cabina;Maleta de bodega';
                    oli.Categoria__c = 'Negocio';
                }                
            }
        }
    }

    public static void departureDate(List<OpportunityLineItem> opportunityLineItemsNeW){
        Set<Id> flightsId = new Set<Id>();
        for (OpportunityLineItem ticket : opportunityLineItemsNeW) {
            flightsId.add(ticket.Product2Id);
        }

        List<Product2> flights = [SELECT Id, Fecha_y_hora_de_partida__c FROM Product2 WHERE Id IN :flightsId];

        for (Product2 flight : flights) {
            for (OpportunityLineItem ticket : opportunityLineItemsNeW) {
                if (ticket.Product2Id == flight.Id) {
                    DateTime departureDatetime = flight.Fecha_y_hora_de_partida__c;
                    System.debug('Fecha y hora de partida ' + departureDatetime);
                    Date travelDate = Date.newInstance(departureDatetime.year(), departureDatetime.month(), departureDatetime.day());System.debug('Fecha de viaje ' + travelDate);
                    ticket.ServiceDate = travelDate;
                }
            }
        }
    }


    public static void touristCategory(List<OpportunityLineItem> opportunityLineItemsNeW){
        Decimal allBaggage;
        Decimal personalCockpit;
        Decimal cockpitHold;
        Decimal personalHold;

        String touristId = [SELECT Id FROM Pricebook2 WHERE name = 'Clase turista' Limit 1].Id;

        Set<Id> idBookings= new Set<Id>();
        for (OpportunityLineItem oli : opportunityLineItemsNeW){
            idBookings.add(oli.OpportunityId);
        }

        Set<Id> idFlights= new Set<Id>();
        for (OpportunityLineItem ticket :opportunityLineItemsNeW){
            idFlights.add(ticket.Product2Id);
        }

        List<Opportunity> bookings = [SELECT Id FROM Opportunity WHERE Id IN :idBookings AND Pricebook2Id = :touristId];

        List<PricebookEntry> pricebookEntries = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :touristId AND Product2Id IN :idFlights];

        for (OpportunityLineItem oli : opportunityLineItemsNeW) {
            for (Opportunity booking : bookings){
                if (oli.OpportunityId == booking.Id) {
                    oli.Categoria__c = 'Turista';
                    for (PricebookEntry priceEntry : pricebookEntries) {
                        if (oli.Equipaje_permitido__c == 'Personal;Maleta de cabina;Maleta de bodega') {
                            allBaggage = priceEntry.UnitPrice + (priceEntry.UnitPrice * 0.08);
                            oli.UnitPrice = allBaggage;
                        }else if (oli.Equipaje_permitido__c == 'Personal;Maleta de cabina') {
                            personalCockpit = priceEntry.UnitPrice + (priceEntry.UnitPrice * 0.02);
                            oli.Unitprice = personalCockpit;
                        } else if(oli.Equipaje_permitido__c == 'Maleta de cabina;Maleta de bodega'){
                            cockpitHold = priceEntry.UnitPrice + (priceEntry.UnitPrice * 0.06);
                            oli.unitPrice = cockpitHold;
                        }else if(oli.Equipaje_permitido__c == 'Personal;Maleta de bodega'){
                            personalHold = priceEntry.UnitPrice + (priceEntry.UnitPrice * 0.04);
                            oli.UnitPrice = personalHold;
                        }
                    }
                }                
            }
        }

    }

    public static void cargoCategory(List<OpportunityLineItem> opportunityLineItemsNeW){
        Set<Id> idFlights= new Set<Id>();
        for (OpportunityLineItem oli : opportunityLineItemsNeW){
            idFlights.add(oli.Product2Id);
        }
        
        String cargoId = [SELECT Id FROM Pricebook2 WHERE name = 'Carga' Limit 1].Id;

        List<PricebookEntry> pricebookEntries = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id = :cargoId AND Product2Id IN :idFlights];

        for (PricebookEntry priceEntry : pricebookEntries) {
            for (OpportunityLineItem oli : opportunityLineItemsNeW){
                if (oli.Product2Id == priceEntry.Product2Id) {
                    oli.Categoria__c = 'Carga';
                }                
            }
        }
    }

    /* public static void ticketEvent(List<OpportunityLineItem> opportunityLineItemsNeW){
        // añadir tiquetes al calendario
    }*/

}
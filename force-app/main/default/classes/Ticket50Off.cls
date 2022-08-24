public with sharing class Ticket50Off implements Database.Batchable<sObject>{

    Datetime nowDate = Datetime.now();

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Fecha_y_hora_de_partida__c, Aeropuerto_de_partida__c,Estado__c, Aeropuerto_de_llegada__c FROM Product2 WHERE Fecha_y_hora_de_partida__c != null AND IsActive = true AND(Fecha_y_hora_de_partida__c > TODAY AND Fecha_y_hora_de_partida__c <= TOMORROW)';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Product2> flights){
        Integer nowHour = nowDate.hour();
        Integer flightHour;

        List<Product2> flights24H = new List<Product2>();
        List<Product2> oldFlights = [SELECT Id, Aeropuerto_de_partida__c,Aeropuerto_de_llegada__c FROM Product2 WHERE Estado__c = 'Terminado'];
        

        Set<Id> flightsId = new Set<Id>();
        Set<Id> oldfligtsId = new Set<Id>();
        Set<Id> passengersId = new Set<Id>();
        Set<Id> oldPassengersId = new Set<Id>();
        // facilisis.suspendisse@aol.ca
        // ligula.elit@icloud.org

        for (Product2 flight : flights) {
            flightHour= flight.Fecha_y_hora_de_partida__c.hour();
            if (flightHour == nowHour) {
                flightsId.add(flight.Id);
                flights24H.add(flight);
            }
        }
    

        List<PricebookEntry> pricebooks = [SELECT Id, UnitPrice, Descuento_35__c, Descuento_50__c FROM PricebookEntry WHERE Descuento_35__c IN (false, true) AND Descuento_50__c = false AND IsActive = true AND Product2Id =: flightsId];

        Decimal discount;
        Decimal withouthDiscount;

        for(PricebookEntry pricebook: pricebooks){
            if (pricebook.Descuento_35__c) {
                withouthDiscount = pricebook.UnitPrice / 0.65;
                pricebook.UnitPrice = withouthDiscount;
                pricebook.Descuento_35__c = false;
            }
    
            discount = pricebook.UnitPrice - (pricebook.UnitPrice * 0.5);
            pricebook.UnitPrice = discount;
            pricebook.Descuento_50__c = true;
        }
        update pricebooks;

        List<OpportunityLineItem> tickets = [SELECT Id, Pasajero__c, Asiento__c,Equipaje_permitido__c, Categoria__c, Puerta_de_embarque__c FROM OpportunityLineItem WHERE Product2Id =: flightsId];

        for (OpportunityLineItem ticket : tickets) {
            passengersId.add(ticket.Pasajero__c);
        }

        Map<Id, Contact>  passengers = new Map<Id, Contact>([SELECT Id, Name, Email FROM Contact WHERE Id =: passengersId]); 
        for (OpportunityLineItem ticket : tickets) {
            String ticketInfo = 'Saludos ' + passengers.get(ticket.Pasajero__c).Name + ', \n' + 'Air E-volution le desea un feliz día y nos complace notificarles que es momento de realizar el Check-in. A continuación encontrará la información de su(s) tiquete(s): \n' + 'Asiento: ' + ticket.Asiento__c + '\n' + 'Puerta de embarque: ' + ticket.Puerta_de_embarque__c + '\n' +  'Equipaje: ' + ticket.Equipaje_permitido__c + '\n' + 'Categoría: ' + ticket.Categoria__c + '\n';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            String[] toAddresses = new String[] { passengers.get(ticket.Pasajero__c).Email};   
                
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('carolina.avendanoq@gmail.com');
            mail.setSenderDisplayName('Salesforce Support');
            mail.setSubject('INFORMACIÓN TIQUETE E INVITACIÓN A CHECK-IN');
            mail.setPlainTextBody(ticketInfo);
            mail.setUseSignature(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });    
        }

        
        for (Product2 flight : flights24H) {
            for (Product2 oldFlight : oldFlights) {
                if (oldFlight.Aeropuerto_de_partida__c == flight.Aeropuerto_de_partida__c && oldFlight.Aeropuerto_de_llegada__c == flight.Aeropuerto_de_llegada__c) {
                    oldfligtsId.add(oldFlight.Id);
                }
            }
        }

        List<OpportunityLineItem> oldTickets = [SELECT Id, Pasajero__c, Product2Id FROM OpportunityLineItem WHERE Product2Id =: oldfligtsId];

        for (OpportunityLineItem ticket : oldTickets) {
            oldPassengersId.add(ticket.Pasajero__c);
        }

        Map<Id, Contact>  oldPassengers = new Map<Id, Contact>([SELECT Id, Name, Email FROM Contact WHERE Id =: oldPassengersId]); 

        for (Product2 flight : flights24H) {
            for (Product2 oldFlight : oldFlights) {
                if (oldFlight.Aeropuerto_de_partida__c == flight.Aeropuerto_de_partida__c && oldFlight.Aeropuerto_de_llegada__c == flight.Aeropuerto_de_llegada__c) {
                    for (OpportunityLineItem ticket : oldTickets) {
                        if (ticket.Product2Id == oldFlight.Id) {
                            String enjoyDiscount = 'Saludos ' + oldPassengers.get(ticket.Pasajero__c).Name + ', \n' + 'Air E-volution le desea un feliz día invitándolo a aprovechar una oferta imperdible. Tenemos un vuelo con el  50% de descuento, a continuación encontrará la información del vuelo: \n' + 'Número de vuelo: ' + flight.Name + '\n' + 'Aeropuerto de partida: ' + flight.Aeropuerto_de_partida__c + '\n' +  'Aeropuerto de llegada: ' + flight.Aeropuerto_de_llegada__c + '\n' + 'Fecha y hora de partida: ' + flight.Fecha_y_hora_de_partida__c;

                            Messaging.SingleEmailMessage oldMail = new Messaging.SingleEmailMessage();
                                
                            String[] toAddresses = new String[] { oldPassengers.get(ticket.Pasajero__c).Email};   
                                
                            oldMail.setToAddresses(toAddresses);
                            oldMail.setReplyTo('carolina.avendanoq@gmail.com');
                            oldMail.setSenderDisplayName('Salesforce Support');
                            oldMail.setSubject('DESCUENTO DEL 50% EN VUELOS PRÓXIMOS A PARTIR');
                            oldMail.setPlainTextBody(enjoyDiscount);
                            oldMail.setUseSignature(false);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { oldMail });
                            Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { oldMail });    
                        }
                    }
                }
            }
        }

    }

    public void finish(Database.BatchableContext bc){
        
    }


}
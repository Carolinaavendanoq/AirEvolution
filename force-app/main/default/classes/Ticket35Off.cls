public class Ticket35Off implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, UnitPrice, Descuento_35__c FROM PricebookEntry WHERE Descuento_35__c = false AND Descuento_50__c = false AND IsActive = true';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<PricebookEntry> pricebooks){
        Decimal discount;
        for(PricebookEntry pricebook: pricebooks){
            discount = pricebook.UnitPrice - (pricebook.UnitPrice * 0.35);
            pricebook.UnitPrice = discount;
            pricebook.Descuento_35__c = true;
        }
        update pricebooks;
    }

    public void finish(Database.BatchableContext bc){
        
    }

    // Notificar de descuento de tiquetes

}
public with sharing class End35Off implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, UnitPrice, Descuento_35__c FROM PricebookEntry WHERE Descuento_35__c = true AND Descuento_50__c = false AND IsActive = true';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<PricebookEntry> pricebooks){
        Decimal withouthDiscount;
        for(PricebookEntry pricebook: pricebooks){
            withouthDiscount = pricebook.UnitPrice / 0.65;
            pricebook.UnitPrice = withouthDiscount;
            pricebook.Descuento_35__c = false;
        }
        update pricebooks;
    }

    public void finish(Database.BatchableContext bc){
        
    }

    // Notificar de descuento de tiquetes

}

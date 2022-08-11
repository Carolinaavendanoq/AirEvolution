public with sharing class CheckIn implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id FROM PricebookEntry');
    }

    public void execute(Database.BatchableContext bc, List<PricebookEntry> pricebooks){
        Decimal discount;
        for(PricebookEntry pricebook: pricebooks){
            discount = pricebook.UnitPrice / 0.65;
            pricebook.UnitPrice = discount;
            pricebook.Descuento_35__c = false;
            pricebook.Descuento_50__c = true;
        }
        update pricebooks;
    }

    public void finish(Database.BatchableContext bc){
        
    }

    // Notificar de descuento de tiquetes

}

public with sharing class ScTicket50Off  implements Schedulable {
    public String flightId;

    public ScTicket50Off(String flightId){
        this.flightId = flightId;
    }

    public void execute(SchedulableContext ctx){
        List<PricebookEntry> prices = [SELECT Id, UnitPrice, Descuento_35__c, Descuento_50__c FROM PricebookEntry WHERE Descuento_35__c IN (false, true) AND Descuento_50__c = false AND IsActive = true AND Product2Id =: flightId ];

        Decimal discount;
        Decimal withouthDiscount;
        for(PricebookEntry pricebook: prices){

            if (pricebook.Descuento_35__c) {
                withouthDiscount = pricebook.UnitPrice / 0.65;
                pricebook.UnitPrice = withouthDiscount;
                pricebook.Descuento_35__c = false;
            }

            discount = pricebook.UnitPrice - (pricebook.UnitPrice * 0.5);
            pricebook.UnitPrice = discount;
            pricebook.Descuento_50__c = true;
        }
        update prices;
    }
}

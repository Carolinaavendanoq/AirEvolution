public class arriveAirportWeather implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Estado__c, Aeropuerto_de_llegada__c, Aeropuerto_de_llegada__r.Localizacion__Latitude__s,  Aeropuerto_de_llegada__r.Localizacion__Longitude__s, Fecha_y_hora_de_partida__c FROM Product2';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Product2> flights){
        Datetime verifyDepartureHour = Datetime.now();
        List<Product2> planesInFlight = new List<Product2>();
        List<Clima__c> weathers = new List<Clima__c>();
        for(Product2 flight : flights){
            if(flight.Fecha_y_hora_de_partida__c <= verifyDepartureHour && (flight.Estado__c == 'En venta' || flight.Estado__c == 'Check in')){
                String latitude = String.valueOf(flight.Aeropuerto_de_llegada__r.Localizacion__Latitude__s);
                String longitude = String.valueOf(flight.Aeropuerto_de_llegada__r.Localizacion__Longitude__s);
                Decimal temperature = ClimaRest.getWeather(latitude, longitude);
                Clima__c weather = new Clima__c(Aeropuerto__c = flight.Aeropuerto_de_llegada__c, Fecha_y_hora_de_prediccion__c = Datetime.now(), Unidad__c = 'Centigrados', Temperatura__c = temperature);
                weathers.add(weather);
                flight.Estado__c = 'En vuelo';
                planesInFlight.add(flight);
            }
        }
        update planesInFlight;
        insert weathers;
    }

    public void finish(Database.BatchableContext bc){
        
    }


}
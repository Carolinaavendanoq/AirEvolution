public class departureAirportWeather implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Fecha_y_hora_de_partida__c, Aeropuerto_de_partida__c, Aeropuerto_de_partida__r.Localizacion__Latitude__s,  Aeropuerto_de_partida__r.Localizacion__Longitude__s FROM Product2 WHERE Estado__c = \'En venta\' AND IsActive = True AND Fecha_y_hora_de_partida__c != null AND(Fecha_y_hora_de_partida__c > TODAY AND Fecha_y_hora_de_partida__c <= TOMORROW)';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Product2> flights){
        Datetime nowDate = Datetime.now();
        Integer nowHour = nowDate.hour();
        Integer flightHour;
        List<Clima__c> weathers = new List<Clima__c>();
        for(Product2 flight : flights){
            flightHour= flight.Fecha_y_hora_de_partida__c.hour();
            if (flightHour == nowHour) {
                String latitude = String.valueOf(flight.Aeropuerto_de_partida__r.Localizacion__Latitude__s);
                String longitude = String.valueOf(flight.Aeropuerto_de_partida__r.Localizacion__Longitude__s);
                Decimal temperature = ClimaRest.getWeather(latitude, longitude);
                Clima__c weather = new Clima__c(Aeropuerto__c = flight.Aeropuerto_de_partida__c, Fecha_y_hora_de_prediccion__c = Datetime.now(), Unidad__c = 'Centigrados', Temperatura__c = temperature);
                weathers.add(weather);
            }

        }
        insert weathers;
        
    }

    public void finish(Database.BatchableContext bc){
        
    }

}
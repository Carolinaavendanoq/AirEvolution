public class ClimaModel {
    
    public static void insertWeatherData(Map<Integer,Map<String, String>> values){
        try{
        	List<Clima__c> weathers = new List<Clima__c>();
            String latitude;
            String longitude;
            String airportId;
            Decimal temperature;
            for(Integer i : values.keySet()){
                Map<String, String> valuesKeySet = values.get(i);
                if(valuesKeySet.containskey('latitud')){
                    latitude = valuesKeySet.get('latitud');
                }
                if(valuesKeySet.containskey('longitud')){
                    longitude = valuesKeySet.get('longitud');
                }
                if(valuesKeySet.containskey('id')){
                    airportId = valuesKeySet.get('id');
                }
                temperature = ClimaRest.getWeather(latitude, longitude);
                Clima__c weather = new Clima__c(Aeropuerto__c = airportId, Fecha_y_hora_de_prediccion__c = Datetime.now(), Unidad__c = 'Centigrados', Temperatura__c = temperature);
            	weathers.add(weather);
            }  
            insert weathers;
        }catch(exception e){
            System.debug('Debug insert weather' + e);
        }

    }
    
    @future(callout=true)
    public  static void departureAirports(){
        try{
            List<Product2> flights = [SELECT Id, Estado__c, Fecha_y_hora_de_partida__c, Aeropuerto_de_partida__c, Aeropuerto_de_partida__r.Localizacion__Latitude__s,  Aeropuerto_de_partida__r.Localizacion__Longitude__s FROM Product2 WHERE IsActive = True AND(Estado__c = 'En venta' OR Estado__c = 'Check in') AND Fecha_y_hora_de_partida__c != null AND(Fecha_y_hora_de_partida__c > TODAY AND Fecha_y_hora_de_partida__c <= TOMORROW)];
        	Map<Integer,Map<String, String>> finalResults = new Map<Integer,Map<String, String>>();
        	Map<String, String> arriveValues = new Map<String, String> ();
        	Integer counter = 0;
        	for(Product2 flight: flights){
            	String latitude = String.valueOf(flight.Aeropuerto_de_partida__r.Localizacion__Latitude__s);
            	String longitude = String.valueOf(flight.Aeropuerto_de_partida__r.Localizacion__Longitude__s);
            	String departureAirportId = flight.Aeropuerto_de_partida__c;
            	arriveValues.put('latitud', latitude);
            	arriveValues.put('longitud', longitude);
            	arriveValues.put('id', departureAirportId);
            	finalResults.put(counter, arriveValues);
            	arriveValues = new Map<String, String>();
            	counter +=1;
        	}
        	insertWeatherData(finalResults);
        }catch(exception e){
            System.debug('error ' + e.getMessage());
        }  
    }
    
    @future(callout=true)
    public static void arriveAirports(){
        try{
            List<Product2> flights = [SELECT Id, Estado__c, Aeropuerto_de_llegada__c, Aeropuerto_de_llegada__r.Localizacion__Latitude__s,  Aeropuerto_de_llegada__r.Localizacion__Longitude__s, Fecha_y_hora_de_partida__c FROM Product2 WHERE Fecha_y_hora_de_partida__c = TODAY AND(Estado__c = 'En venta' OR Estado__c = 'Check in')];
        	Datetime runHour = Datetime.now(); 
        	Integer nowHour = runHour.hour();
       		Integer flightHour;
        	Map<Integer,Map<String, String>> finalResults = new Map<Integer,Map<String, String>>();
        	Map<String, String> arriveValues = new Map<String, String> ();
        	Integer counter = 0;
        	for(Product2 flight: flights){
            	flightHour= flight.Fecha_y_hora_de_partida__c.hour();
            	
            	if (flightHour == nowHour) {
                	String latitude = String.valueOf(flight.Aeropuerto_de_llegada__r.Localizacion__Latitude__s);
               		String longitude = String.valueOf(flight.Aeropuerto_de_llegada__r.Localizacion__Longitude__s);
                	String arriveAirportId = flight.Aeropuerto_de_llegada__c;
                	arriveValues.put('latitud', latitude);
                	arriveValues.put('longitud', longitude);
                	arriveValues.put('id', arriveAirportId);
                	finalResults.put(counter, arriveValues);
                	arriveValues = new Map<String, String>();
            	}
            	counter +=1;
        	}
        	insertWeatherData(finalResults);
        }catch(exception e){
            System.debug('error ' + e.getMessage());
        }

    }
}
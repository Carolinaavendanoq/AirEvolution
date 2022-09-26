public class ClimaRest {
    
    public static  Decimal getWeather(String lat, String lon){
            Decimal finalResult;
        	HttpResponse response = HTTPController.getResult('https://api.openweathermap.org/data/2.5/weather?lat=' + lat + '&lon='+ lon + '&appid=bdc6fde0d6ff9cf46e3b8733d0e36471&lang=sp&units=metric');
            
        	if(response.getStatusCode() == 200){
            	Map<String, object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            	Map<String, object> weather = (Map<String, Object>)result.get('main');
            	finalResult = (Decimal) weather.get('temp');
                
        	}
        	return finalResult;

    }
    
}
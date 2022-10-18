public class ClimaRest {
    // Envía el endpoint al método que solicitará una respuesta de la api de climas, obteniendo la respuesta con las temperaturas correspondientes a cada ciudad del aeropuerto, sea de partida o de llegada, de acuerdo a la longitud y latitud que se le envía a la api de openweather
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
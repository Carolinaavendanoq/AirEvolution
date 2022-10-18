public class HTTPController {
    // Realiza la solicitud a un servicio externo con un método GET y recibe su respuesta
    public static HttpResponse getResult(String endpoint){
            Http httpGet = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = httpGet.send(request);
            return response;
    }
    
    
}
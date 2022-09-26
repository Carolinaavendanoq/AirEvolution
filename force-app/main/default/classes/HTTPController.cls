public class HTTPController {
    public static HttpResponse getResult(String endpoint){
            Http httpGet = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = httpGet.send(request);
            return response;
    }
    
    
}
public class HTTMockTest implements HttpCalloutMock{
    private String bodyVal;
    private String headerVal;
    
    public HTTMockTest(String bodyVal, String headerVal){
        this.bodyVal = bodyVal;
        this.headerVal = headerVal;
    }
    
    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', headerVal);
        res.setBody(bodyVal);
        res.setStatusCode(200);
        return res;
    }
}
@isTest
public class APIMimicTest {
    public static void createApiData(){
        String body = '{"coord":{"lon":-28.61,"lat":38.53},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"base":"stations","main":{"temp":30,"feels_like":297.03,"temp_min":296.38,"temp_max":296.38,"pressure":1015,"humidity":87,"sea_level":1015,"grnd_level":1015},"visibility":10000,"wind":{"speed":1.37,"deg":328,"gust":1.94},"clouds":{"all":83},"dt":1663020940,"sys":{"country":"PT","sunrise":1662968000,"sunset":1663013309},"timezone":0,"id":3372880,"name":"Matriz","cod":200}';
        HTTMockTest mock = new HTTMockTest(body, 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
    }
}
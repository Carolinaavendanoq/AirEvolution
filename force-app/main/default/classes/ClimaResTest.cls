@isTest
public class ClimaResTest {
    @isTest 
    static  void testGetCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('responseWeather');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Decimal result = ClimaRest.getWeather('38.53','-28.61');
        System.assertEquals(30, result);
	}
}
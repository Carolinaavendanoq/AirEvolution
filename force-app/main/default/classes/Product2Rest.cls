@RestResource(urlMapping = '/Product2/*')
global class Product2Rest {
    @HttpGet
    global static WrapperToRest getFlights(){
        List<Product2> flights;
        Boolean result;
        String message;
        try{
            String firstDate;
            String seconDate;
            String departureCity;
            String arriveCity;
            Date date1;
            Date date2;
            RestRequest restReq = RestContext.request;
            RestResponse restRes = RestContext.response;
            
            firstDate = (restReq.params.get('firstDate')).replace('-', '/');
            seconDate = (restReq.params.get('seconDate')).replace('-', '/');
            departureCity = restReq.params.get('departureCity');
            arriveCity = restReq.params.get('arriveCity');
            
            List<String> pickListValues = new List<String>();
            Schema.DescribeFieldResult cities = Aeropuerto__c.Ciudad__c.getDescribe();
            List<Schema.PicklistEntry> availableCities = cities.getPicklistValues();
            for(Schema.PicklistEntry picklistValue : availableCities){
                pickListValues.add(picklistValue.getValue());
            }
            
            if(!pickListValues.contains(departureCity)){
                message = 'Ciudad de partida no disponible';
                throw new MyException();
                
            }else if(!pickListValues.contains(arriveCity)){
                message = 'Ciudad de llegada no disponible';
                throw new MyException();
            }
            
            try{
                date1 = Date.parse(firstDate);
            }catch(exception e){
                message = 'El formato de la fecha inicial es incorrecta: ' + e.getMessage() + '. El formato debe ser: dia-mes-año';
            }
                
            try{
                date2 = Date.parse(seconDate);
            }catch(exception e){
                message = 'El formato de la fecha final es incorrecta: ' + e.getMessage() + '. El formato debe ser: dia-mes-año';
            }
            
            Datetime datetime1 = datetime.newInstance(date1.year(), date1.month(), date1.day());
            Datetime datetime2 = datetime.newInstance(date2.year(), date2.month(), date2.day());
            
            
           	flights = [SELECT Id, Name, Fecha_y_hora_de_partida__c, Aeropuerto_de_partida__r.Name, Aeropuerto_de_llegada__r.Name,
                       				  (SELECT Id, UnitPrice, pricebook2Id FROM PricebookEntries) 
                                      FROM Product2 WHERE Fecha_y_hora_de_partida__c >=: datetime1 
                                      AND Fecha_y_hora_de_partida__c <=: datetime2 
                                      AND Aeropuerto_de_partida__r.Ciudad__c =: departureCity 
                                      AND Aeropuerto_de_llegada__r.Ciudad__c =: arriveCity];        
            message = 'Operación exitosa';
            result = true;
            WrapperToRest succesfulRes = new WrapperToRest(flights,message, result);
            return succesfulRes;
            
        }catch(exception e){
            // throw new MyException('El formato de la fecha: ' + e.getMessage().mid(14, 16) + ' es incorrecta. El formato debe ser: dia-mes-año');
            result = false;
            WrapperToRest rejectedRes = new WrapperToRest(flights,message, result);
            return rejectedRes;
        }

    }
    
    public class MyException extends Exception{}


}
@isTest
public class ShowTicketsTest {
    @testSetup
    static void makeData(){
        Contact customer = new Contact(FirstName = 'Contact', LastName='Test', 
                                      Numero_de_identificacion__c = '252523',Tipo_de_Identificacion__c = '	Cédula de ciudadanía');
        insert customer;
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Clase negocio');
        insert newPricebook;
        Pricebook2 newPricebook2 = new Pricebook2(Name = 'Clase turista');
        insert newPricebook2;
        Pricebook2 newPricebook3 = new Pricebook2(Name = 'Carga');
        insert newPricebook3;
        String pricebookId = Test.getStandardPricebookId();
        
        Opportunity testbook= new Opportunity(Titular_de_reserva__c = customer.Id, Name = 'a', CloseDate = Date.today(), StageName = 'Pre-venta', Pricebook2Id = newPricebook.Id);
        insert testbook;
        
        Avion__c plane = new Avion__c(Numero_de_pasajeros_clase_negocios__c = 30, Numero_de_pasajeros_clase_turista__c = 46, Tipo__c  ='Airbus A330');
        insert plane;
        
        Aeropuerto__c airport = new Aeropuerto__c(Name = 'Airport1', Codigo_IATA__c = 'AI1');
        Aeropuerto__c airport2 = new Aeropuerto__c(Name = 'Airport2', Codigo_IATA__c = 'IA2');
        insert airport;
        insert airport2;
        
        Product2 flight = new Product2(Name = 'AE-2432', Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now()+ 4, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id, Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta');
        
        insert flight;
        PricebookEntry newPricEntry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = flight.Id, UnitPrice = 234233);
        insert newPricEntry2;
      	PricebookEntry newPricEntry = new PricebookEntry(Pricebook2Id = newPricebook.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry;
        PricebookEntry newPricEntry3= new PricebookEntry(Pricebook2Id =newPricebook2.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry3;
        PricebookEntry newPricEntry4=new PricebookEntry(Pricebook2Id =newPricebook3.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true);
      	insert newPricEntry4;
        
        OpportunityLineItem ticket = new OpportunityLineItem(Product2Id= flight.Id,OpportunityId =testbook.Id);
        insert ticket;
    }
    
    @isTest
    static void existingContact(){
        PageReference pageRef = Page.ShowTickets;
        Test.setCurrentPage(pageRef);
      
        ShowTickets controller = new ShowTickets();
        String nextPage;
      
        // Instantiate a new controller with all parameters in the page 
        controller.setidentiType('Cédula de ciudadanía');
        controller.setidentityNumber('252523');
        nextPage = controller.getpdfTickets().getUrl();

        // Verify that the success page displays
        System.assertEquals('/apex/existingtickets', nextPage);
    }
    
    @isTest
    static void empty(){
        PageReference pageRef = Page.ShowTickets;
        Test.setCurrentPage(pageRef);
        
        ShowTickets controller = new ShowTickets();
        PageReference nextPage;
        controller.setidentiType('Cédula de ciudadanía');
        controller.setidentityNumber('');
        nextPage = controller.getpdfTickets();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        for(ApexPages.Message msg : msgList){
            System.assertEquals('Por favor ingrese un número de identificación', msg.getSummary());
        	System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        }
    }
    
    @isTest
    static void noExistingContact(){
        PageReference pageRef = Page.ShowTickets;
        Test.setCurrentPage(pageRef);
        
        ShowTickets controller = new ShowTickets();
        PageReference nextPage;
        controller.setidentiType('Cédula de ciudadanía');
        controller.setidentityNumber('34634');
        nextPage = controller.getpdfTickets();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        for(ApexPages.Message msg : msgList){
            System.assertEquals('Cliente no existe, por favor registrelo', msg.getSummary());
        	System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        }
    }
    
    @isTest
    static void optionsType(){
        ShowTickets controller = new ShowTickets();
        List<SelectOption> options = controller.getselectedItem();
        system.assertEquals(options.get(0).getValue(), 'Cédula de ciudadanía');
    }
    
   	@isTest
    static void identiType(){
        ShowTickets controller = new ShowTickets();
        controller.setidentiType('Cédula de ciudadanía');
        controller.setidentityNumber('252523');
        String identiType = controller.getidentiType();
        String numberIdentity = controller.getidentityNumber();
        system.assertEquals('Cédula de ciudadanía', identiType);
        system.assertEquals('252523', numberIdentity);
    }
    
   	@isTest
    static void resultsToPdf(){
        ShowTickets controller = new ShowTickets();
        controller.setidentiType('Cédula de ciudadanía');
        controller.setidentityNumber('252523');
        pageReference listTickets = controller.getpdfTickets();
        List<OpportunityLineItem> tickets = controller.getResultsForPdf();
        
        system.assertEquals(1, tickets.size());
    }
    
    @isTest
    static void paidTickets(){
        Opportunity booking = [SELECT Id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.PaidTickets;
        pageRef.getParameters().put('recorId', booking.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(booking);
        ShowTickets controller = new ShowTickets(sc);
        List<Object> ticket = controller.getpaidTickets();
        
        System.assert(ticket != null);
    }
}
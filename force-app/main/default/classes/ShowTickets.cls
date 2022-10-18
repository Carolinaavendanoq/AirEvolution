public class ShowTickets {
    
    String identiType;
    String identityNumber;
    List<OpportunityLineItem> tickets = new List<OpportunityLineItem>();
    List<OpportunityLineItem> paidTickets;
    
    public ShowTickets(){
        
    }
    
    public ShowTickets(ApexPages.StandardController std){
        if(std.getRecord().Id != null){
            String bookingId = std.getRecord().Id;
            paidTickets = [SELECT Id, Name, Pasajero__r.Name, Product2.Name, Product2.Aeropuerto_de_llegada__r.Name, Opportunity.closeDate,
                           Product2.Aeropuerto_de_partida__r.Name, UnitPrice, Equipaje_permitido__c, Asiento__c, Product2.fecha_y_hora_de_partida__c, 
                           Product2.Fecha_y_hora_estimada_de_llegada__c FROM OpportunityLineItem WHERE OpportunityId =:bookingId AND Opportunity.StageName = 'Pagado'];
        }
    }
	
	public List<OpportunityLineItem> getpaidTickets(){
        return paidTickets;
    }
    
    public void setpaidTickets(List<OpportunityLineItem> paidTickets){
        this.paidTickets = paidTickets;
    }
    
    public String getidentiType(){
        return identiType;
    }
    
    public void setidentiType(String identiType){
        this.identiType = identiType;
    }
    
    public String getidentityNumber(){
        return identityNumber;
    }
    
    public void setidentityNumber(String identityNumber){
        this.identityNumber = identityNumber;
    }
    
    // Retorna la opción seleccionada por el usuario: el tipo de identificación
    public List<SelectOption> getselectedItem(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Cédula de ciudadanía', 'Cédula de ciudadanía'));
        options.add(new SelectOption('Cédula de extranjería', 'Cédula de extranjería'));
        options.add(new SelectOption('Tarjeta de identidad', 'Tarjeta de identidad'));
        return options;
    }
    
    // Obtiene la información de los tiquetes pertenecientes a un cliente consultado a través de la entrada de usuario del tipo y número de identificación. Mostrando errores si no se ingresa un valor o el cliente no existe. Retorna una referencia a la página que mostrará el pdf con toda la información de los tiquetes
    public PageReference getpdfTickets(){
        
        PageReference result;
        
        if(String.isBlank(this.identiType) || String.isBlank(this.identityNumber)){
            ApexPages.addMessage(new 
                ApexPages.Message(ApexPages.Severity.ERROR, 
               'Por favor ingrese un número de identificación'));
            return null;
        }
        
        
        Contact existingCustomer = obtainFlights.verifyContact(this.identiType, this.identityNumber);
        String customerId;
        if(existingCustomer != null){
            customerId = existingCustomer.Id;
            tickets = [SELECT Pasajero__r.Name, Asiento__c, Categoria__c, Equipaje_permitido__c, Opportunity.Name, 
                       Opportunity.stageName, Product2.Name, Product2.Aeropuerto_de_llegada__c, Product2.Aeropuerto_de_partida__c, 
                       Product2.Avion__c, Product2.Estado__c, Product2.Fecha_y_hora_de_partida__c, Puerta_de_embarque__c,
                       TotalPrice FROM OpportunityLineItem WHERE Pasajero__c =: customerId 
                       AND Product2.Estado__c = 'En venta'];
            result = Page.ExistingTickets;
        }else if(existingCustomer == null){
            ApexPages.addMessage(new 
                ApexPages.Message(ApexPages.Severity.ERROR, 
               'Cliente no existe, por favor registrelo'));
            result =  null;
        }
        
        return result;
        
    }

    // Retorna la lista de tiquetes obtenida de la entrada del usuario
   	public List<OpportunityLineItem> getResultsForPdf(){
        return tickets;
    }
    

}
global class WrapperToRest {
    public List<Product2> flights;
    public String message;
    public Boolean result;
    public Opportunity booking;
    public OpportunityLineItem ticket;
    
    public WrapperToRest(List<Product2> flights, String message, Boolean result){
        this.flights = flights;
        this.message = message;
        this.result = result;
   	}
        
    public WrapperToRest(Opportunity booking, OpportunityLineItem ticket, String message, Boolean result){
        this.booking = booking;
        this.ticket = ticket;
        this.message = message;
        this.result = result;
    }
}
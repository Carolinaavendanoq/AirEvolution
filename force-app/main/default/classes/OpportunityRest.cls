@RestResource(urlMapping = '/Opportunity/*')
global class OpportunityRest {

    // Expone un servicio rest que recibirá los datos personales del cliente, su elección de vuelo y categoría (lista de precios). Crea un cliente en caso de que no exista y le asigna o actualiza una reserva, para finalmente crearle un tiquete
    @HttpPost
    global static WrapperToRest createBooking(String identityNumber, String identiType, String nameFirst,String nameLast, String  passportNumber, String birthofDate, String anEmail, String nationality, String priceBookId, String flightId){
        Contact verifyCustomer = new Contact();
        String existingCustomer;
        Opportunity verifyBooking = new Opportunity();
        Opportunity updateBooking = new Opportunity();
        OpportunityLineItem finalTicket = new OpportunityLineItem();
        String message;
        Boolean result;
        try{
            verifyCustomer = obtainFlights.verifyContact(identiType, identityNumber);
            if(verifyCustomer != null){
                existingCustomer =  verifyCustomer.Id;
                verifyBooking = obtainFlights.verifyReservation(existingCustomer);
                if(verifyBooking != null){
                    message = 'Reserva y tiquete creados exitosamente';
                    result = true;
                }else if(verifyBooking == null){
                    Opportunity existingReservation = [SELECT Id FROM Opportunity WHERE Titular_de_reserva__c =: existingCustomer 
                                                       AND StageName IN ('Pre-venta', 'Completado') LIMIT 1];
                    verifyBooking = existingReservation;
                    message = 'Reserva actualizada y tiquete creado exitosamente';
                    result = true;
                }else{
                    System.debug('Entró al else de reserva');
                }
                
            }else if( VerifyCustomer == null){
                Date finalBirthDate = Date.parse(birthofDate);
				Contact newCustomer = new Contact(FirstName = nameFirst, LastName = nameLast, Tipo_de_Identificacion__c = identiType, 
                                                  Numero_de_identificacion__c = identityNumber, Numero_de_pasaporte__c = passportNumber, 
                                                  Birthdate = finalBirthDate, Email = anEmail, Nacionalidad__c = nationality);
				insert newCustomer;
                existingCustomer =  newCustomer.Id;
                Opportunity addBooking = obtainFlights.verifyReservation(existingCustomer);
                verifyBooking = addBooking;
                message = 'Reserva, contacto y tiquetes creados exitosamente';
                result = true;
            }else{
                System.debug('Entró al else de contacto');
            }
            
            updateBooking = obtainFlights.updateReservation(verifyBooking.Id, priceBookId);
            finalTicket = obtainFlights.createTicket(updateBooking.Id, flightId, existingCustomer);
            WrapperToRest succesfulRes = new WrapperToRest(updateBooking, finalTicket, message, result);
            return succesfulRes;
            
        }catch(Exception e){
            System.debug('Error ' + e.getMessage());
            message = 'Ocurrió un error ' + e.getMessage();
            result = false;
            WrapperToRest rejectedRes = new WrapperToRest(updateBooking, finalTicket, message, result);
            return rejectedRes;
        }
        
    }
    
    // Expone un servicio rest que recibirá la confirmación del pago de una reserva desde un sitio externo. Una vez recibido el id de la reserva se actualizará su estado y enviará un email confirmando el pago
    @httpPatch
    global static String paidReservation(string bookingId){
        String message;
        try{
            Opportunity booking = [SELECT Id, Titular_de_reserva__r.Email, Titular_de_reserva__r.Name, Name, StageName, Valor_total__c FROM Opportunity WHERE Id =: bookingId];
        	if(bookingId != null){
            	booking.StageName = 'Pagado';
            	update booking;
            	message = 'Reserva Pagada';
            	PaidBooking.sendEmail(booking);
        	}
            return message;   
        }catch(exception e){
            message = 'Ocurrió un error con el Id de la reserva';
            System.debug('Error ' + e.getMessage());
            return message;
        }     
    }
    
    
    public class MyException extends Exception{}
}
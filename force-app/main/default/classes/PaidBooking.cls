public class PaidBooking {
    // Envía un email al correo electrónico del titular de la reserva cuando ésta se ha verificado como pagada. El correo contiene un archivo adjunto de formato pdf con información de los tiquetes
     public static void sendEmail(Opportunity booking){    
        String[] emails = new list<String>();
        
        emails.add(booking.Titular_de_reserva__r.Email);
        
        PageReference pageRef = Page.PaidTickets;
        pageRef.getParameters().put('Id', booking.Id);
        Blob pdfEmail;
        if(Test.isRunningTest()) { 
  			pdfEmail = Blob.valueOf('Unit.Test');
		} else {
  			pdfEmail = pageRef.getContentAsPDF();
		}
        Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attachedFile = new Messaging.EmailFileAttachment();
        attachedFile.setFileName('informacion.pdf');
        attachedFile.setBody(pdfEmail);

        String addresses;
        newEmail.setSubject( 'CONFIRMACIÓN PAGO DE RESERVA');
        
        newEmail.setToAddresses(emails);
       
        newEmail.setPlainTextBody('Saludos ' + booking.Titular_de_reserva__r.Name + ', \n Air-Evolution espera que se encuentre muy bien. Nos complace agradecerle por elegirnos, a continuación confirmamos detalles del pago de la reserva ' + booking.Name + '. Adjunto encontrará el archivo con los detalles de su reserva, tiquete(s) y vuelo(s). ' );
        
        newEmail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachedFile});
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {newEmail});

    }
}
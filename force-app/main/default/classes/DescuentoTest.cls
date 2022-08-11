@isTest
public class DescuentoTest {
    @TestSetup
    static void makeData(){
        // se crea un cliente recurrente con tipo de id y número de id, porque la búsqueda es realizada por estos dos campos
        Contact clienteRecurrente = new Contact(LastName = 'Perez', Tipo_de_identificacion__c = 'Cédula de ciudadanía',
        Numero_de_identificacion__c = '125252526');

        insert clienteRecurrente;
    }

    @isTest
    static void dctoClienteRecurrenteTC(){
        Contact cliente = [SELECT Id, Tipo_de_identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);

        System.assert(respuesta.resultado);
        System.assertEquals(80, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
    }

    @isTest
    static void dctoClienteRecurrenteEfectivo(){
        Contact cliente = [SELECT Id, Tipo_de_identificacion__c, Numero_de_identificacion__c FROM Contact LIMIT 1];

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);

        System.assert(respuesta.resultado);
        System.assertEquals(70, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.EFECTIVO)));
    }

    @isTest
    static void dctoClienteNuevoTC(){
        Contact cliente = new Contact(FirstName = 'Nubia', LastName = 'Iglesias' , Tipo_de_Identificacion__c = 'Cédula de ciudadanía', Numero_de_identificacion__c = '8923524');

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);

        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
    }

    @isTest
    static void dctoClienteNuevoEfectivo(){
        Contact cliente = new Contact(FirstName = 'Harold', LastName = 'Urrego' , Tipo_de_Identificacion__c = 'Cédula de ciudadanía', Numero_de_identificacion__c = '8238757');

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);

        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.EFECTIVO)));
    }
    
    @isTest 
    static void dmlTest(){
        Contact cliente = new Contact(FirstName = 'Harold', LastName = null , Tipo_de_Identificacion__c = 'Cédula de ciudadanía', Numero_de_identificacion__c = '3464262');
        try {
            Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);
            System.assert(respuesta.resultado);
            System.assertEquals(85, respuesta.valorConDcto);
            System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.EFECTIVO)));
        } catch (DmlException dmle ) {
            System.debug(dmle.getMessage());
        }
    }

    @isTest
    static void descuentoTest(){
        Contact cliente  = [SELECT Id,Tipo_de_Identificacion__c,  
        Numero_de_identificacion__c 
        FROM Contact LIMIT 1];
        try{
            Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, null, 100);
            System.assert(respuesta.resultado);
            System.assertEquals(85, respuesta.valorConDcto);
            System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
        }catch(Exception e){
                System.debug(e.getMessage());
        }
    }

    @isTest
    static void sinEfectivoTest(){
        Contact cliente  = [SELECT Id,Tipo_de_Identificacion__c,  Numero_de_identificacion__c FROM Contact LIMIT 1];
        try{
            Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, null);
            System.assert(respuesta.resultado);
            System.assertEquals(85, respuesta.valorConDcto);
            System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
        }catch(Exception e){
                System.debug(e.getMessage());
        }
    }


}
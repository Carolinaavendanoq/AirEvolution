public with sharing class Descuento {
    public enum metodo {TC, EFECTIVO}
    public static respuestaDcto aplicarDescuento(contact cliente, metodo metodoPago, decimal valor){
        respuestaDcto respuesta = new respuestaDcto();
        try{
            contact[] recurrente = [SELECT id 
                                FROM contact 
                                WHERE Tipo_de_Identificacion__c =: cliente.Tipo_de_Identificacion__c 
                                AND Numero_de_identificacion__c =: cliente.Numero_de_identificacion__c
                                LIMIT 1];
        if(recurrente.size() > 0){
            switch on metodoPago {
                when TC {
                    respuesta.valorConDcto = valor * 0.8;
                    respuesta.resultado = true;
                    respuesta.mensaje = 'Se aplicó el descuento de cliente recurrente con '+metodoPago+' de 20%';
                    System.debug('RESULTADO' + respuesta.mensaje);
                }
                when EFECTIVO {
                    respuesta.valorConDcto = valor * 0.7;
                    respuesta.resultado = true;
                    respuesta.mensaje = 'Se aplicó el descuento de cliente recurrente con '+metodoPago+' de 30%';
                    System.debug('RESULTADO' + respuesta.mensaje);
                }
                when else {
                    throw new descuentoException();
                }
            }
        } else {
            respuesta.valorConDcto = valor * 0.85;
            respuesta.resultado = true;
            respuesta.mensaje = 'Se aplicó el descuento de cliente nuevo con '+metodoPago+' de 15%';
            System.debug('RESULTADO' + respuesta.mensaje);
    
            insert cliente;
        }
        }catch(QueryException qe){
            System.debug('Ocurrio un error en la consulta: '+qe.getMessage());
            throw new descuentoException('Ocurrio un error en la consulta',qe);
        }catch(DMLException dmle){
            System.debug('Ocurrio un error en la inserrción: '+dmle.getMessage());
            throw new descuentoException('Ocurrio un error en la inserrción',dmle);
        }catch(descuentoException de){
            System.debug('El método de pago no corresponde');
            throw new descuentoException('El método de pago no corresponde');
        }catch (Exception e){
            System.debug('Ocurrio un error no esperado: '+e.getMessage());
            throw new descuentoException('Ocurrio un error no esperado',e);
        }
        
        return respuesta;
    }
    
    public class respuestaDcto{
        public boolean resultado;
        public string mensaje;
        public decimal valorConDcto;
    }
    
    public class descuentoException extends Exception {}
    }
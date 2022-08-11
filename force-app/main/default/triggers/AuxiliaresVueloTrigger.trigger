trigger AuxiliaresVueloTrigger on Auxiliares_de_vuelo__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    TriggerHandler handler = new AuxiliaresVueloTriggerHandler(Trigger.isExecuting, Trigger.size);

    switch on trigger.operationType {
        when BEFORE_INSERT {
            System.debug('Está antes de insertar');
            handler.beforeInsert(trigger.new);
        }
        when BEFORE_UPDATE{
            System.debug('Está antes de actualizar');
        }
        when BEFORE_DELETE {
            System.debug('Está antes de eliminar');
        }
        when AFTER_INSERT{
            System.debug('Está después de insertar');
            
        }
        when AFTER_UPDATE{
            System.debug('Está después de actualizar');
        }
        when AFTER_DELETE{
            System.debug('Está después de eliminar');
        }
        when AFTER_UNDELETE{
            System.debug('Está después de recuperar');
        }
        when else {
            System.debug('Ningún evento');
        }
    }
}
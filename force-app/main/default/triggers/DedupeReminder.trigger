trigger DedupeReminder on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    TriggerHandler handler = new DedupeReminderTriggerHandler(Trigger.isExecuting, Trigger.size);

    switch on trigger.operationType {
        when BEFORE_INSERT {
            System.debug('Está antes de insertar');
        }
        when BEFORE_UPDATE{
            System.debug('Está antes de actualizar');
            
        }
        when BEFORE_DELETE {
            System.debug('Está antes de eliminar');
        }
        when AFTER_INSERT{
            System.debug('Está después de insertar');
            handler.afterInsert(trigger.new, trigger.newMap);
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
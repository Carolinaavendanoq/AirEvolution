trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    TriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);

    switch on trigger.operationType {
        when BEFORE_INSERT {
            System.debug('Está antes de insertar');
            handler.beforeInsert(trigger.new);
        }
        when BEFORE_UPDATE{
            System.debug('Está antes de actualizar');
            handler.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
        }
        when BEFORE_DELETE {
            System.debug('Está antes de eliminar');
            handler.beforeDelete(trigger.old, trigger.oldMap);
        }
        when AFTER_INSERT{
            System.debug('Está después de insertar');
            handler.afterInsert(trigger.new, trigger.newMap);
        }
        when AFTER_UPDATE{
            System.debug('Está después de actualizar');
            handler.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
        }
        when AFTER_DELETE{
            System.debug('Está después de eliminar');
            handler.afterDelete(trigger.old, trigger.oldMap);
        }
        when AFTER_UNDELETE{
            System.debug('Está después de recuperar');
        }
        when else {
            System.debug('Ningún evento');
        }
    }


}
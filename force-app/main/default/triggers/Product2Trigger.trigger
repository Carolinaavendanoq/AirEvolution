trigger Product2Trigger on Product2 (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    TriggerHandler handler = new Product2TriggerHandler(Trigger.isExecuting, Trigger.size);

    switch on trigger.operationType {
        when BEFORE_INSERT {
            System.debug('It is before inserting');
            handler.beforeInsert(trigger.new);
        }
        when BEFORE_UPDATE{
            System.debug('It is before updating');
            handler.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
        }
        when BEFORE_DELETE {
            System.debug('It is before deleting');
        }
        when AFTER_INSERT{
            System.debug('It is after inserting');
        }
        when AFTER_UPDATE{
            System.debug('It is after updating');
        }
        when AFTER_DELETE{
            System.debug('It is after deleting');
        }
        when AFTER_UNDELETE{
            System.debug('It is after undeleting');
        }
        when else {
            System.debug('No event');
        }
    }
}
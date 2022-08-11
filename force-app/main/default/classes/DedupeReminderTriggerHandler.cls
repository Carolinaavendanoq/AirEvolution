public with sharing class DedupeReminderTriggerHandler implements TriggerHandler{

    private boolean triggerIsExecuting;
    private integer triggerSize;

    public DedupeReminderTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Account> newAccounts){
        // code
    }

    public void beforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap){
        // code
    }

    public void beforeDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap){

    }

    public void afterInsert(List<Account> newAccounts, Map<ID, SObject> newAccountMap){
        addCaseToAccount(newAccounts);
    }

    public void afterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap){
        
    }

    public void afterDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap){
        
    }

    public void afterUndelete(List<Account> newAccounts, Map<ID, SObject> newAccountMap){

    }

    public static void addCaseToAccount(List<Account> accountNeW ){
        List<Case> cases = new List<Case>();
        
        for (Account account : accountNeW) {
            Case c = new Case();
            c.Subject = 'Dedupe this Account';
            c.OwnerId = account.OwnerId;
            c.AccountId = account.Id;
            cases.add(c);
        }
        insert cases;
    }
}
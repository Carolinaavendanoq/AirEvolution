@isTest
public with sharing class DedupeReminderTest {

    @isTest
    static void createDedupeReminder() {
        Account account = new Account(Name='New Account');
        insert account;

        Case caseCreated = [SELECT Subject FROM Case Limit 1];
        System.assertEquals('Dedupe this Account', caseCreated.Subject);
    }

    static void masiveDedupeReminder(){
        List <Account> accounts = new List<Account>();
        for(Integer i = 0; i < 55; i++){
            accounts.add(new Account(Name = 'New Dedupe ' + i));
        }
        insert accounts;

        List<Case> cases = new List<Case>();
        cases = [SELECT Id FROM Case];
        System.assertEquals(55, cases.size());
    }
}
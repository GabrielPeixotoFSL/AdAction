/*
    Created by: Greg Hacic
    Last Update: 7 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests contactTrigger.trigger (100.00% coverage)
        - tests contactTriggerHandler.cls (86.36% coverage)
*/
@isTest
private class contactTriggerHandlerTest {
    
    //tests contactTrigger.trigger & contactTriggerHandler.cls
    @isTest //defines method for use during testing only
    static void triggerLogic() {
        //insert a account
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Tess Financial Corp'));
        insert accounts;
        
        Test.startTest(); //denote testing context
        
        //insert some Contacts
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(AccountId = accounts[0].Id, FirstName = 'Tess', LastName = 'Dachshund'));
        insert contacts;
        //update
        List<Contact> updateContacts = new List<Contact>();
        updateContacts.add(new Contact(Id = contacts[0].Id, Title = 'CEO'));
        update updateContacts;
        //delete
        delete updateContacts;
        //undelete
        undelete updateContacts;
        
        Test.stopTest(); //revert from testing context
    }

}
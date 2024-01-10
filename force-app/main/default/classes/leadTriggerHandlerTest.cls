/*
    Created by: Greg Hacic
    Last Update: 7 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests contactTriggerHandler.cls (77.27% coverage)
        - tests leadTrigger.trigger (100.00% coverage)
        - tests leadTriggerHandler.cls (100.00% coverage)
        - tests queueHandleLeadContacts.cls (100.00% coverage)
        - tests queueMoveLeadContactActivities.cls (100.00% coverage)
*/
@isTest
private class leadTriggerHandlerTest {
    
    //tests leadTrigger.trigger & leadTriggerHandler.cls
    @isTest //defines method for use during testing only
    static void triggerLogic() {
        //grab the default converted Lead Status from the system
        //LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        //testing a solution for the error Error: System.DmlException: ConvertLead failed
        LeadStatus convertStatus = [ SELECT Id, ApiName FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1 ];
        
        Test.startTest(); //denote testing context
        
        //insert a Lead
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(App_Name__c = 'ABC123', City = 'Buffalo', Company = 'Tess Trucking Corporation', Country = 'United States', Email = 'demo1@ities.co', Fax = '(716) 555-1221', FirstName = 'Tess', LastName = 'Dachshund', MobilePhone = '(716) 555-0001', Phone = '(716) 555-3990', PostalCode = '14203', State = 'New York', Status = 'Open', Street = '640 Ellicott Street', Title = 'Owner',
                            Category__c = 'Books',
                            Inventory_Type__c = 'Stacks'));
        leads.add(new Lead(App_Name__c = 'ABC123', City = 'Buffalo', Company = 'Tess Financial LLC', Country = 'United States', Email = 'demo2@ities.co', Fax = '(716) 555-3221', FirstName = 'Bubs', LastName = 'Dachshund', MobilePhone = '(716) 555-0002', Phone = '(716) 555-3991', PostalCode = '14203', State = 'New York', Status = 'Open', Street = '640 Ellicott Street', Title = 'Owner', 
                            Category__c = 'Books',
                            Inventory_Type__c = 'Stacks'));
        insert leads;
        List<Lead> secondaryLeadList = new List<Lead>();
        secondaryLeadList.add(leads[1]);
        //insert Lead_Contact__c
        List<Lead_Contact__c> leadContacts = new List<Lead_Contact__c>();
        leadContacts.add(new Lead_Contact__c(Email__c = 'test_01@gmail.com', First_Name__c = 'Grachus', Last_Name__c = 'Dachshund', Phone__c = '(303) 555-0987', Related_Lead__c = leads[0].Id, Title__c = 'Boss'));
        leadContacts.add(new Lead_Contact__c(Email__c = 'test_02@gmail.com', First_Name__c = 'Diamler', Last_Name__c = 'Dachshund', Phone__c = '(303) 555-0988', Related_Lead__c = leads[0].Id, Title__c = 'Not Boss'));
        insert leadContacts;
        //create some Events
        List<Event> events = new List<Event>();
        events.add(new Event(ActivityDate = Date.Today(), ActivityDateTime = Datetime.Now(), DurationInMinutes = 30, Subject = 'Completed', WhatId = leadContacts[0].Id));
        events.add(new Event(ActivityDate = Date.Today(), ActivityDateTime = Datetime.Now(), DurationInMinutes = 60, Subject = 'Completed', WhatId = leadContacts[1].Id));
        insert events;
        //create some Tasks
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(ActivityDate = Date.Today(), Description = 'Fake call', Status = 'Completed', Subject = 'Test Task', WhatId = leadContacts[0].Id));
        tasks.add(new Task(ActivityDate = Date.Today(), Description = 'Fake call', Status = 'Completed', Subject = 'Test Task', WhatId = leadContacts[1].Id));
        insert tasks;
        //update a Lead
        List<Lead> updatedLeads = new List<Lead>();
        updatedLeads.add(new Lead(Id = leads[0].Id, Title = 'Lead Dog'));
        update updatedLeads;
        //convert the Lead
        Database.LeadConvert leadToConvert = new Database.LeadConvert(); //construct the LeadConvert object
        leadToConvert.setLeadId(leads[0].Id); //set the Id of the Lead to convert
        leadToConvert.setConvertedStatus('Converted'); //set the Status
        leadToConvert.setOpportunityName('Tess Trucking - Opportunity'); // set the opportunity name
        Database.LeadConvertResult resultOfConversion = Database.convertLead(leadToConvert); //convert the lead
        //grab the Ids of the created records
        Id createdAccountId = resultOfConversion.getAccountId(); //grab the Id of the created Account
        Id createdContactId = resultOfConversion.getContactId(); //grab the Id of the created Contact
        Id createdOpportunityId = resultOfConversion.getOpportunityId(); //grab the Id of the created Opportunity
        //delete
        delete secondaryLeadList;
        //undelete
        undelete secondaryLeadList;
        
        Test.stopTest(); //revert from testing context
        
        //validate that there are more Contacts than the one created from the conversion
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :createdAccountId]; //query for all Contacts linked to the converted Account
        System.assertEquals(3, contacts.size());
        Set<Id> contactIds = new Set<Id>();
        contactIds.add(contacts[0].Id);
        contactIds.add(contacts[1].Id);
        contactIds.add(contacts[2].Id);
        //validate that the activities moved to the Contacts from the Lead_Contact__c records
        List<Event> queriedEvents = [SELECT Id FROM Event WHERE WhoId IN :contactIds]; //query for all Events linked to testing Contacts
        System.assertEquals(2, queriedEvents.size());
        List<Task> queriedTasks = [SELECT Id FROM Task WHERE WhoId IN :contactIds]; //query for all Tasks linked to testing Contacts
        System.assertEquals(2, queriedTasks.size());
    }

}
/*
    Created by: Greg Hacic
    Last Update: 26 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - queueable interface enables the asynchronous execution of Apex jobs that can be monitored
        - properly handles creation of Contact records from Lead_Contact__c records when a Lead is converted
        - tests located at leadTriggerHandlerTest.cls
*/
public class queueHandleLeadContacts implements Queueable {
    
    public Map<Id, Id> leadToContactIds; //map of Lead.Id -> Contact.Id
    
    //constructor
    public queueHandleLeadContacts(Map<Id, Id> passedMap) {
        leadToContactIds = passedMap; //grab the passed map and assign it to our public map variable
    }
    
    //executes the queueable logic
    public void execute(QueueableContext qc) {
        Map<Id, Contact> convertedContacts = new Map<Id, Contact>([SELECT AccountId, Id, OwnerId FROM Contact WHERE Id IN :leadToContactIds.values()]); //query for Contacts in order to create the map: Contact.Id -> Contact
        List<Contact> contactsToCreate = new List<Contact>(); //new Contacts to be created from Lead_Contact__c records
        for (Lead_Contact__c lc : [SELECT Email__c, First_Name__c, Last_Name__c, Name, Phone__c, Related_Lead__c, Related_Lead__r.ConvertedContactId, Title__c, Type_of_Contact__c, Update_Lead_Status__c FROM Lead_Contact__c WHERE Related_Lead__c IN :leadToContactIds.keySet()]) { //query for Lead_Contact__c records linked to the converted Leads
            Contact c = new Contact(); //construct a new Contact object
            if (convertedContacts.containsKey(lc.Related_Lead__r.ConvertedContactId)) { //if the map contains a key for the Related_Lead__r.ConvertedContactId
                c.AccountId = convertedContacts.get(lc.Related_Lead__r.ConvertedContactId).AccountId; //grab the AccountId from the originally converted Lead
                c.OwnerId = convertedContacts.get(lc.Related_Lead__r.ConvertedContactId).OwnerId; //grab the OwnerId from the originally converted Lead
                //c.RecordTypeId = convertedContacts.get(lc.Related_Lead__r.ConvertedContactId).RecordTypeId; //grab the RecordTypeId from the originally converted Lead
            }
            c.Email = lc.Email__c;
            c.FirstName = lc.First_Name__c;
            c.LastName = lc.Last_Name__c;
            c.LeadContactId__c = lc.Id;
            c.Phone = lc.Phone__c;
            c.Title = lc.Title__c;
            c.Type_of_Contact__c = lc.Type_of_Contact__c;
            contactsToCreate.add(c); //add the Contact to our list
        }
        if (!contactsToCreate.isEmpty()) { //if the list is not empty
            List<Database.SaveResult> results = Database.insert(contactsToCreate, false); //insert the Contacts and allow for partial failures
        }
    }

}
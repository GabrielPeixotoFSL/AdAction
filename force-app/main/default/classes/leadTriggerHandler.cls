/*
    Created by: Greg Hacic
    Last Update: 2 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - this class inherits from triggerHandler.class
        - tests located at leadTriggerHandlerTest.class
*/
public class leadTriggerHandler extends triggerHandler {
    
    private Map<Id, Lead> newRecordMap; //map of new records
    private Map<Id, Lead> oldRecordMap; //map of old records
    private List<Lead> newRecords; //list of new records
    private List<Lead> oldRecords; //list of old records
    
    //constructor
    public leadTriggerHandler() {
        newRecordMap = (Map<Id, Lead>)Trigger.newMap; //cast the map of new records
        newRecords = (List<Lead>)Trigger.new;  //cast the list of new records
        oldRecordMap = (Map<Id, Lead>)Trigger.oldMap; //cast the map of old records
        oldRecords = (List<Lead>)Trigger.old; //cast the list of old records
    }
    
    //overrides TriggerHandler.beforeInsert method > Trigger.isBefore && Trigger.isInsert
    public override void beforeInsert() {
        //not yet implemented...
    }
    
    //overrides TriggerHandler.afterInsert method > Trigger.isAfter && Trigger.isInsert
    public override void afterInsert() {
        handleLeadContacts(); //determine if Lead_Contact__c records should be converted to Contacts
    }
    
    //overrides TriggerHandler.beforeUpdate method > Trigger.isBefore && Trigger.isUpdate
    public override void beforeUpdate() {
        //not yet implemented...
    }
    
    //overrides TriggerHandler.afterUpdate method > Trigger.isAfter && Trigger.isUpdate
    public override void afterUpdate() {
        handleLeadContacts(); //determine if Lead_Contact__c records should be converted to Contacts
    }
    
    //overrides TriggerHandler.beforeDelete method > Trigger.isBefore && Trigger.isDelete
    public override void beforeDelete() {
        //not yet implemented...
    }
    
    //overrides TriggerHandler.afterDelete method > Trigger.isAfter && Trigger.isDelete
    public override void afterDelete() {
        //not yet implemented...
    }
    
    //overrides TriggerHandler.afterUndelete method > Trigger.isAfter && Trigger.isUndelete
    public override void afterUndelete() {
        //not yet implemented...
    }
    
    //determines if a Lead was converted then creates Contacts from the Lead_Contact__c relationship (if necessary)
    public void handleLeadContacts() {
        Map<Id, Id> leadToContactIds = new Map<Id, Id>(); //Lead.Id -> Contact.Id
        //determine if the lead was converted
        for (Lead l : newRecords) { //for each new version of Lead record
            if ((Trigger.isInsert || (Trigger.isUpdate && l.IsConverted != oldRecordMap.get(l.Id).IsConverted)) && l.IsConverted == true) { //if the lead has been converted
                if (String.isNotBlank(l.ConvertedContactId)) { //if ConvertedContactId is not whitespace, not empty (''), and not null
                    leadToContactIds.put(l.Id, l.ConvertedContactId); //populate the map
                }
            }
        }
        if (!leadToContactIds.isEmpty()) { //if the map is not empty
            System.enqueueJob(new queueHandleLeadContacts(leadToContactIds)); //queue up the queueHandleLeadContacts process by passing the map
        }
    }

}
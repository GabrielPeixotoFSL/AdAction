/*
    Created by: Greg Hacic
    Last Update: 7 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - this class inherits from triggerHandler.class
        - tests located at contactTriggerHandlerTest.class
*/
public class contactTriggerHandler extends triggerHandler {
    
    private Map<Id, Contact> newRecordMap; //map of new records
    private Map<Id, Contact> oldRecordMap; //map of old records
    private List<Contact> newRecords; //list of new records
    private List<Contact> oldRecords; //list of old records
    
    //constructor
    public contactTriggerHandler() {
        newRecordMap = (Map<Id, Contact>)Trigger.newMap; //cast the map of new records
        newRecords = (List<Contact>)Trigger.new;  //cast the list of new records
        oldRecordMap = (Map<Id, Contact>)Trigger.oldMap; //cast the map of old records
        oldRecords = (List<Contact>)Trigger.old; //cast the list of old records
    }
    
    //overrides TriggerHandler.beforeInsert method > Trigger.isBefore && Trigger.isInsert
    public override void beforeInsert() {
        //not yet implemented...
    }
    
    //overrides TriggerHandler.afterInsert method > Trigger.isAfter && Trigger.isInsert
    public override void afterInsert() {
        handleLeadContactActivities(); //handle movement of Tasks/Events linked to Lead_Contact__c records
    }
    
    //overrides TriggerHandler.beforeUpdate method > Trigger.isBefore && Trigger.isUpdate
    public override void beforeUpdate() {
        //not yet implemented...
    }
    
    //overrides TriggerHandler.afterUpdate method > Trigger.isAfter && Trigger.isUpdate
    public override void afterUpdate() {
        //not yet implemented...
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
    
    //if Contact was created and has an Id populated in the LeadContactId__c value then move any relevant Activities (Tasks/Events)
    public void handleLeadContactActivities() {
        
        Map<Id, Id> leadContactIds = new Map<Id, Id>(); //map of Lead_Contact__c.Id -> Contact.Id
        String prefixLeadContactObject = Lead_Contact__c.sObjectType.getDescribe().getKeyPrefix(); //prefix for Lead_Contact__c records
        
        for (Contact c : newRecords) { //for each new version of Contact record
            if (String.isNotBlank(c.LeadContactId__c)) { //if LeadContactId__c is not whitespace, not empty (''), and not null
                if (c.LeadContactId__c.startsWith(prefixLeadContactObject) && c.LeadContactId__c.length() == 18) { //if the LeadContactId__c starts with the Lead_Contact__c object prefix and the string is 18 characters in length
                    leadContactIds.put(c.LeadContactId__c, c.Id); //populate the map
                }
            }
        }
        
        if (!leadContactIds.isEmpty()) { //if the map is not empty
            System.enqueueJob(new queueMoveLeadContactActivities(leadContactIds)); //queue up the queueMoveLeadContactActivities process by passing the map
        }
    }

}
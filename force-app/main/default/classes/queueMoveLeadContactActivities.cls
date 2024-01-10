/*
    Created by: Greg Hacic
    Last Update: 7 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - queueable interface enables the asynchronous execution of Apex jobs that can be monitored
        - reassociates Tasks/Events to Contacts that were created from Lead_Contact__c records linked to converted Leads
        - tests located at contactTriggerHandlerTest.cls
*/
public class queueMoveLeadContactActivities implements Queueable {
    
    public Map<Id, Id> leadContactIds; //map of Lead_Contact__c.Id -> Contact.Id
    
    //constructor
    public queueMoveLeadContactActivities(Map<Id, Id> passedMap) {
        leadContactIds = passedMap; //grab the passed map and assign it to our public map variable
    }
    
    //executes the queueable logic
    public void execute(QueueableContext qc) {
        List<Event> eventsToUpdate = new List<Event>(); //existing Events to be updated
        List<Task> tasksToUpdate = new List<Task>(); //existing Tasks to be updated
        for (Event e : [SELECT Id, WhatId FROM Event WHERE WhatId IN :leadContactIds.keySet()]) { //for all Events linked to a Lead_Contact__c record passed to the interface
            eventsToUpdate.add(new Event(Id = e.Id, WhatId = null, WhoId = leadContactIds.get(e.WhatId))); //construct a new Event object linked to the Contact instead of the Lead_Contact__c
        }
        for (Task t : [SELECT Id, WhatId FROM Task WHERE WhatId IN :leadContactIds.keySet()]) { //for all Tasks linked to a Lead_Contact__c record passed to the interface
            tasksToUpdate.add(new Task(Id = t.Id, WhatId = null, WhoId = leadContactIds.get(t.WhatId))); //construct a new Task object linked to the Contact instead of the Lead_Contact__c
        }
        if (!eventsToUpdate.isEmpty()) { //if the list is not empty
            List<Database.SaveResult> results = Database.update(eventsToUpdate, false); //update the Events and allow for partial failures
        }
        if (!tasksToUpdate.isEmpty()) { //if the list is not empty
            List<Database.SaveResult> results = Database.update(tasksToUpdate, false); //update the Tasks and allow for partial failures
        }
    }

}
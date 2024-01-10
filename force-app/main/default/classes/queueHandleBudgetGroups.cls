/*
    Created by: Greg Hacic
    Last Update: 20 December 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - queueable interface enables the asynchronous execution of Apex jobs that can be monitored
        - tests located at campaignBudgetTest.cls
*/
public class queueHandleBudgetGroups implements Queueable {
    
    public Set<Id> opportunityIds; //set of Opportunity.Id
    public Map<String, Set<Id>> campaignChanges; //map of String -> Set of Id
    
    //constructor
    public queueHandleBudgetGroups(Set<Id> passedSet, Map<String, Set<Id>> passedMap) {
        opportunityIds = passedSet; //grab the passed set and assign it to our public set variable
        campaignChanges = passedMap; //grab the passed map and assign it to out public map variable
    }
    
    //executes the queueable logic
    public void execute(QueueableContext qc) {
        campaignUtil.handleBudgetGroups(opportunityIds, campaignChanges); //pass the variables to the handleBudgetGroups method
    }

}
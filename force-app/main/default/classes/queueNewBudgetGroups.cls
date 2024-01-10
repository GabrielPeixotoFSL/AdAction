/*
    Created by: Greg Hacic
    Last Update: 20 December 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - queueable interface enables the asynchronous execution of Apex jobs that can be monitored
        - tests located at campaignUtilTest.cls
*/
public class queueNewBudgetGroups implements Queueable {
    
    public Set<Id> campaignIds; //set of Campaign.Id
    
    //constructor
    public queueNewBudgetGroups(Set<Id> passedSet) {
        campaignIds = passedSet; //grab the passed set and assign it to our public set variable
    }
    
    //executes the queueable logic
    public void execute(QueueableContext qc) {
        campaignUtil.newBudgetGroups(campaignIds); //pass the variables to the newBudgetGroups method
    }

}
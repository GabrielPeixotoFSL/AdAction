/*
    Created by: Greg Hacic
    Last Update: 22 March 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - allows for management of Campaign budgets from the Opportunity detail page
        - controller for campaignBudget.page
        - tests located at campaignBudgetTest.cls
*/
public class campaignBudget {
    
    private final Opportunity o; //Opportunity sobject
    public List<Campaign> campaigns {get; set;} //list of Campaign records linked to the Opportunity
    
    //constructor
    public campaignBudget(ApexPages.StandardController sc) {
        o = (Opportunity)sc.getRecord(); //cast the Opportunity from the standard controller object
        runLogic(); //execute the logic for grabbing the right records and calculating values for display on the page
    }
    
    //executes the logic
    public void runLogic() {
        //reset the variables
        campaigns = new List<Campaign>(); //construct an empty list
        Opportunity opp = [SELECT Budget_Amount__c, Id FROM Opportunity WHERE Id = :o.Id]; //grab some details from the Opportunity
        
        for (Campaign c : [SELECT Budget_Amount__c, Budget_Group__c, Daily__c, Daily_Installs__c, HO_Offer_ID__c, Id, Monthly__c, Monthly_Installs__c, Name, StartDate, Total_Conversions__c, Weekly__c, Weekly_Installs__c FROM Campaign WHERE Related_Opportunity__c = :o.Id ORDER BY Budget_Group__c ASC]) { //for each Campaign linked to this Opportunity
            campaigns.add(c); //add it to the list
        }
    }
    
    //number of records in the campaigns list
    public Integer getCampaignsSize() {
        return campaigns.size();
    }
    
    //save the data for all the campaigns
    public void saveBudget() {
        update campaigns; //save the records
        runLogic(); //re-run the overall logic for the page
    }

}
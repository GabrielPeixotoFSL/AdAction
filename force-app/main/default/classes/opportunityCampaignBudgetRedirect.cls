/*
    Created by: Greg Hacic
    Last Update: 8 March 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - controller for the opportunityCampaignBudgetRedirect.page
            - allows for navigational redirection from a Opportunity detail page to the campaignBudget Visualforce page
        - tests located at campaignBudgetTest.cls
*/
public class opportunityCampaignBudgetRedirect {
    
    private final Opportunity o; //Opportunity object
    
    //constructor
    public opportunityCampaignBudgetRedirect(ApexPages.StandardController sc) {
        o = (Opportunity)sc.getRecord(); //cast the Campaign object from the standard controller
    }
    
    //method invoked from the Visualforce pages action attribute
    public PageReference redirectToPage() {
        PageReference returnPage = Page.campaignBudget; //
        returnPage.getParameters().put('retURL','/'+o.Id); //set the retURL parameter in order to allow for returning to Opportunity if User cancels from page
        returnPage.getParameters().put('id',o.Id); //set the Id of the Opportunity record
        returnPage.getParameters().put('nooverride','1'); //set the nooverride parameter in order to prevent looping in the user interface
        returnPage.setRedirect(true); //indicate that the redirect should be performed on the client side
        return returnPage; //send the User on their way
    }

}
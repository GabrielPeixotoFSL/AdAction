/*
    Created by: Greg Hacic
    Last Update: 8 March 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - controller for the campaignBudgetRedirect.page
            - allows for navigational redirection from a Campaign detail page to the campaignBudget Visualforce page
        - tests located at campaignBudgetTest.cls
*/
public class campaignBudgetRedirect {
    
    private final Campaign c; //Campaign object
    
    //constructor
    public campaignBudgetRedirect(ApexPages.StandardController sc) {
        c = (Campaign)sc.getRecord(); //cast the Campaign object from the standard controller
    }
    
    //method invoked from the Visualforce pages action attribute
    public PageReference redirectToPage() {
        Campaign recordDetails = [SELECT Related_Opportunity__c FROM Campaign WHERE Id = :c.Id]; //query for the record details
        PageReference returnPage = Page.campaignBudget; //
        returnPage.getParameters().put('retURL','/'+c.Id); //set the retURL parameter in order to allow for returning to Campaign if User cancels from page
        returnPage.getParameters().put('id',recordDetails.Related_Opportunity__c); //set the Id of the Opportunity record
        returnPage.getParameters().put('nooverride','1'); //set the nooverride parameter in order to prevent looping in the user interface
        returnPage.setRedirect(true); //indicate that the redirect should be performed on the client side
        return returnPage; //send the User on their way
    }

}
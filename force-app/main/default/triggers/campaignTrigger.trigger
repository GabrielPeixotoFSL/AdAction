/*
    Created by: Greg Hacic
    Last Update: 15 March 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests at campaignTriggerHandlerTest.cls (100.00% coverage)
*/
trigger campaignTrigger on Campaign(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    new campaignTriggerHandler().run(); //construct an instance of campaignTriggerHandler.class and call the run() method

}
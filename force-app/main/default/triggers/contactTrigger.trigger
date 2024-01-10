/*
    Created by: Greg Hacic
    Last Update: 7 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests at contactTriggerHandlerTest.class (100.00% coverage)
*/
trigger contactTrigger on Contact(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    new contactTriggerHandler().run(); //construct an instance of contactTriggerHandler.class and call the run() method

}
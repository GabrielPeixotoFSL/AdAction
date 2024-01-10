/*
    Created by: Greg Hacic
    Last Update: 2 November 2018 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests at leadTriggerHandlerTest.class (100.00% coverage)
*/
trigger leadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    new leadTriggerHandler().run(); //construct an instance of leadTriggerHandler.class and call the run() method

}
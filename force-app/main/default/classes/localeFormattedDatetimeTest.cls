/*
    Created by: Greg Hacic
    Last Update: 24 April 2018 by Greg Hacic
    Questions?: greg@ities.co
    Copyright (c) 2007 - 2018 Interactive Ties LLC
    
    Notes:
        - tests the localeFormattedDatetime class (100.00% coverage)
*/
@isTest
private class localeFormattedDatetimeTest {
    
    //English (United States)
    @isTest //defines method for use during testing only
    static void en_US() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'noreply@ities.co', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'noreply@ities.co', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDatetime controller = new localeFormattedDatetime(); //construct the controller
            controller.datetimeValue = DateTime.valueOf('2007-01-01 2:35:21'); //set the datetime variable to 1 January 2007
            String testValue = controller.getFormattedDatetime(); //run the logic and format the datetime value
            System.assertEquals('1/1/2007 2:35 AM', testValue); //validate the results
            Test.stopTest(); //revert from testing context
        }
    }
    
    //Spanish (Paraguay)
    @isTest //defines method for use during testing only
    static void es_PY() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'noreply@ities.co', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='es_PY', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'noreply@ities.co', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDatetime controller = new localeFormattedDatetime(); //construct the controller
            controller.datetimeValue = DateTime.valueOf('2005-03-07 5:02:21'); //set the datetime variable to 7 March 2005
            System.assertEquals('07/03/2005 05:02 AM', controller.getFormattedDatetime()); //validate the results
            Test.stopTest(); //revert from testing context
        }
    }
    
    //French (Canada)
    @isTest //defines method for use during testing only
    static void fr_CA() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'noreply@ities.co', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='fr_CA', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'noreply@ities.co', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDatetime controller = new localeFormattedDatetime(); //construct the controller
            controller.datetimeValue = DateTime.newInstance(2011, 1, 3, 12, 41, 15); //set the datetime variable to 3 January 2011
            System.assertEquals('2011-01-03 12:41', controller.getFormattedDatetime()); //validate the results
            Test.stopTest(); //revert from testing context
        }
    }
    
    //Chinese (Taiwan)
    @isTest //defines method for use during testing only
    static void zh_TW() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'noreply@ities.co', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='zh_TW', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'noreply@ities.co', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDatetime controller = new localeFormattedDatetime(); //construct the controller
            controller.datetimeValue = DateTime.newInstance(2011, 1, 3, 12, 41, 15); //set the datetime variable to 3 January 2011
            System.assertEquals('2011/1/3 PM 12:41', controller.getFormattedDatetime()); //validate the results
            Test.stopTest(); //revert from testing context
        }
    }

}
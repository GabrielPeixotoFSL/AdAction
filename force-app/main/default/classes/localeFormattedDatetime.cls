/*
    Created by: Greg Hacic
    Last Update: 24 April 2018 by Greg Hacic
    Questions?: greg@ities.co
    Copyright (c) 2007 - 2018 Interactive Ties LLC
    
    Notes:
        - controller for the localeFormattedDatetime Visualforce component
        - tests located at localeFormattedDatetimeTest.class
*/
public class localeFormattedDatetime {
    
    public Datetime datetimeValue {get;set;} //property that reads the datetime value from the component attribute tag
    
    public String getFormattedDatetime() {
        String datetimeFormatted; //variable for the datetime
        if( datetimeValue != null ) { //if the datetimeValue variable is not null
            datetimeFormatted = datetimeValue.format(); //the datetimeValue as a string using the locale of the User
        }
        return datetimeFormatted; //return the string
    }

}
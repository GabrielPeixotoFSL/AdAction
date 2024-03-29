/*
    Created by: Greg Hacic
    Last Update: 24 April 2018 by Greg Hacic
    Questions?: greg@ities.co
    Copyright (c) 2007 - 2018 Interactive Ties LLC
    
    Notes:
        - controller for the localeFormattedDate Visualforce component
        - tests located at localeFormattedDateTest.class
*/
public class localeFormattedDate {
    
    public Date dateValue {get;set;} //property that reads the date value from the component attribute tag
    
    public String getFormattedDate() {
        String dateFormatted; //variable for the date
        if( dateValue != null ) { //if the dateValue variable is not null
            dateFormatted = dateValue.format(); //the dateValue as a string using the locale of the User
        }
        return dateFormatted; //return the string
    }

}
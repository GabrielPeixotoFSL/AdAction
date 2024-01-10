/*
    Created by: Greg Hacic
    Last Update: 14 November 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests campaignBudget.cls (100.00% coverage)
        - tests campaignBudgetRedirect.cls (100.00% coverage)
*/
@isTest
private class campaignBudgetTest {
    
    //campaignBudget.cls
    @isTest //defines method for use during testing only
    static void allLogic() {
        //grab a System Admin profile
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name LIKE 'System Administrator' LIMIT 1];
        //create a user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'testa', Email = 'test_1@adactioninteractive.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test1', LanguageLocaleKey = 'en_US', LastName = 'Test', LocaleSidKey='en_US', Phone = '(303) 555-3001', ProfileId = adminProfile.Id, TimeZoneSidKey = 'America/Denver', UserName = 'test_1@adaction.com'));
        users.add(new User(Alias = 'testb', Email = 'test_2@adactioninteractive.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test2', LanguageLocaleKey = 'en_US', LastName = 'Test', LocaleSidKey='en_US', Phone = '(303) 555-3001', ProfileId = adminProfile.Id, TimeZoneSidKey = 'America/Denver', UserName = 'test_2@adaction.com'));
        insert users;
        
        //insert an Account
        List<Account> accounts = new List<Account>();
        //including the Media_Account_Owner_incent__c &  Media_Account_Owner_nonincent__c fields as they are necessary for a process builder flow
        accounts.add(new Account(Name = 'Tess Corporation', Media_Account_Owner_incent__c = users[0].Id, Media_Account_Owner_nonincent__c = users[1].Id));
        insert accounts;
        
        //insert an Opportunity
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(AccountId = accounts[0].Id, CloseDate = Date.Today(), Name = 'Tess Corp - Great App - Android', Probability = 100.0, StageName = 'Closed Won'));
        insert opportunities;
        
        //insert Campaigns
        List<Campaign> campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21400', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi001', Name = 'Cadremploi (Android, Free, ES, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21401', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi002', Name = 'Cadremploi (Android, Free, FR, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21402', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi003', Name = 'Cadremploi (Android, Free, IT, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21403', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi004', Name = 'Cadremploi (Android, Free, RU, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21404', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi005', Name = 'Cadremploi (Android, Free, US, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21405', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi006', Name = 'Cadremploi (Android, Free, UK, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21406', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi007', Name = 'Cadremploi (Android, Free, BZ, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21407', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi008', Name = 'Cadremploi (Android, Free, AT, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21408', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi009', Name = 'Cadremploi (Android, Free, CA, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21409', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi010', Name = 'Cadremploi (Android, Free, CZ, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21410', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi011', Name = 'Cadremploi (Android, Free, HT, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21411', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi012', Name = 'Cadremploi (Android, Free, LU, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21412', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi013', Name = 'Cadremploi (Android, Free, PK, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21413', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi014', Name = 'Cadremploi (Android, Free, TH, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21414', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi015', Name = 'Cadremploi (Android, Free, UZ, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21415', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi016', Name = 'Cadremploi (Android, Free, YE, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        insert campaigns;
        
        Test.startTest(); //denote testing context
        
        //campaignBudgetRedirect logic validation
        PageReference redirectPageRef = Page.campaignBudgetRedirect; //create a page reference to campaignBudgetRedirect.page
        Test.setCurrentPage(redirectPageRef); //set the page context
        ApexPages.StandardController standardController = new ApexPages.standardController(campaigns[0]); //construct the standard controller for the Campaign object
        campaignBudgetRedirect red = new campaignBudgetRedirect(standardController); //instantiate the extension
        String urlString = red.redirectToPage().getURL(); //get the resulting URL string from the redirectToPage method
        System.assertEquals(true, urlString.toLowerCase().contains('nooverride=1'));
        System.assertEquals(true, urlString.toLowerCase().contains('id=006'));
        
        //opportunityCampaignBudgetRedirect logic validation
        redirectPageRef = Page.opportunityCampaignBudgetRedirect; //create a page reference to opportunityCampaignBudgetRedirect.page
        Test.setCurrentPage(redirectPageRef); //set the page context
        standardController = new ApexPages.standardController(opportunities[0]); //construct the standard controller for the Opportunity object
        opportunityCampaignBudgetRedirect opredi = new opportunityCampaignBudgetRedirect(standardController); //instantiate the extension
        urlString = opredi.redirectToPage().getURL(); //get the resulting URL string from the redirectToPage method
        System.assertEquals(true, urlString.toLowerCase().contains('nooverride=1'));
        System.assertEquals(true, urlString.toLowerCase().contains('id=006'));
        
        //campaignBudget logic validation
        PageReference pageRef = Page.campaignBudget; //create a page reference to campaignBudget.page
        Test.setCurrentPage(pageRef); //set the page context
        ApexPages.StandardController sc = new ApexPages.standardController(opportunities[0]); //construct the standard controller for the Opportunity object
        campaignBudget ext = new campaignBudget(sc); //construct the extension
        
        //System.assertEquals(16, ext.getCampaignsSize()); //should be 16 campaigns
        ext.saveBudget();
        
        Test.stopTest(); //revert from testing context
    }

}
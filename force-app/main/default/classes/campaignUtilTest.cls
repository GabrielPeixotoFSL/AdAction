/*
    Created by: Greg Hacic
    Last Update: 3 January 2020 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests campaignUtil.cls (87.01% coverage)
*/
@isTest
private class campaignUtilTest {
    
    //campaignUtil.cls
    @isTest //defines method for use during testing only
    static void variousChanges() {
        //grab a System Admin profile
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name LIKE 'System Administrator' LIMIT 1];
        //create a user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'testa', Email = 'test_1@adactioninteractive.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test1', LanguageLocaleKey = 'en_US', LastName = 'Test', LocaleSidKey='en_US', Phone = '(303) 555-3001', ProfileId = adminProfile.Id, TimeZoneSidKey = 'America/Denver', UserName = 'test_1@adaction.com'));
        users.add(new User(Alias = 'testb', Email = 'test_2@adactioninteractive.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test2', LanguageLocaleKey = 'en_US', LastName = 'Tester', LocaleSidKey='en_US', Phone = '(303) 555-3002', ProfileId = adminProfile.Id, TimeZoneSidKey = 'America/Denver', UserName = 'test_2@adaction.com'));
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
        //Daily__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21400', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi001', Name = 'Cadremploi (iPhone, Free, ES, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21401', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi002', Name = 'Cadremploi (iPhone, Free, FR, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21402', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi003', Name = 'Cadremploi (iPhone, Free, IT, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //Daily_Installs__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21403', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi004', Name = 'Cadremploi (iPhone, Free, RU, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21404', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi005', Name = 'Cadremploi (iPhone, Free, US, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21405', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi006', Name = 'Cadremploi (iPhone, Free, UK, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //Monthly__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly__c = 400, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21406', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi007', Name = 'Cadremploi (iPhone, Free, BZ, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly__c = 400, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21407', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi008', Name = 'Cadremploi (iPhone, Free, AT, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //Monthly_Installs__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 4.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly_Installs__c = 1000, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21408', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi009', Name = 'Cadremploi (Android, Free, CA, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 4.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly_Installs__c = 1000, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21409', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi010', Name = 'Cadremploi (Android, Free, CZ, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //Weekly__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 5.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly__c = 50, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21410', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi011', Name = 'Cadremploi (Android, Free, HT, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 5.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly__c = 50, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21411', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi012', Name = 'Cadremploi (Android, Free, LU, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 5.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly__c = 50, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21412', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi013', Name = 'Cadremploi (Android, Free, PK, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //Weekly_Installs__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 6.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 200, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21413', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi014', Name = 'Cadremploi (Android, Free, TH, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 6.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 200, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21414', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi015', Name = 'Cadremploi (Android, Free, UZ, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 6.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 200, Device_Targeting__c = 'Android Phone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21415', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi016', Name = 'Cadremploi (Android, Free, YE, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //Monthly__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 7.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly__c = 643, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '22212', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'SumpinDifferent01', Name = 'SumpinNew (iPhone, Free, BZ, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 7.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly__c = 643, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '22213', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'SumpinDifferent02', Name = 'SumpinNew (iPhone, Free, AT, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        //no budget group
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 155.0, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '22214', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'SumpinDifferent03', Name = 'SumpinNew (iPhone, Free, ZH, 46MB)', Operating_System__c = 'iOS', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        insert campaigns;
        
        //populateChangesMap
        Map<String, Set<Id>> testMap = new Map<String, Set<Id>>();
        testMap = campaignUtil.populateChangesMap(testMap, 'something', campaigns[0].Id);
        System.assertEquals(false, testMap.isEmpty());
        testMap = campaignUtil.populateChangesMap(testMap, 'something', campaigns[1].Id);
        testMap = campaignUtil.populateChangesMap(testMap, 'somethingelse', campaigns[2].Id);
        System.assertEquals(2, testMap.size());
        System.assertEquals(2, testMap.get('something').size());
        System.assertEquals(1, testMap.get('somethingelse').size());
        
        //extractChangedIds(Map<String, Set<Id>> passedMap, String passedKey)
        Set<Id> testSet = new Set<Id>();
        testSet = campaignUtil.extractChangedIds(testMap, 'something');
        System.assertEquals(2, testSet.size());
        System.assertEquals(true, testSet.contains(campaigns[0].Id));
        System.assertEquals(true, testSet.contains(campaigns[1].Id));
        testSet = campaignUtil.extractChangedIds(testMap, 'somethingelse');
        System.assertEquals(1, testSet.size());
        System.assertEquals(true, testSet.contains(campaigns[2].Id));
        testSet = campaignUtil.extractChangedIds(testMap, 'another');
        System.assertEquals(0, testSet.size());
        
        Test.startTest(); //denote testing context
        
        //changes to Campaigns done within trigger
        List<Campaign> campaignUpdates = new List<Campaign>();
        campaignUpdates.add(new Campaign(Daily__c = 200.0, Id = campaigns[1].Id));
        campaignUpdates.add(new Campaign(Daily_Installs__c = 200.0, Id = campaigns[4].Id));
        campaignUpdates.add(new Campaign(Id = campaigns[7].Id, Monthly__c = 300.0));
        campaignUpdates.add(new Campaign(Id = campaigns[9].Id, Monthly_Installs__c = 900.0));
        campaignUpdates.add(new Campaign(Id = campaigns[11].Id, Weekly__c = 100.0));
        campaignUpdates.add(new Campaign(Id = campaigns[14].Id, Weekly_Installs__c = 300.0));
        campaignUpdates.add(new Campaign(Budget_Group__c = 7.0, Id = campaigns[18].Id));
        update campaignUpdates;
        
        Test.stopTest(); //revert from testing context
        
        //validation of underlying logic
        for (Campaign c : [SELECT Daily__c, Daily_Installs__c FROM Campaign WHERE Budget_Group__c = 1.0]) {
            System.assertEquals(200.0, c.Daily__c);
            System.assertEquals(200.0 / 0.50, c.Daily_Installs__c);
        }
        for (Campaign c : [SELECT Daily__c, Daily_Installs__c FROM Campaign WHERE Budget_Group__c = 2.0]) {
            System.assertEquals(200.0 * 0.50, c.Daily__c);
            System.assertEquals(200.0, c.Daily_Installs__c);
        }
        List<Campaign> soqlResults = [SELECT Id FROM Campaign WHERE Monthly__c = 300.0 AND Budget_Group__c = 3.0];
        System.assertEquals(2, soqlResults.size());
        soqlResults.clear(); //clear the list
        soqlResults = [SELECT Id FROM Campaign WHERE Monthly_Installs__c = 900.0 AND Budget_Group__c = 4.0];
        System.assertEquals(2, soqlResults.size());
        soqlResults.clear(); //clear the list
        soqlResults = [SELECT Id FROM Campaign WHERE Weekly__c = 100.0 AND Budget_Group__c = 5.0];
        System.assertEquals(3, soqlResults.size());
        soqlResults.clear(); //clear the list
        soqlResults = [SELECT Id FROM Campaign WHERE Weekly_Installs__c = 300.0 AND Budget_Group__c = 6.0];
        System.assertEquals(3, soqlResults.size());
        soqlResults.clear(); //clear the list
        soqlResults = [SELECT Id FROM Campaign WHERE Weekly_Installs__c = 155.0 AND Budget_Group__c = 7.0];
        System.assertEquals(3, soqlResults.size());
        for (Campaign c : [SELECT Weekly__c FROM Campaign WHERE Budget_Group__c = 7.0]) {
            System.assertEquals(null, c.Weekly__c);
        }
        for (Campaign c : [SELECT Weekly__c, Monthly_Installs__c FROM Campaign WHERE Budget_Group__c = 2.0]) {
            System.assertEquals(null, c.Weekly__c);
            System.assertEquals(null, c.Monthly_Installs__c);
        }
    }

}
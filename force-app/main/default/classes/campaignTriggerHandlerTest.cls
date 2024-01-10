/*
    Created by: Greg Hacic
    Last Update: 14 November 2019 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - tests campaignTrigger.trigger (100.00% coverage)
        - tests campaignTriggerHandler.cls (69.84% coverage)
        - tests campaignUtil.cls (69.84% coverage)
        - tests queueHandleBudgetGroups.cls (100.00% coverage)
*/
@isTest
private class campaignTriggerHandlerTest {
    
    //tests campaignTrigger.trigger, & campaignTriggerHandler.cls & campaignUtil
    @isTest //defines method for use during testing only
    static void triggerLogic() {
        //grab a System Admin profile
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name LIKE 'System Administrator' LIMIT 1];
        //create a user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'testc', Email = 'test_3@adactioninteractive.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test3', LanguageLocaleKey = 'en_US', LastName = 'Test', LocaleSidKey='en_US', Phone = '(303) 555-3001', ProfileId = adminProfile.Id, TimeZoneSidKey = 'America/Denver', UserName = 'test_3@adaction.com'));
        users.add(new User(Alias = 'testd', Email = 'test_4@adactioninteractive.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test4', LanguageLocaleKey = 'en_US', LastName = 'Test', LocaleSidKey='en_US', Phone = '(303) 555-3001', ProfileId = adminProfile.Id, TimeZoneSidKey = 'America/Denver', UserName = 'test_4@adaction.com'));
        insert users;
        //insert an Account
        List<Account> accounts = new List<Account>();
        //including the Media_Account_Owner_incent__c &  Media_Account_Owner_nonincent__c fields as they are necessary for a process builder flow
        accounts.add(new Account(Name = 'Tess Corporation', Media_Account_Owner_incent__c = users[0].Id, Media_Account_Owner_nonincent__c = users[1].Id));
        accounts.add(new Account(Name = 'Tess LLC', Media_Account_Owner_incent__c = users[0].Id, Media_Account_Owner_nonincent__c = users[1].Id));
        insert accounts;
        //insert an Opportunity
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(AccountId = accounts[0].Id, CloseDate = Date.Today(), Name = 'Tess Corp - Great App - Android', Probability = 100.0, StageName = 'Closed Won'));
        opportunities.add(new Opportunity(AccountId = accounts[1].Id, CloseDate = Date.Today(), Name = 'Tess LLC - Mediocre App - iOS', Probability = 100.0, StageName = 'Closed Won'));
        insert opportunities;
        
        Test.startTest(); //denote testing context
        
        //insert Campaigns
        List<Campaign> campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21400', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi001', Name = 'Cadremploi (Android, Free, ES, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.25, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21401', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi002', Name = 'Cadremploi (Android, Free, FR, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/002'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21402', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi003', Name = 'Cadremploi (Android, Free, IT, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.75, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/003'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21403', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi004', Name = 'Cadremploi (Android, Free, RU, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.80, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/004'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21404', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi005', Name = 'Cadremploi (Android, Free, US, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.55, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/005'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21405', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi006', Name = 'Cadremploi (Android, Free, UK, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.52, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/006'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21406', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi007', Name = 'Cadremploi (Android, Free, BZ, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.60, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/007'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21407', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi008', Name = 'Cadremploi (Android, Free, AT, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.35, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/008'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21408', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi009', Name = 'Cadremploi (Android, Free, CA, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/009'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21409', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi010', Name = 'Cadremploi (Android, Free, CZ, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/010'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21410', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi011', Name = 'Cadremploi (Android, Free, HT, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/011'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21411', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi012', Name = 'Cadremploi (Android, Free, LU, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/012'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21412', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi013', Name = 'Cadremploi (Android, Free, PK, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/013'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21413', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi014', Name = 'Cadremploi (Android, Free, TH, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/014'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21414', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi015', Name = 'Cadremploi (Android, Free, UZ, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/015'));
        campaigns.add(new Campaign(Account_Name__c = accounts[1].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21415', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi016', Name = 'Cadremploi (Android, Free, YE, 46MB)', Operating_System__c = 'Android', Related_Opportunity__c = opportunities[1].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/016'));
        insert campaigns;
        
        //validate that the calculations worked
        for (Campaign c : [SELECT Daily__c, Daily_Installs__c, Id FROM Campaign]) {
            if (c.Id.equals(campaigns[0].Id)) { //Daily__c = 100, Price_per_Conversion__c = 0.25
                System.assertEquals(400.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[1].Id)) { //Daily__c = 100, Price_per_Conversion__c = 0.50
                System.assertEquals(200.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[2].Id)) { //Daily__c = 100, Price_per_Conversion__c = 0.75
                System.assert(c.Daily_Installs__c > 133.3 && c.Daily_Installs__c < 133.4);
            } else if (c.Id.equals(campaigns[3].Id)) { //Daily__c = 100, Price_per_Conversion__c = 0.80
                System.assertEquals(125.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[4].Id)) { //Daily_Installs__c = 100, Price_per_Conversion__c = 0.55
                System.assertEquals(55.0, c.Daily__c);
            } else if (c.Id.equals(campaigns[5].Id)) { //Daily_Installs__c = 100, Price_per_Conversion__c = 0.52
                System.assertEquals(52.0, c.Daily__c);
            } else if (c.Id.equals(campaigns[6].Id)) { //Daily_Installs__c = 100, Price_per_Conversion__c = 0.60
                System.assertEquals(60.0, c.Daily__c);
            } else if (c.Id.equals(campaigns[7].Id)) { //Daily_Installs__c = 100, Price_per_Conversion__c = 0.35
                System.assertEquals(35.0, c.Daily__c);
            } else if (c.Id.equals(campaigns[8].Id)) { //Daily__c = 100
                System.assertEquals(null, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[9].Id)) { //Daily__c = 100
                System.assertEquals(null, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[10].Id)) { //Daily__c = 100
                System.assertEquals(null, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[11].Id)) { //Daily_Installs__c = 100
                System.assertEquals(null, c.Daily__c);
            } else if (c.Id.equals(campaigns[12].Id)) { //Daily__c = 100
                System.assertEquals(null, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[13].Id)) { //Daily_Installs__c = 100
                System.assertEquals(null, c.Daily__c);
            } else if (c.Id.equals(campaigns[14].Id)) { //Daily_Installs__c = 100
                System.assertEquals(null, c.Daily__c);
            }
        }
        
        //update some Campaigns
        List<Campaign> updateCampaigns = new List<Campaign>();
        updateCampaigns.add(new Campaign(Id = campaigns[2].Id, Budget_Group__c = 4.0));
        updateCampaigns.add(new Campaign(Id = campaigns[3].Id, Budget_Group__c = 5.0));
        updateCampaigns.add(new Campaign(Id = campaigns[4].Id, Budget_Group__c = 6.0));
        updateCampaigns.add(new Campaign(Id = campaigns[7].Id, Budget_Group__c = 6.0));
        updateCampaigns.add(new Campaign(Id = campaigns[8].Id, Budget_Group__c = 1.0));
        updateCampaigns.add(new Campaign(Id = campaigns[9].Id, Budget_Group__c = 2.0));
        updateCampaigns.add(new Campaign(Id = campaigns[10].Id, Budget_Group__c = 2.0));
        updateCampaigns.add(new Campaign(Id = campaigns[11].Id, Budget_Group__c = 3.0));
        updateCampaigns.add(new Campaign(Id = campaigns[12].Id, Budget_Group__c = 3.0));
        update updateCampaigns;
        
        //delete
        delete updateCampaigns;
        //validate

        //undelete
        undelete updateCampaigns;
        
        Test.stopTest(); //revert from testing context
        //create a set for holding all of the Campaign Ids that we think should be true now (based upon the trigger logic we have in place)
        Set<Id> sharedIds = new Set<Id>();
        sharedIds.add(campaigns[4].Id);
        sharedIds.add(campaigns[5].Id);
        sharedIds.add(campaigns[6].Id);
        sharedIds.add(campaigns[7].Id);
        sharedIds.add(campaigns[9].Id);
        sharedIds.add(campaigns[10].Id);
        sharedIds.add(campaigns[11].Id);
        sharedIds.add(campaigns[12].Id);
        //validate the trigger logic
        for (Campaign c : [SELECT Id, Name, Shared_Budget__c FROM Campaign WHERE Related_Opportunity__c = :opportunities[0].Id OR Related_Opportunity__c = :opportunities[1].Id]) {
            if (sharedIds.contains(c.Id)) {
                System.assertEquals(true, c.Shared_Budget__c);
            } else {
                System.assertEquals(false, c.Shared_Budget__c);
            }
        }
    }
    
    //campaignUtil.cls
    @isTest //defines method for use during testing only
    static void moreLogic() {
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
        accounts.add(new Account(Name = 'Tess Corporation', Media_Account_Owner_incent__c = users[0].Id, Media_Account_Owner_nonincent__c = users[1].Id, Internal_Account_Manager_Demand__c = users[1].Id));
        insert accounts;
        
        //insert an Opportunity
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(AccountId = accounts[0].Id, CloseDate = Date.Today(), Name = 'Tess Corp - Great App - Android', Probability = 100.0, StageName = 'Closed Won'));
        //insert opportunities;
        
        //insert Campaigns
        List<Campaign> campaigns = new List<Campaign>();
        //Daily__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21400', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi001', Name = 'Cadremploi (iPhone, Free, ES, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.25, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21401', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi002', Name = 'Cadremploi (iPhone, Free, FR, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 1.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21402', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi003', Name = 'Cadremploi (iPhone, Free, IT, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.75, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        //Daily_Installs__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21403', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi004', Name = 'Cadremploi (iPhone, Free, RU, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.80, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21404', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi005', Name = 'Cadremploi (iPhone, Free, US, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.55, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 2.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Daily_Installs__c = 100, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21405', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi006', Name = 'Cadremploi (iPhone, Free, UK, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.52, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        //Monthly__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly__c = 400, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21406', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi007', Name = 'Cadremploi (iPhone, Free, BZ, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.60, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 3.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly__c = 400, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21407', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi008', Name = 'Cadremploi (iPhone, Free, AT, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.35, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        //Monthly_Installs__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 4.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly_Installs__c = 1000, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21408', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi009', Name = 'Cadremploi (Android, Free, CA, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 1.50, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 4.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Monthly_Installs__c = 1000, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21409', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi010', Name = 'Cadremploi (Android, Free, CZ, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 1.10, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        //Weekly__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 5.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly__c = 50, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21410', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi011', Name = 'Cadremploi (Android, Free, HT, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.91, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 5.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly__c = 50, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21411', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi012', Name = 'Cadremploi (Android, Free, LU, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.90, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 5.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly__c = 50, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21412', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi013', Name = 'Cadremploi (Android, Free, PK, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.22, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        //Weekly_Installs__c
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 6.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 200, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21413', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi014', Name = 'Cadremploi (Android, Free, TH, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 0.78, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 6.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 200, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21414', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi015', Name = 'Cadremploi (Android, Free, UZ, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 1.00, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, Attribution_Tracking_Platform__c = 'Other', Billing_Type__c = 'CPA', Budget_Group__c = 6.0, Campaign_Media_Buy_Type__c = 'Affiliate Network', Campaign_Traffic_Type__c = 'Keyword', Connection_Type_Requirements__c = 'All types', Weekly_Installs__c = 200, Device_Targeting__c = 'iPhone', EndDate = Date.Today().addDays(21), HO_Offer_ID__c = '21415', HO_Offer_Name__c = 'Cadremploi', Incent_Non_Incent__c = 'Non-Incent', IsActive = true, MMP_Campaign_Name__c = 'Cadremploi016', Name = 'Cadremploi (Android, Free, YE, 46MB)', Operating_System__c = 'Android', Price_per_Conversion__c = 1.20, Related_Opportunity__c = opportunities[0].Id, StartDate = Date.Today().addDays(7), Tracking_URL__c = 'https://adaction.mobi/track/a/001', MMP_Advertiser_ID__c='1234'));
        insert campaigns;
        
        Test.startTest(); //denote testing context
        
        List<Campaign> campaignUpdates = new List<Campaign>();
        campaignUpdates.add(new Campaign(Id = campaigns[0].Id, Daily__c = 20.0));
        campaignUpdates.add(new Campaign(Id = campaigns[3].Id, Daily_Installs__c = 80.0));
        campaignUpdates.add(new Campaign(Id = campaigns[4].Id, Daily_Installs__c = 80.0));
        campaignUpdates.add(new Campaign(Id = campaigns[5].Id, Daily_Installs__c = 80.0));
        campaignUpdates.add(new Campaign(Id = campaigns[6].Id, Monthly__c = 650.0));
        campaignUpdates.add(new Campaign(Id = campaigns[7].Id, Monthly__c = 650.0));
        campaignUpdates.add(new Campaign(Id = campaigns[8].Id, Monthly_Installs__c = 1200.0));
        campaignUpdates.add(new Campaign(Id = campaigns[9].Id, Monthly_Installs__c = 1200.0));
        campaignUpdates.add(new Campaign(Id = campaigns[10].Id, Weekly__c = 90.0));
        campaignUpdates.add(new Campaign(Id = campaigns[11].Id, Weekly__c = 90.0));
        campaignUpdates.add(new Campaign(Id = campaigns[12].Id, Weekly__c = 90.0));
        campaignUpdates.add(new Campaign(Id = campaigns[13].Id, Weekly_Installs__c = 175.0));
        campaignUpdates.add(new Campaign(Id = campaigns[14].Id, Weekly_Installs__c = 175.0));
        campaignUpdates.add(new Campaign(Id = campaigns[15].Id, Weekly_Installs__c = 175.0));
        update campaignUpdates;
        
        Test.stopTest(); //revert from testing context
        
        //validate that the logic worked
        for (Campaign c : [SELECT Budget_Group__c, Daily__c, Daily_Installs__c, Id, Monthly__c, Monthly_Installs__c, Weekly__c, Weekly_Installs__c FROM Campaign]) {
            if (c.Id.equals(campaigns[0].Id)) { //Daily__c = 20, Price_per_Conversion__c = 0.25
                System.assertEquals(80.0, c.Daily_Installs__c);
                System.assertEquals(1.0, c.Budget_Group__c);
                System.assertEquals(20.0, c.Daily__c);
            } else if (c.Id.equals(campaigns[1].Id)) { //Daily__c = 100, Price_per_Conversion__c = 0.50
                System.assertEquals(1.0, c.Budget_Group__c);
                System.assertEquals(100.0, c.Daily__c);
                System.assertEquals(200.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[2].Id)) { //Daily__c = 100, Price_per_Conversion__c = 0.75
                System.assertEquals(1.0, c.Budget_Group__c);
                System.assert(c.Daily_Installs__c > 133.3 && c.Daily_Installs__c < 133.4);
                System.assertEquals(100.0, c.Daily__c);
            } else if (c.Id.equals(campaigns[3].Id)) { //Daily_Installs__c = 80, Price_per_Conversion__c = 0.80
                System.assertEquals(64.0, c.Daily__c);
                System.assertEquals(80.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[4].Id)) { //Daily_Installs__c = 80, Price_per_Conversion__c = 0.55
                System.assertEquals(44.0, c.Daily__c);
                System.assertEquals(80.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[5].Id)) { //Daily_Installs__c = 80, Price_per_Conversion__c = 0.52
                System.assertEquals(41.6, c.Daily__c);
                System.assertEquals(80.0, c.Daily_Installs__c);
            } else if (c.Id.equals(campaigns[6].Id)) {
                System.assertEquals(650.0, c.Monthly__c);
            } else if (c.Id.equals(campaigns[7].Id)) {
                System.assertEquals(650.0, c.Monthly__c);
            } else if (c.Id.equals(campaigns[8].Id)) {
                System.assertEquals(1200.0, c.Monthly_Installs__c);
            } else if (c.Id.equals(campaigns[9].Id)) {
                System.assertEquals(1200.0, c.Monthly_Installs__c);
            } else if (c.Id.equals(campaigns[10].Id)) {
                System.assertEquals(90.0, c.Weekly__c);
            } else if (c.Id.equals(campaigns[11].Id)) {
                System.assertEquals(90.0, c.Weekly__c);
            } else if (c.Id.equals(campaigns[12].Id)) {
                System.assertEquals(90.0, c.Weekly__c);
            } else if (c.Id.equals(campaigns[13].Id)) {
                System.assertEquals(6.0, c.Budget_Group__c);
                System.assertEquals(175.0, c.Weekly_Installs__c);
            } else if (c.Id.equals(campaigns[14].Id)) {
                System.assertEquals(6.0, c.Budget_Group__c);
                System.assertEquals(175.0, c.Weekly_Installs__c);
            } else if (c.Id.equals(campaigns[15].Id)) {
                System.assertEquals(6.0, c.Budget_Group__c);
                System.assertEquals(175.0, c.Weekly_Installs__c);
            }
        }
    }

}
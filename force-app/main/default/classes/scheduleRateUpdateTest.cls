@istest
class scheduleRateUpdateTest {

    private class RestMock implements HttpCalloutMock {
        
        private Integer response;

        public void setResponseCode(Integer response) {
            this.response = response;
        }

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'your Json Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(this.response);
            return res;
        }
    }

   static testmethod void test() {

    //grab a System Admin profile
    Profile adminProfile = [SELECT Id FROM Profile WHERE Name LIKE 'System Administrator' LIMIT 1];
    //create a user
    List<User> users = new List<User>();
    users.add(new User(Alias = 'testc', 
                      Email = 'test_3@adactioninteractive.com', 
                      EmailEncodingKey = 'ISO-8859-1', 
                      FirstName = 'Test3', 
                      LanguageLocaleKey = 'en_US', 
                      LastName = 'Test', 
                      LocaleSidKey='en_US', 
                      Phone = '(303) 555-3001', 
                      ProfileId = adminProfile.Id, 
                      TimeZoneSidKey = 'America/Denver', 
                      UserName = 'test_3@adaction.com'));
    insert users;

    //insert an Account
    List<Account> accounts = new List<Account>();
    //including the Media_Account_Owner_incent__c &  Media_Account_Owner_nonincent__c fields as they are necessary for a process builder flow
    accounts.add(new Account(Name = 'Test Corporation', 
                            Media_Account_Owner_incent__c = users[0].Id, 
                            Media_Account_Owner_nonincent__c = users[0].Id,
                            Internal_Account_Manager_Demand__c = users[0].Id,
                            MMP_Advertiser_ID__c = '12345',
                            Advertiser_ID__c = '12345' ));
    insert accounts;

    //insert an Opportunity
    List<Opportunity> opportunities = new List<Opportunity>();
    opportunities.add(new Opportunity(AccountId = accounts[0].Id, 
                                    CloseDate = Date.Today(), 
                                    Name = 'Tess Corp - Great App - Android', 
                                    Probability = 100.0, 
                                    StageName = 'Closed Won'));
    insert opportunities;

    //insert Campaigns
    List<Campaign> campaigns = new List<Campaign>();
    campaigns.add(new Campaign(Account_Name__c = accounts[0].Id, 
                               Attribution_Tracking_Platform__c = 'Other', 
                               Billing_Type__c = 'CPA', 
                               Budget_Group__c = 1.0, 
                               Campaign_Media_Buy_Type__c = 'Affiliate Network', 
                               Campaign_Traffic_Type__c = 'Keyword', 
                               Connection_Type_Requirements__c = 'All types', 
                               Daily__c = 100, 
                               Device_Targeting__c = 'iPhone', 
                               EndDate = Date.Today().addDays(21), 
                               HO_Offer_ID__c = '21400', 
                               HO_Offer_Name__c = 'Cadremploi', 
                               Incent_Non_Incent__c = 'Non-Incent', 
                               IsActive = true,
                               MMP_Campaign_Name__c = 'Cadremploi001', 
                               Name = 'Cadremploi (Android, Free, ES, 46MB)', 
                               Operating_System__c = 'Android', 
                               Price_per_Conversion__c = 0.25, 
                               Related_Opportunity__c = opportunities[0].Id, 
                               StartDate = Date.Today().addDays(7), 
                               Tracking_URL__c = 'https://adaction.mobi/track/a/001',
                               Status = 'Live' ,
                               MMP_Advertiser_ID__c = '1234'
                               )
                        );
    insert campaigns;

    Test.startTest();

    RestMock mock;
    Boolean res;

    mock = new RestMock();
    mock.setResponseCode(200);
    Test.setMock(HttpCalloutMock.class, mock);

    //update Campaign, rate decrease
    List<Campaign> updateCampaigns = new List<Campaign>();
    updateCampaigns.add(new Campaign(Id = campaigns[0].Id, New_Rate_Adjustment_1__c = 0.20));
    update updateCampaigns;

    List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger
         order by NextFireTime desc];

    // Datetime now = System.now().addHours(1);
    // System.Debug('Now: ' + now.format('yyyy-MM-dd HH:mm'));
    // CronTrigger selected = null;
    // for (CronTrigger c : ct){
    //     // System.Debug('CronTrigger: ' + c.NextFireTime.format('yyyy-MM-dd HH:mm'));
    //     if (c.NextFireTime.format('yyyy-MM-dd HH:mm') == now.format('yyyy-MM-dd HH:mm')){
    //         System.assertEquals(c.NextFireTime.format('yyyy-MM-dd HH:mm'), 
    //             now.format('yyyy-MM-dd HH:mm'));
    //     }
    // }
    
    // Verify the next time the job will run
    //System.assertEquals('2042-09-03 00:00:00', 
    //String.valueOf(ct[0].NextFireTime));
    // Verify the expressions are the sam


    Test.stopTest();
   }
   
}
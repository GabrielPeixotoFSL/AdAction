public class rateAutomationTriggerHandler extends triggerHandler {
    public rateAutomationTriggerHandler() {
        super();
    }

    public static Boolean runningInASandbox {
        get {
            if (runningInASandbox == null) {
                runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            }
            return runningInASandbox;
        }
        set;
    }

    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    public class UpdateCampaignQueueable implements Queueable {
        private Id id;
        public UpdateCampaignQueueable(Id id) {
            this.id = id;
        }

        public void execute(QueueableContext context) {
            updateRateChangeSuccess(id, true);
        }
    }

    public static String dateToCronString(Datetime d) {
        return '' + d.second() + ' ' + d.minute() + ' ' + d.hour() + ' ' + d.day() + ' ' + d.month() + ' ? ' + d.year();
    }

    private static void updateRateChangeSuccess(Id id, Boolean success) {
        System.debug('Updating Rate Change Success id '+id);
        Campaign camp = [SELECT Id, Rate_Change_Successful__c FROM Campaign WHERE Id = :id];
        camp.Rate_Change_Successful__c = true;
        camp.Is_Delayed__c = false;
        update camp;
    }

    public override void beforeUpdate() {

        Set<String> Allowed_Campaign_Media_Buy_Types = 
            new Set<String>{
                            'AdGem Only', 'Affiliate Network', 'OG Only',
                            'Incent Network', 'Proprietary Traffic', 'Stacks'
                            };

        for (Campaign camp: (List<Campaign>)Trigger.new){
            
            //Campaign oldCamp = (Campaign) Trigger.oldMap.get(camp.ID);
            System.debug(camp.New_Rate_Adjustment_1__c);
            System.debug('Campaign Media Buy Type: '+camp.Campaign_Media_Buy_Type__c);
            System.debug('Campaign Media Buy Type result: '+Allowed_Campaign_Media_Buy_Types.contains(camp.Campaign_Media_Buy_Type__c));
            System.debug('Campaign Rate_Change_Successful__c: '+camp.Rate_Change_Successful__c);

            if( camp.New_Rate_Adjustment_1__c != null 
                && Allowed_Campaign_Media_Buy_Types.contains(camp.Campaign_Media_Buy_Type__c)
                && camp.Rate_Change_Successful__c == false ) {

                if(camp.New_Rate_Adjustment_1__c > camp.Price_per_Conversion__c){
                
                    System.Debug(camp.New_Rate_Adjustment_1__c);
                    System.Debug('Increase Rate');
                    sendNewRate(camp.ID, camp.New_Rate_Adjustment_1__c, camp.HO_Offer_ID__c, camp.Price_per_Conversion__c);
                
                } else if(camp.New_Rate_Adjustment_1__c < camp.Price_per_Conversion__c) {
                
                    System.Debug('Decrease Rate');
                    System.Debug('Trying to schedule rate update job...');
                    Integer delayInMinutes = 60;
                    String scheduleJobName = 'update-rate-change-job-'+generateRandomString(10);
                    System.Debug('Cron Job name '+scheduleJobName);
                    if(camp.Is_Delayed__c == false){
                        String cronExp = dateToCronString(System.now().addMinutes(delayInMinutes));
                        System.Debug('Cron expresion '+cronExp);
                        System.schedule(scheduleJobName, 
                                        cronExp, 
                                        new scheduleRateUpdate(camp.ID,camp.New_Rate_Adjustment_1__c));
                        System.Debug('Scheduled rate update job');
                        camp.Is_Delayed__c = true;
                    } else {
                        System.Debug('Updating from scheduled job...');
                        System.Debug('Rate update send to backend');
                        sendNewRate(camp.ID, camp.New_Rate_Adjustment_1__c, camp.HO_Offer_ID__c, camp.Price_per_Conversion__c);
                    }
                
                } else {
                
                    System.debug('Rates are equal');
                }
                
            } else {
                
                System.debug('New_Rate_Adjustment_1__c null or Campaign_Media_Buy_Types does not contain Media_Buy_Type__c '+
                             'or Rate_Change_Successful__c is true');
            }
        }
        
    }

    @future(callout=true)
    public static void sendNewRate(Id id, Decimal newRateAdjustment, String offerId, Decimal oldRate){

        String username = 'gW49HYZRoQuUCpE9nNQdtN';
        String password = '0koMCczSs19X4XqucUQ9tU';
        String rateChangeBackendURL = '';
        if(runningInASandbox){
            rateChangeBackendURL='https://y22rrj64x0.execute-api.us-east-1.amazonaws.com/production/rate_change';
            System.Debug('Using Sandbox url: '+rateChangeBackendURL);
        } else {
            rateChangeBackendURL='https://y22rrj64x0.execute-api.us-east-1.amazonaws.com/production/rate_change';
        }

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
      	request.setEndpoint(rateChangeBackendURL);
        request.setMethod('POST');
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Set the body as a JSON object
        String bodyStr = '{ "new_rate": "' + newRateAdjustment + '",'
                          + '"offer_id": "' + offerId + '",'
                          + '"old_rate": "' + oldRate + '"' 
                          + ' }';
        request.setBody(bodyStr);
        System.Debug('Before Sending Request');
        HttpResponse response = http.send(request);
        System.Debug('After Sending Request');
            
        System.debug('Response Status: ' + response.getStatusCode());
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
          System.debug('The status code returned was not expected: ' +
                        response.getStatusCode() + ' ' + response.getStatus());

        } else {
            System.Debug('Print Body');
            System.debug(response.getBody());
            System.Debug('Updating Rate Change Success');
            //updateRateChangeSuccess(id, true);
            System.enqueueJob(new UpdateCampaignQueueable(id));
        }

    }
}
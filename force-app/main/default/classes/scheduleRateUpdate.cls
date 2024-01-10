global class scheduleRateUpdate implements Schedulable {
    //This class is used to schedule a delayed job to update the rates in Tune
    private Id campaignId;
    private Decimal newRate;
    public static String CRON_EXP = '0 0 0 3 9 ? 2042';

    public ScheduleRateUpdate(Id campaignId, Decimal newRate) {
        this.campaignId = campaignId;
        this.newRate = newRate;
    }

    public void execute(SchedulableContext sc) {
        //Update the rate in Tune
        Campaign c = [SELECT Id, New_Rate_Adjustment_1__c FROM Campaign WHERE Id = :campaignId];
        System.Debug('Updating rate for campaign ' + c.Id + ' to ' + newRate);
        c.New_Rate_Adjustment_1__c = newRate;
        update c;
    }

}
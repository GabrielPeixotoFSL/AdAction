/*
    Created by: Greg Hacic
    Last Update: 3 January 2020 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - this class inherits from triggerHandler.cls
        - tests located at campaignTriggerHandlerTest.cls
*/
public class campaignTriggerHandler extends triggerHandler {
    
    private Map<Id, Campaign> newRecordMap; //map of new records
    private Map<Id, Campaign> oldRecordMap; //map of old records
    private List<Campaign> newRecords; //list of new records
    private List<Campaign> oldRecords; //list of old records
    private static Set<Id> idsOfDailyChanges = new Set<Id>(); //set of Campaign.Id for tracking Daily__c value changes
    private static Set<Id> idsOfDailyInstallsChanges = new Set<Id>(); //set of Campaign.Id for tracking Daily_Installs__c value changes
    private static Set<Id> campaignsThatHaveProcessed = new Set<Id>(); //set of Campaign records that have been processed already in this session
    
    //constructor
    public campaignTriggerHandler() {
        newRecordMap = (Map<Id, Campaign>)Trigger.newMap; //cast the map of new records
        newRecords = (List<Campaign>)Trigger.new;  //cast the list of new records
        oldRecordMap = (Map<Id, Campaign>)Trigger.oldMap; //cast the map of old records
        oldRecords = (List<Campaign>)Trigger.old; //cast the list of old records
    }
    
    //overrides TriggerHandler.beforeInsert method > Trigger.isBefore && Trigger.isInsert
    public override void beforeInsert() {
        //System.debug('- beforeInsert: begin -');
        //maintain Daily__c & Daily_Installs__c
        for (Campaign c : newRecords) { //for each Campaign
            //System.debug('record: '+c.Name+' ('+c.Id+')');
            //System.debug('Daily__c: '+c.Daily__c);
            //System.debug('Price_per_Conversion__c: '+c.Price_per_Conversion__c);
            //System.debug('Daily_Installs__c: '+c.Daily_Installs__c);
            if (c.Daily_Installs__c == null && c.Daily__c != null && c.Price_per_Conversion__c != null) { //if Daily__c & Price_per_Conversion__c are filled in but not the Daily_Installs__c
                //System.debug('Daily_Installs__c = '+(c.Daily__c / c.Price_per_Conversion__c));
                //check for null prior to making calculations
                c.Daily_Installs__c = c.Daily__c / c.Price_per_Conversion__c; //populate the Daily_Installs__c
                //idsOfDailyChanges.add(c.Id); //denote the Id of the record that had the Daily__c changes
            } else if (c.Daily__c == null && c.Daily_Installs__c != null && c.Price_per_Conversion__c != null) { //if Daily_Installs__c & Price_per_Conversion__c are filled in but not the Daily__c
                //System.debug('Daily__c = '+ (c.Daily_Installs__c * c.Price_per_Conversion__c));
                //check for null prior to making calculations
                c.Daily__c = c.Daily_Installs__c * c.Price_per_Conversion__c; //populate the Daily__c
                //idsOfDailyInstallsChanges.add(c.Id); //denote the Id of the record that had the Daily_Installs__c changes
            }
        }
        //System.debug('- beforeInsert: end -');
    }
    
    //overrides TriggerHandler.afterInsert method > Trigger.isAfter && Trigger.isInsert
    public override void afterInsert() {
        //System.debug('- afterInsert: begin -');
        handleGroupBudgetDetails(); //handle details that apply to Group Budgets
        //System.debug('- afterInsert: end -');
    }
    
    //overrides TriggerHandler.beforeUpdate method > Trigger.isBefore && Trigger.isUpdate
    public override void beforeUpdate() {
        //System.debug('- beforeUpdate: begin -');
        //maintain Daily__c & Daily_Installs__c
        for (Campaign c : newRecords) { //for each Campaign
            //System.debug('record: '+c.Name+' ('+c.Id+')');
            //System.debug('Daily__c: '+c.Daily__c);
            //System.debug('OLD.Daily__c: '+oldRecordMap.get(c.Id).Daily__c);
            //System.debug('Price_per_Conversion__c: '+c.Price_per_Conversion__c);
            //System.debug('OLD.Price_per_Conversion__c: '+oldRecordMap.get(c.Id).Price_per_Conversion__c);
            //System.debug('Daily_Installs__c: '+c.Daily_Installs__c);
            //System.debug('OLD.Daily_Installs__c: '+oldRecordMap.get(c.Id).Daily_Installs__c);
            if (c.Daily__c != null && c.Price_per_Conversion__c != null && c.Daily_Installs__c == oldRecordMap.get(c.Id).Daily_Installs__c && (c.Daily__c != oldRecordMap.get(c.Id).Daily__c || c.Price_per_Conversion__c != oldRecordMap.get(c.Id).Price_per_Conversion__c)) { //if Daily__c OR Price_per_Conversion__c changed but Daily_Installs__c didn't
                //System.debug('CALCULATED.Daily_Installs__c = '+(c.Daily__c / c.Price_per_Conversion__c));
                c.Daily_Installs__c = c.Daily__c / c.Price_per_Conversion__c; //populate the Daily_Installs__c
                idsOfDailyInstallsChanges.add(c.Id); //denote the Id of the record that had the Daily_Installs__c changes
            } else if (c.Daily_Installs__c != null && c.Price_per_Conversion__c != null && c.Daily__c == oldRecordMap.get(c.Id).Daily__c && (c.Daily_Installs__c != oldRecordMap.get(c.Id).Daily_Installs__c || c.Price_per_Conversion__c != oldRecordMap.get(c.Id).Price_per_Conversion__c)) { //if Daily_Installs__c OR Price_per_Conversion__c changed but Daily__c didn't
                //System.debug('CALCULATED.Daily__c = '+ (c.Daily_Installs__c * c.Price_per_Conversion__c));
                c.Daily__c = c.Daily_Installs__c * c.Price_per_Conversion__c; //populate the Daily__c
                idsOfDailyChanges.add(c.Id); //denote the Id of the record that had the Daily__c changes
            }
        }
        //System.debug('- beforeUpdate: end -');
    }
    
    //overrides TriggerHandler.afterUpdate method > Trigger.isAfter && Trigger.isUpdate
    public override void afterUpdate() {
        //System.debug('- afterUpdate: begin -');
        handleGroupBudgetDetails(); //handle details that apply to Group Budgets
        //System.debug('- afterUpdate: end -');
    }
    
    /*overrides TriggerHandler.beforeDelete method > Trigger.isBefore && Trigger.isDelete
    public override void beforeDelete() {
        //System.debug('- beforeDelete: begin -');
        //not yet implemented...
        //System.debug('- beforeDelete: end -');
    }*/
    
    //overrides TriggerHandler.afterDelete method > Trigger.isAfter && Trigger.isDelete
    public override void afterDelete() {
        //System.debug('- afterDelete: begin -');
        handleGroupBudgetDetails(); //handle details that apply to Group Budgets
        //System.debug('- afterDelete: end -');
    }
    
    //overrides TriggerHandler.afterUndelete method > Trigger.isAfter && Trigger.isUndelete
    public override void afterUndelete() {
        //System.debug('- afterUndelete: begin -');
        handleGroupBudgetDetails(); //handle details that apply to Group Budgets
        //System.debug('- afterUndelete: end -');
    }
    
    //handle Shared_Budget__c maintenance
    public void handleGroupBudgetDetails() {
        //System.debug('- handleGroupBudgetDetails: begin -');
        Map<String, Set<Id>> campaignChanges = new Map<String, Set<Id>>(); //map of string -> set of Campaign.Id
        Set<Id> relatedOpportunityIds = new Set<Id>(); //set of Opportunity.Id
        List<Campaign> loopCampaigns = newRecords; //list of Campaign records to be used in the for loop later within this method - defaulted to the list of new records
        Set<Id> changedBudgetGroupIds = new Set<Id>(); //set of Campaign.Id
        Map<Id, Map<Decimal, Id>> budgetGroupChangeMap = new Map<Id, Map<Decimal, Id>>(); //Opportunity.Id -> Budget_Group__c -> Campaign.Id - this ensures we don't execute later logic for Campaigns in the same budget group because that may cause strange behaviour
        
        if (Trigger.isDelete) { //if delete context
            loopCampaigns = oldRecords; //use the old version of Campaigns
        }
        
        for (Campaign c : loopCampaigns) { //for each new version of Campaign record
            //System.debug('Name: '+c.Name);
            //System.debug('Related_Opportunity__c: '+c.Related_Opportunity__c);
            if (String.isNotBlank(c.Related_Opportunity__c)) { //if Related_Opportunity__c is not whitespace, not empty (''), and not null
                //System.debug('Budget_Group__c: '+c.Budget_Group__c);
                //System.debug('Trigger.isUpdate: '+Trigger.isUpdate);
                if (Trigger.isUpdate && c.Budget_Group__c != null) { //if update or insert context and budget group is not null
                    if (c.Budget_Group__c != oldRecordMap.get(c.Id).Budget_Group__c) { //if the Budget_Group__c was changed
                        //determine if this is the latest and greatest record for the budget group - not using LastModifiedDate because of the records are in the same batch then they have the exact same LastModifiedDate, which doesn't help determine the winner
                        Map<Decimal, Id> groupToCurrentlyWinningCampaign = new Map<Decimal, Id>(); //temporary map for Budget_Group__c -> Id
                        if (budgetGroupChangeMap.containsKey(c.Related_Opportunity__c)) { //if the map already contains a key for this Opportunity
                            groupToCurrentlyWinningCampaign = budgetGroupChangeMap.get(c.Related_Opportunity__c); //grab the value from the map corresponding to this key
                        }
                        groupToCurrentlyWinningCampaign.put(c.Budget_Group__c, c.Id); //populate the map and overwrite any previous value for the key with this Campaign Id
                        budgetGroupChangeMap.put(c.Related_Opportunity__c, groupToCurrentlyWinningCampaign); //populate the map with the key/value
                    } else {
                        //System.debug('Trigger.isUpdate && c.Budget_Group__c != null: TRUE');
                        //Daily__c & Daily_Installs__c changes tracking
                        //we are doing this logic differently due to the fact that we are calculating the daily value using Price_per_Conversion__c in the before trigger context (earlier in this trigger)
                        //System.debug('Daily__c: '+c.Daily__c);
                        //System.debug('oldRecordMap.get(c.Id).Daily__c: '+oldRecordMap.get(c.Id).Daily__c);
                        //System.debug('Daily_Installs__c: '+c.Daily_Installs__c);
                        //System.debug('oldRecordMap.get(c.Id).Daily_Installs__c: '+oldRecordMap.get(c.Id).Daily_Installs__c);
                        //System.debug('idsOfDailyChanges.contains(c.Id): '+idsOfDailyChanges.contains(c.Id));
                        //System.debug('idsOfDailyInstallsChanges.contains(c.Id): '+idsOfDailyInstallsChanges.contains(c.Id));
                        if (idsOfDailyChanges.contains(c.Id)) { //if Daily__c changed but not Daily_Installs__c
                            //System.debug(':Daily__c changes:');
                            campaignChanges = campaignUtil.populateChangesMap(campaignChanges, 'Daily__c', c.Id); //populate the map for Daily__c
                        } else if (idsOfDailyInstallsChanges.contains(c.Id)) { //if Daily_Installs__c changed but not Daily__c
                            //System.debug(':Daily_Installs__c changes:');
                            campaignChanges = campaignUtil.populateChangesMap(campaignChanges, 'Daily_Installs__c', c.Id); //populate the map for Daily_Installs__c
                        }
                        //Weekly__c & Weekly_Installs__c changes tracking
                        if (c.Weekly__c != oldRecordMap.get(c.Id).Weekly__c) { //if Weekly__c changed
                            //System.debug(':Weekly__c changes:');
                            campaignChanges = campaignUtil.populateChangesMap(campaignChanges, 'Weekly__c', c.Id); //populate the map for Weekly__c
                        }
                        if (c.Weekly_Installs__c != oldRecordMap.get(c.Id).Weekly_Installs__c) { //if Weekly_Installs__c changed
                            //System.debug(':Weekly_Installs__c changes:');
                            campaignChanges = campaignUtil.populateChangesMap(campaignChanges, 'Weekly_Installs__c', c.Id); //populate the map for Weekly_Installs__c
                        }
                        //Monthly__c & Monthly_Installs__c changes tracking
                        if (c.Monthly__c != oldRecordMap.get(c.Id).Monthly__c) { //if Monthly__c changed
                            //System.debug(':Monthly__c changes:');
                            campaignChanges = campaignUtil.populateChangesMap(campaignChanges, 'Monthly__c', c.Id); //populate the map for Monthly__c
                        }
                        if (c.Monthly_Installs__c != oldRecordMap.get(c.Id).Monthly_Installs__c) { //if Monthly_Installs__c changed
                            //System.debug(':Monthly_Installs__c changes:');
                            campaignChanges = campaignUtil.populateChangesMap(campaignChanges, 'Monthly_Installs__c', c.Id); //populate the map for Monthly_Installs__c
                        }
                    }
                }
                relatedOpportunityIds.add(c.Related_Opportunity__c); //add the Related_Opportunity__c to the set
            }
        }
        //System.debug('!relatedOpportunityIds.isEmpty(): '+!relatedOpportunityIds.isEmpty());
        if (!relatedOpportunityIds.isEmpty()) { //if the set is not empty
            if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) { //if we are under the limit for queued jobs
                //System.debug(':queueHandleBudgetGroups:');
                System.enqueueJob(new queueHandleBudgetGroups(relatedOpportunityIds, campaignChanges)); //queue up the queueHandleBudgetGroups process
            } else if (!System.isFuture() && !System.isBatch()) { //if context is not future and not batch
                //future methods cannot handle complex structures including Map<String, Set<Id>> - even if they are constructed of primitives
                //so we have to break this map into parts and reconstruct it within the future method
                //System.debug(':campaignUtil.handleBudgetGroupsFuture:');
                campaignUtil.handleBudgetGroupsFuture(relatedOpportunityIds, campaignUtil.extractChangedIds(campaignChanges, 'Daily__c'), campaignUtil.extractChangedIds(campaignChanges, 'Daily_Installs__c'), campaignUtil.extractChangedIds(campaignChanges, 'Monthly__c'), campaignUtil.extractChangedIds(campaignChanges, 'Monthly_Installs__c'), campaignUtil.extractChangedIds(campaignChanges, 'Weekly__c'), campaignUtil.extractChangedIds(campaignChanges, 'Weekly_Installs__c')); //process asynchronously
            } else { //otherwise, process in series
                //System.debug(':campaignUtil.handleBudgetGroups:');
                campaignUtil.handleBudgetGroups(relatedOpportunityIds, campaignChanges); //process synchronously
            }
        }
        //wholesale change to all Campaigns with the same Budget_Group__c
        if (!budgetGroupChangeMap.isEmpty()) { //if the map is not empty
            //construct a set of Id to pass on to another method
            for (Id i: budgetGroupChangeMap.keySet()) { //for each Id used as a key in the budgetGroupChangeMap map
                Map<Decimal, Id> valuesFromBudgetGroupChangeMap = new Map<Decimal, Id>(); //construct a new map object
                valuesFromBudgetGroupChangeMap = budgetGroupChangeMap.get(i); //grab the map corresponding to this key
                for (Decimal d : valuesFromBudgetGroupChangeMap.keySet()) { //for all of the keys in the map
                    changedBudgetGroupIds.add(valuesFromBudgetGroupChangeMap.get(d)); //grab the Id value from the map corresponding to the decimal and add that Id to the set
                }
            }
            if (!changedBudgetGroupIds.isEmpty()) { //if the set is not empty
                if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) { //if we are under the limit for queued jobs
                    System.enqueueJob(new queueNewBudgetGroups(changedBudgetGroupIds)); //queue up the queueNewBudgetGroups process
                } else if (!System.isFuture() && !System.isBatch()) { //if context is not future and not batch
                    campaignUtil.newBudgetGroupsFuture(changedBudgetGroupIds); //process asynchronously
                } else { //otherwise, process in series
                    campaignUtil.newBudgetGroups(changedBudgetGroupIds); //process synchronously
                }
            }
        }
        //System.debug('- handleGroupBudgetDetails: end -');
    }

}
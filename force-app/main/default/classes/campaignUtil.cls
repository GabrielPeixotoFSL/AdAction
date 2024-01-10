/*
    Created by: Greg Hacic
    Last Update: 3 January 2020 by Greg Hacic
    Questions?: greg@ities.co
    
    Notes:
        - methods specific to the Campaign object
        - tests located at campaignUtilTest.cls
*/
public class campaignUtil {
    
    //maintain specific values across Campaigns with the same budget group
    public static void handleBudgetGroups(Set<Id> opportunityIds, Map<String, Set<Id>> campaignChanges) {
        //System.debug('- handleBudgetGroups | campaignUtil.handleBudgetGroups: begin -');
        Map<Id, Map<Integer, Set<Id>>> relatedCampaigns = new Map<Id, Map<Integer, Set<Id>>>(); //map of Opportunity.Id -> Campaign.Budget_Group__c -> Campaign.Id
        Map<Id, Map<Integer, Map<String, Campaign>>> changes = new Map<Id, Map<Integer, Map<String, Campaign>>>(); //map of Opportunity.Id -> Campaign.Budget_Group__c -> Changed Field -> winning Campaign object for use in setting value within loop
        List<Campaign> campaignsLinkedToOpportunities = new List<Campaign>(); //Campaigns to be processed
        Map<Id, Campaign> updates = new Map<Id, Campaign>(); //Campaigns to be updated
        Map<Id, Campaign> campaignDetails = new Map<Id, Campaign>(); //Campaigns to be referenced in logic as needed
        //System.debug('handleBudgetGroups | opportunityIds: '+opportunityIds);
        //System.debug('handleBudgetGroups | campaignChanges.size(): '+campaignChanges.size());
        //grab all the related Campaigns
        for (Campaign camp : [SELECT Budget_Group__c, Daily__c, Daily_Installs__c, Id, LastModifiedDate, Monthly__c, Monthly_Installs__c, Name, Price_per_Conversion__c, Related_Opportunity__c, Shared_Budget__c, Weekly__c, Weekly_Installs__c FROM Campaign WHERE Related_Opportunity__c in :opportunityIds]) { //query for all Campaigns with the same Related_Opportunity__c
            //System.debug('handleBudgetGroups | camp: '+camp);
            //System.debug('handleBudgetGroups | Budget_Group__c: '+camp.Budget_Group__c);
            if (camp.Budget_Group__c != null) { //if Budget_Group__c is not null
                Set<Id> campaignIds = new Set<Id>(); //set of Campaign.Id
                Map<Integer, Set<Id>> linkedCampaigns = new Map<Integer, Set<Id>>(); //map of Campaign Groups linked by Related_Opportunity__c
                campaignDetails.put(camp.Id, camp); //populate the details to the map should they be needed later
                if (relatedCampaigns.containsKey(camp.Related_Opportunity__c)) { //if the Related_Opportunity__c key is found in our relatedCampaigns map
                    linkedCampaigns = relatedCampaigns.get(camp.Related_Opportunity__c); //grab the existing map
                }
                if (linkedCampaigns.containsKey(camp.Budget_Group__c.intValue())) { //if the Budget_Group__c key is found in our linkedCampaigns map
                    campaignIds = linkedCampaigns.get(camp.Budget_Group__c.intValue()); //grab the existing set
                }
                campaignIds.add(camp.Id); //add the Id to our set
                linkedCampaigns.put(camp.Budget_Group__c.intValue(), campaignIds); //add the Campaign to our list
                relatedCampaigns.put(camp.Related_Opportunity__c, linkedCampaigns); //populate the map
                if (!campaignChanges.isEmpty()) {
                    changes = campaignUtil.buildChangesMap(changes, campaignChanges, camp); //determine if this Campaign is the winner for changes to be applied to other Campaigns with the same budget group
                    //System.debug('handleBudgetGroups | changes: '+changes);
                }
            }
            campaignsLinkedToOpportunities.add(camp); //add the Campaign to List
        }
        
        //determine which Campaign records need to be updated
        for (Campaign c : campaignsLinkedToOpportunities) { //for each Campaign record from our earlier query
            /*if (!campaignChanges.isEmpty()) {
              //System.debug('handleBudgetGroups | changes: '+changes);
            }*/
            Boolean sharedBudgetValue = false; //default boolean to use
            if (c.Budget_Group__c != null) { //if Budget_Group__c is not null
                if (relatedCampaigns.containsKey(c.Related_Opportunity__c)) { //if the Related_Opportunity__c is a key in the map
                    Map<Integer, Set<Id>> m1 = relatedCampaigns.get(c.Related_Opportunity__c); //grab the map from the map
                    if (m1.containsKey(c.Budget_Group__c.intValue())) { //if the Budget_Group__c is a key in the map
                        Set<Id> s1 = m1.get(c.Budget_Group__c.intValue()); //grab the set from the map
                        if (s1.size() > 1) { //if there is more than one Id in the set
                            sharedBudgetValue = true;
                        }
                    }
                }
                //check if there are field level changes that need to be applied to this Campaign
                if (changes.containsKey(c.Related_Opportunity__c)) { //if the Related_Opportunity__c is a key in the map
                    Map<Integer, Map<String, Campaign>> m1 = changes.get(c.Related_Opportunity__c); //grab the map from the map
                    if (m1.containsKey(c.Budget_Group__c.intValue())) { //if the map contains a matching budget group
                        Map<String, Campaign> m2 = m1.get(c.Budget_Group__c.intValue()); //grab the map of changes to be applied
                        //Daily__c, Daily_Installs__c
                        if (m2.containsKey('Daily__c')) { //if Daily__c changes
                            Campaign c1 = m2.get('Daily__c'); //grab the campaign object from the map
                            if (c.Daily__c != c1.Daily__c) { //if the existing value is different from the winning value
                                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                                Campaign orig = campaignDetails.get(c.Id); //grab the orginal campaign details from the map
                                if (updates.containsKey(c.Id)) { 
                                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                                }
                                c2.Daily__c = c1.Daily__c; //populate the winning Daily__c value
                                if (orig.Price_per_Conversion__c != null) { //if there is a Price_per_Conversion__c value
                                    c2.Daily_Installs__c = c1.Daily__c / orig.Price_per_Conversion__c; //populate the Daily_Installs__c using the Price_per_Conversion__c from the original record
                                }
                                updates.put(c.Id, c2); //populate the map
                            }
                        }
                        if (m2.containsKey('Daily_Installs__c')) { //if Daily_Installs__c changes
                            Campaign c1 = m2.get('Daily_Installs__c'); //grab the campaign object from the map
                            if (c.Daily_Installs__c != c1.Daily_Installs__c) { //if the existing value is different from the winning value
                                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                                Campaign orig = campaignDetails.get(c.Id); //grab the orginal campaign details from the map
                                if (updates.containsKey(c.Id)) { 
                                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                                }
                                c2.Daily_Installs__c = c1.Daily_Installs__c; //populate the winning Daily_Installs__c value
                                if (orig.Price_per_Conversion__c != null) { //if there is a Price_per_Conversion__c value
                                    c2.Daily__c = c1.Daily_Installs__c * orig.Price_per_Conversion__c; //populate the Daily__c using the Price_per_Conversion__c from the original record
                                }
                                updates.put(c.Id, c2); //populate the map
                            }
                        }
                        //Monthly__c, Monthly_Installs__c
                        if (m2.containsKey('Monthly__c')) { //if Monthly__c changes
                            Campaign c1 = m2.get('Monthly__c'); //grab the campaign object from the map
                            if (c.Monthly__c != c1.Monthly__c) { //if the existing value is different from the winning value
                                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                                if (updates.containsKey(c.Id)) { 
                                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                                }
                                c2.Monthly__c = c1.Monthly__c; //populate the winning Monthly__c value
                                updates.put(c.Id, c2); //populate the map
                            }
                        }
                        if (m2.containsKey('Monthly_Installs__c')) { //if Monthly_Installs__c changes
                            Campaign c1 = m2.get('Monthly_Installs__c'); //grab the campaign object from the map
                            if (c.Monthly_Installs__c != c1.Monthly_Installs__c) { //if the existing value is different from the winning value
                                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                                if (updates.containsKey(c.Id)) { 
                                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                                }
                                c2.Monthly_Installs__c = c1.Monthly_Installs__c; //populate the winning Monthly_Installs__c value
                                updates.put(c.Id, c2); //populate the map
                            }
                        }
                        //Weekly__c, Weekly_Installs__c
                        if (m2.containsKey('Weekly__c')) { //if Weekly__c changes
                            Campaign c1 = m2.get('Weekly__c'); //grab the campaign object from the map
                            if (c.Weekly__c != c1.Weekly__c) { //if the existing value is different from the winning value
                                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                                if (updates.containsKey(c.Id)) { 
                                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                                }
                                c2.Weekly__c = c1.Weekly__c; //populate the winning Weekly__c value
                                updates.put(c.Id, c2); //populate the map
                            }
                        }
                        if (m2.containsKey('Weekly_Installs__c')) { //if Weekly_Installs__c changes
                            Campaign c1 = m2.get('Weekly_Installs__c'); //grab the campaign object from the map
                            if (c.Weekly_Installs__c != c1.Weekly_Installs__c) { //if the existing value is different from the winning value
                                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                                if (updates.containsKey(c.Id)) { 
                                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                                }
                                c2.Weekly_Installs__c = c1.Weekly_Installs__c; //populate the winning Weekly_Installs__c value
                                updates.put(c.Id, c2); //populate the map
                            }
                        }
                    }
                }
            }
            if (c.Shared_Budget__c != sharedBudgetValue) { //if the boolean is not properly set
                Campaign c2 = new Campaign(Id = c.Id); //construct a new Campaign object
                if (updates.containsKey(c.Id)) { 
                    c2 = updates.get(c.Id); //grab the Campaign object from the map
                }
                c2.Shared_Budget__c = sharedBudgetValue; //populate the winning Shared_Budget__c value
                updates.put(c.Id, c2); //populate the map
            }
        }
        //update the campaigns
        if (!updates.isEmpty()) { //if the map is not empty
            TriggerHandler.bypass('campaignTriggerHandler'); //set the bypass so the trigger does not fire during this update
            List<Database.SaveResult> results = Database.update(updates.values(), false); //update the Campaigns and allow for partial failures
            TriggerHandler.clearBypass('campaignTriggerHandler'); //clear the trigger bypass designation
        }
        //System.debug('- handleBudgetGroups | campaignUtil.handleBudgetGroups: end -');
    }
    
    //execute the handleBudgetGroups method asynchronously
    //complex structures and objects are not permitted so we need to reassemble the sets of passed Ids
    @future //future annotation indicates asynchronous execution
    public static void handleBudgetGroupsFuture(Set<Id> opportunityIds, Set<Id> dailySet, Set<Id> dailyInstallsSet, Set<Id> monthlySet, Set<Id> monthlyInstallsSet, Set<Id> weeklySet, Set<Id> weeklyInstallsSet) {
        Map<String, Set<Id>> campaignChanges = new Map<String, Set<Id>>(); //map for reconstructed sets
        campaignChanges.put('Daily__c', dailySet);
        campaignChanges.put('Daily_Installs__c', dailyInstallsSet);
        campaignChanges.put('Monthly__c', monthlySet);
        campaignChanges.put('Monthly_Installs__c', monthlyInstallsSet);
        campaignChanges.put('Weekly__c', weeklySet);
        campaignChanges.put('Weekly_Installs__c', weeklyInstallsSet);
        campaignUtil.handleBudgetGroups(opportunityIds, campaignChanges); //pass the set to the handleBudgetGroups method
    }
    
    //populates a map of Campaign record changes
    public static Map<String, Set<Id>> populateChangesMap(Map<String, Set<Id>> passedMap, String passedKey, Id passedId) {
        Set<Id> setOfIds = new Set<Id>(); //set of Id
        if (String.isNotBlank(passedId) && String.isNotBlank(passedKey)) { //if the strings are not blank, null or empty ''
            if (passedMap.containsKey(passedKey)) { //if the map already contains a key for passedKey
                setOfIds = passedMap.get(passedKey); //grab the set for the passedKey key
            }
            setOfIds.add(passedId); //add the Id to the set
            passedMap.put(passedKey, setOfIds); //populate the map
        }
        return passedMap; //return the map
    }
    
    //returns a Set of Id
    public static Set<Id> extractChangedIds(Map<String, Set<Id>> passedMap, String passedKey) {
        Set<Id> returnSet = new Set<Id>(); //set of Id
        if (passedMap.containsKey(passedKey)) { //if the set contains a key for passedKey
            returnSet = passedMap.get(passedKey); //grab the set from the map corresponding to the passedKey key
        }
        return returnSet; //return the set
    }
    
    //builds a map of changed attributes and their winning values to be used for Campaigns with same budget group
    public static Map<Id, Map<Integer, Map<String, Campaign>>> buildChangesMap(Map<Id, Map<Integer, Map<String, Campaign>>> m, Map<String, Set<Id>> campaignChanges, Campaign camp) {
        //System.debug('- campaignUtil.buildChangesMap: begin -');
        Map<Integer, Map<String, Campaign>> campaignGroupChanges = new Map<Integer, Map<String, Campaign>>(); //
        Map<String, Campaign> fieldChanges = new Map<String, Campaign>();
        for (String fieldName : campaignChanges.keySet()) { //for each key in the passed map
            //System.debug('fieldName: '+fieldName);
            Set<Id> campaignIds = campaignChanges.get(fieldName); //grab the set of Id from the map
            //System.debug('campaignIds: '+campaignIds);
            //System.debug('campaignIds.contains('+camp.Id+'): '+campaignIds.contains(camp.Id));
            if (campaignIds.contains(camp.Id)) { //if the Id is in the set
                //System.debug('m.containsKey('+camp.Related_Opportunity__c+'): '+m.containsKey(camp.Related_Opportunity__c));
                if (m.containsKey(camp.Related_Opportunity__c)) { //if the map already has a key for the Opportunity.Id
                    //System.debug('campaignGroupChanges: '+m.get(camp.Related_Opportunity__c));
                    campaignGroupChanges = m.get(camp.Related_Opportunity__c); //grab the value from the map corresponding to the key
                }
                //System.debug('campaignGroupChanges.containsKey('+camp.Budget_Group__c.intValue()+'): '+campaignGroupChanges.containsKey(camp.Budget_Group__c.intValue()));
                if (campaignGroupChanges.containsKey(camp.Budget_Group__c.intValue())) { //if the Budget_Group__c key is found in our campaignGroupChanges map
                    //System.debug('fieldChanges: '+campaignGroupChanges.get(camp.Budget_Group__c.intValue()));
                    fieldChanges = campaignGroupChanges.get(camp.Budget_Group__c.intValue()); //grab the existing map
                }
                fieldChanges.put(fieldName, camp); //populate the map
                campaignGroupChanges.put(camp.Budget_Group__c.intValue(), fieldChanges); //populate the map
                m.put(camp.Related_Opportunity__c, campaignGroupChanges); //populate the map
            }
        }
        //System.debug('- campaignUtil.buildChangesMap: end -');
        return m; //return the map
    }
    
    //find all Campaigns with matching Opportunity relationship and Budget_Group__c then populate the values from the source record to all target records
    public static void newBudgetGroups(Set<Id> campaignIds) {
        //System.debug('- newBudgetGroups: begin -');
        //System.debug('passed set of Id: '+campaignIds);
        List<Campaign> updatedCampaigns = new List<Campaign>(); //list of Campaign
        Set<Id> opportunityIds = new Set<Id>(); //set of Opportunity.Id
        Set<Decimal> budgetGroups = new Set<Decimal>(); //set of Budget_Group__c
        Map<String, Campaign> winningCampaignDetails = new Map<String, Campaign>(); //map of String -> Campaign
        //grab details for the passed set of Campaign records
        for (Campaign c : [SELECT Budget_Group__c, Daily__c, Daily_Installs__c, Id, LastModifiedDate, Monthly__c, Monthly_Installs__c, Name, Price_per_Conversion__c, Related_Opportunity__c, Shared_Budget__c, Weekly__c, Weekly_Installs__c FROM Campaign WHERE Related_Opportunity__c != null AND Budget_Group__c != null AND Id in :campaignIds]) { //query for all Campaign details
            String identifier = c.Related_Opportunity__c+c.Budget_Group__c.format(); //construct a unique string using the record Id and the budget group
            winningCampaignDetails.put(identifier, c); //populate the map with the key/value
            opportunityIds.add(c.Related_Opportunity__c); //add the Opportunity.Id to our set
            budgetGroups.add(c.Budget_Group__c); //add the Opportunity.Id to our set
        }
        //System.debug('winningCampaignDetails: '+winningCampaignDetails);
        //System.debug('opportunityIds: '+opportunityIds);
        //System.debug('budgetGroups: '+budgetGroups);
        //System.debug('- find similar campaigns...');
        for (Campaign c : [SELECT Budget_Group__c, Daily__c, Daily_Installs__c, Id, LastModifiedDate, Monthly__c, Monthly_Installs__c, Name, Price_per_Conversion__c, Related_Opportunity__c, Shared_Budget__c, Weekly__c, Weekly_Installs__c FROM Campaign WHERE Related_Opportunity__c in :opportunityIds AND Budget_Group__c in :budgetGroups AND Id NOT in :campaignIds]) { //query for all campaigns in the same budget group and related to the same opportunities but exclude the records we already queried above
            //System.debug('Name: '+c.Name+'('+c.Id+')');
            //grab the shit we need from the winning record and populate it to the record in the loop
            Campaign currentRec = new Campaign(Id = c.Id); //construct a new Campaign object
            Campaign winningRec = new Campaign(); //construct a new Campaign object
            Boolean thingsAreDifferent = false; //boolean designation for determining if a change was detected
            //grab the winning Campaign from the map
            //System.debug('Budget_Group__c: '+c.Budget_Group__c);
            String identifier = c.Related_Opportunity__c+c.Budget_Group__c.format(); //construct a unique string using the record Id and the budget group
            //System.debug('winningCampaignDetails.containsKey('+identifier+'): '+winningCampaignDetails.containsKey(identifier));
            if (winningCampaignDetails.containsKey(identifier)) { //if the string is found as a key in the map
                winningRec = winningCampaignDetails.get(identifier); //grab the Campaign value from the map for the key
                if (winningRec.Daily__c != c.Daily__c) { //if the Daily__c value is different
                    currentRec.Daily__c = winningRec.Daily__c; //set the value from the winning record
                    //we may want to calculate Daily_Installs__c but we cannot easily determine the value...
                    thingsAreDifferent = true; //found a difference
                }
                if (winningRec.Daily_Installs__c != c.Daily_Installs__c) { //if the Daily_Installs__c value is different
                    currentRec.Daily_Installs__c = winningRec.Daily_Installs__c; //set the value from the winning record
                    //we may want to calculate Daily__c but we cannot easily determine the value...
                    thingsAreDifferent = true; //found a difference
                }
                if (winningRec.Monthly__c != c.Monthly__c) { //if the Monthly__c value is different
                    currentRec.Monthly__c = winningRec.Monthly__c; //set the value from the winning record
                    thingsAreDifferent = true; //found a difference
                }
                if (winningRec.Monthly_Installs__c != c.Monthly_Installs__c) { //if the Monthly_Installs__c value is different
                    currentRec.Monthly_Installs__c = winningRec.Monthly_Installs__c; //set the value from the winning record
                    thingsAreDifferent = true; //found a difference
                }
                if (winningRec.Weekly__c != c.Weekly__c) { //if the Weekly__c value is different
                    currentRec.Weekly__c = winningRec.Weekly__c; //set the value from the winning record
                    thingsAreDifferent = true; //found a difference
                }
                if (winningRec.Weekly_Installs__c != c.Weekly_Installs__c) { //if the Weekly_Installs__c value is different
                    currentRec.Weekly_Installs__c = winningRec.Weekly_Installs__c; //set the value from the winning record
                    thingsAreDifferent = true; //found a difference
                }
            }
            if (thingsAreDifferent) { //if something was determined as being changed
                updatedCampaigns.add(currentRec); //add the Campaign to the list for additional processing
            }
        }
        //System.debug('- newBudgetGroups: end -');
        //System.debug('updatedCampaigns.isEmpty(): '+updatedCampaigns.isEmpty());
        //update the campaigns
        if (!updatedCampaigns.isEmpty()) { //if the map is not empty
            TriggerHandler.bypass('campaignTriggerHandler'); //set the bypass so the trigger does not fire during this update
            List<Database.SaveResult> results = Database.update(updatedCampaigns, false); //update the Campaigns and allow for partial failures
            TriggerHandler.clearBypass('campaignTriggerHandler'); //clear the trigger bypass designation
        }
    }
    
    //execute the newBudgetGroups method asynchronously
    @future //future annotation indicates asynchronous execution
    public static void newBudgetGroupsFuture(Set<Id> campaignIds) {
        campaignUtil.newBudgetGroups(campaignIds); //pass the set to the newBudgetGroups method
    }

}
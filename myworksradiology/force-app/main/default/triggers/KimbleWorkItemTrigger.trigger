trigger KimbleWorkItemTrigger on KimbleOne__WorkItem__c (after update) {
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            KimbleWorkItemTriggerHandler.updateEngagementFields(Trigger.oldMap, Trigger.new);
        }
    }
}
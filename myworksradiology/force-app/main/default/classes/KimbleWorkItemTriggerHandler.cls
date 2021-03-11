/* 
 *Description- Changing keyword public with sharing class to public class for requirement in CCR 180
                
  */             

public class KimbleWorkItemTriggerHandler {
    public static void updateEngagementFields(Map<Id, KimbleOne__WorkItem__c> oldMap, List<KimbleOne__WorkItem__c> newList) {
        Set<String> installationDateWorkItems = new Set<String>{'Installation Scheduled', 'Installation', 'CT Study Retrieval'};
        Set<String> trainingDateWorkItems = new Set<String>{'Training Scheduled', 'Training', 'Onsite Training', 'Training Date/Go-Live Date'};
        Set<Id> wiIds = new Set<Id>();
        Map<Id, EngagementTaskWrapper> taskByTaskId = new Map<Id, EngagementTaskWrapper>();
        for(KimbleOne__WorkItem__c wi : newList) {
            if(wi.name != null && (installationDateWorkItems.contains(wi.name) || trainingDateWorkItems.contains(wi.name))) {
                if(wi.BH_US_Start_Date__c != oldMap.get(wi.Id).BH_US_Start_Date__c) {
                    wiIds.add(wi.Id);
                    EngagementTaskWrapper wiTask;
                    if(taskByTaskId.get(wi.KimbleOne__Task__c) == null) {
                        wiTask = new EngagementTaskWrapper();
                        wiTask.taskId=wi.KimbleOne__Task__c;
                    } else {
                        wiTask = taskByTaskId.get(wi.KimbleOne__Task__c);
                    }
                    if(installationDateWorkItems.contains(wi.name)) {
                        wiTask.installationDate = wi.BH_US_Start_Date__c;
                        wiTask.installationDateChanged = true;
                    } else if(trainingDateWorkItems.contains(wi.name)) {
                        wiTask.trainingDateChanged = true;
                        wiTask.trainingDate = wi.BH_US_Start_Date__c;
                    }
                    taskByTaskId.put(wi.KimbleOne__Task__c, wiTask);
                }
            }
        }
        if(!taskByTaskId.isEmpty()) {
            List<KimbleOne__PlanItem__c> piList = [
                SELECT
                    Id, KimbleOne__DeliveryGroup__c, KimbleOne__Task__c
                FROM KimbleOne__PlanItem__c 
                WHERE
                    KimbleOne__Task__c IN :taskByTaskId.keySet()
            ];
            Map<Id, KimbleOne__DeliveryGroup__c> engagementMapToUpdate = new Map<Id, KimbleOne__DeliveryGroup__c>();
            for(KimbleOne__PlanItem__c pi : piList) {
                EngagementTaskWrapper wrapperElem = taskByTaskId.get(pi.KimbleOne__Task__c);
                if(wrapperElem != null) {
                    KimbleOne__DeliveryGroup__c eng;
                    if(engagementMapToUpdate.containsKey(pi.KimbleOne__DeliveryGroup__c)) {
                        eng = engagementMapToUpdate.get(pi.KimbleOne__DeliveryGroup__c);
                    } else {
                        eng = new KimbleOne__DeliveryGroup__c();
                        eng.Id = pi.KimbleOne__DeliveryGroup__c;
                    }
                    if(wrapperElem.installationDateChanged == true) {
                        eng.KC_Device_Installation_Date__c = wrapperElem.installationDate;
                    }
                    if(wrapperElem.trainingDateChanged == true) {
                        eng.KC_Device_Training_Date__c = wrapperElem.trainingDate;
                    }
                    engagementMapToUpdate.put(pi.KimbleOne__DeliveryGroup__c, eng);
                }
            }
            if(!engagementMapToUpdate.isEmpty()) {
                update engagementMapToUpdate.values();
            }
        }
    }

    private class EngagementTaskWrapper {
        String taskId {get; set;}
        String engagementId {get; set;}
        Boolean installationDateChanged {get;set;}
        Date installationDate {get; set;}
        Boolean trainingDateChanged {get; set;}
        Date trainingDate {get; set;}
    }
}
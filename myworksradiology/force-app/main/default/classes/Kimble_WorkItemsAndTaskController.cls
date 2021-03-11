public with sharing class Kimble_WorkItemsAndTaskController {
    
    private static final String STATUS_COMPLETED = 'Completed';
    private static final String STATUS_ON_HOLD = 'OnHold';
    private static final Set<String> exceptionStatusList = new Set<String>{'OnHold', 'Declined', 'NotProvided'};

    private String engagementId;
    private final KimbleOne__DeliveryGroup__c engagement;
    private final KimbleOne__ResourcedActivity__c resourcedActivity;
    private final KimbleOne__TrackingPlan__c trackingPlan;
    private final Map<String, KimbleOne__ReferenceData__c> completionStatusByObj = new Map<String, KimbleOne__ReferenceData__c>();
    private Set<Id> taskIds;
    private Map<String, KimbleOne__PlanTask__c> planTaskByTaskId;
    private Map<String, String> taskIdByPlanTaskId;
    public Boolean result=false;
    private final List<KimbleOne__PlanItem__c> planItems;

    public String engagementName {get; set;}
    public String accountName {get; set;}
    public String pageName {get; set;}
    public List<String> completionStatusValues {get; set;}
    public List<TaskWrapper> tasksList {get; set;}
    Map<Id, TaskWrapper> tasksByIdMap;
    public Map<String, List<WorkItemWrapper>> wiWrapperByTaskId {get; set;}

    public List<KimbleOne__PlanTask__c> planTasks {get; set;}
    
    public Kimble_WorkItemsAndTaskController() {
        //actual code
        String idParam = ApexPages.currentPage().getParameters().get('id');
        if(!String.isBlank(idParam)) {
            engagementId = idParam;
        }else {
            engagementId = 'aEX0V000000fxSqWAI';
        }

        engagement = [
            SELECT 
                Id, Name, KimbleOne__Account__r.name, KimbleOne__ProductGroup__r.Name 
            FROM KimbleOne__DeliveryGroup__c
            WHERE 
                Id = :engagementId
        ];

        engagementName = engagement.name;
        accountName = engagement.KimbleOne__Account__r.name;
        pageName = 'Tasks and Work Items';
        
        //get picklist values for completionStatus
        List<KimbleOne__ReferenceData__c> referenceDataList = [
            SELECT 
                id, name, KimbleOne__Enum__c, KimbleOne__Domain__c, KimbleOne__Description__c 
            FROM KimbleOne__ReferenceData__c 
            WHERE 
                KimbleOne__Domain__c = 'CompletionStatus'
        ];
        for(KimbleOne__ReferenceData__c refObj : referenceDataList) {
            if(completionStatusValues == null) {
                completionStatusValues = new List<String>();
            }
            //completionStatusValues.add(refObj.KimbleOne__Enum__c);
            completionStatusByObj.put(refObj.KimbleOne__Enum__c, refObj);
        }

        //get custom status picklist values
        List<String> customStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KimbleOne__PlanTask__c.BH_US_Status__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry pickListVal : ple){
            completionStatusValues.add(pickListVal.getLabel());
    }

        //get all plan items by sequence order
        planItems = [
            SELECT
                Id, Name, KimbleOne__DisplaySequence__c, KimbleOne__DeliveryGroup__c, KimbleOne__Task__c, KimbleOne__Task__r.Name
            FROM KimbleOne__PlanItem__c 
            WHERE
                KimbleOne__DeliveryGroup__c = :engagementId
            ORDER BY KimbleOne__DisplaySequence__c ASC
        ];
        taskIds = new Set<Id>();
        for(KimbleOne__PlanItem__c pi : planItems) {
            taskIds.add(pi.KimbleOne__Task__c);
        }
        initializePlanTaskAndWorkItemData();
    }
    
    public Boolean getPGroup() {
        result=engagement.KimbleOne__ProductGroup__r.Name.contains('Informatics');
        return result;
    }

    private void initializePlanTaskAndWorkItemData() {
        //get plan-tasks by tasks - this contains all details like start date, end date, baseline, expended, etc 
        List<KimbleOne__PlanTask__c> planTasks = [
            SELECT 
                Id, Name, KimbleOne__Task__c, KimbleOne__Task__r.Name, BH_US_Status__c, BH_US_Start_Date__c, BH_US_End_Date__c, BH_US_Baseline_Effort_Minutes__c,KimbleOne__BaselineEffort__c, BH_US_Expended_Effort__c, BH_US_Remaining_Effort__c, BH_US_Percent_Completed__c,BH_US_Expended_Minutes__c,BH_US_Expended_Hours__c,Expended_Hours__c,KimbleOne__Status__r.KimbleOne__Enum__c
            FROM KimbleOne__PlanTask__c
            WHERE
                KimbleOne__Task__c IN :taskIds
        ];
        planTaskByTaskId = new Map<String, KimbleOne__PlanTask__c>();
        taskIdByPlanTaskId = new Map<String, String>();
        for(KimbleOne__PlanTask__c pt : planTasks) {
            planTaskByTaskId.put(pt.KimbleOne__Task__c, pt);
            taskIdByPlanTaskId.put(pt.id, pt.KimbleOne__Task__c);
        }
        //get work items by task - to-do
        List<KimbleOne__WorkItem__c> workItems = [
            SELECT
                Id, Name, KimbleOne__Task__c, KimbleOne__Notes__c, KimbleOne__Status__r.KimbleOne__Enum__c, BH_US_Start_Date__c, BH_US_End_Date__c, BH_US_Status__c
            FROM KimbleOne__WorkItem__c
            WHERE
                KimbleOne__Task__c IN :taskIds
        ];

        Map<String, List<KimbleOne__WorkItem__c>> workItemsByTaskId = new Map<String, List<KimbleOne__WorkItem__c>>();
        for(KimbleOne__WorkItem__c wi : workItems) {
            if(workItemsByTaskId.get(wi.KimbleOne__Task__c) != null) {
                workItemsByTaskId.get(wi.KimbleOne__Task__c).add(wi);
            } else {
                workItemsByTaskId.put(wi.KimbleOne__Task__c, new List<KimbleOne__WorkItem__c>{wi});
            }
        }

        wiWrapperByTaskId = new Map<String, List<WorkItemWrapper>>();
        for(KimbleOne__WorkItem__c wi : workItems) {
            WorkItemWrapper wiWrapper = new WorkItemWrapper();
            wiWrapper.Id = wi.Id;
            wiWrapper.taskId = wi.KimbleOne__Task__c;
            wiWrapper.name = wi.Name;
            wiWrapper.notes = wi.KimbleOne__Notes__c;
            wiWrapper.startDate = (wi.BH_US_Start_Date__c!=null) ? wi.BH_US_Start_Date__c.year() +'-'+String.valueOf(wi.BH_US_Start_Date__c.month()).leftPad(2, '0')+'-'+String.valueOf(wi.BH_US_Start_Date__c.day()).leftPad(2, '0') : 'dd/mm/yyyy';
            wiWrapper.endDate = (wi.BH_US_End_Date__c!=null) ? wi.BH_US_End_Date__c.year() +'-'+String.valueOf(wi.BH_US_End_Date__c.month()).leftPad(2, '0')+'-'+String.valueOf(wi.BH_US_End_Date__c.day()).leftPad(2, '0') : 'dd/mm/yyyy';
            
            wiWrapper.status = wi.BH_US_Status__c;
            if(wiWrapperByTaskId.get(wi.KimbleOne__Task__c) != null) {
                wiWrapperByTaskId.get(wi.KimbleOne__Task__c).add(wiWrapper);
            } else {
                wiWrapperByTaskId.put(wi.KimbleOne__Task__c, new List<WorkItemWrapper>{wiWrapper});
            }
        }
        //make ordered task list
        tasksList = new List<TaskWrapper>();
        for(KimbleOne__PlanItem__c pi : planItems) {

            if(pi.KimbleOne__Task__c != null) {
                KimbleOne__PlanTask__c pt = planTaskByTaskId.get(pi.KimbleOne__Task__c);
                TaskWrapper tw = new TaskWrapper();
                tw.id = pt.Id;
                tw.taskId = pi.KimbleOne__Task__c;
                tw.taskName = pt.KimbleOne__Task__r.Name;
                tw.baselineEffort = Integer.valueOf(pt.KimbleOne__BaselineEffort__c);
                tw.remainingEffort =  pt.BH_US_Remaining_Effort__c;
                tw.percentCompleted = pt.BH_US_Percent_Completed__c;
                tw.expendedMinutes = (pt.BH_US_Expended_Minutes__c!=null) ? Integer.valueOf(pt.BH_US_Expended_Minutes__c) : 0;
                if(engagement.KimbleOne__ProductGroup__r.Name.contains('Informatics')) {
                    System.debug('In one');
                    System.debug(result);
                    tw.expendedHours = (pt.Expended_Hours__c!=null) ? String.valueOf(pt.Expended_Hours__c) : '0';
                }
                else {
                    System.debug('In Two');
                    tw.expendedHours = pt.BH_US_Expended_Hours__c;
                }
           
                tw.startDate = (pt.BH_US_Start_Date__c!=null) ? pt.BH_US_Start_Date__c.year() +'-'+String.valueOf(pt.BH_US_Start_Date__c.month()).leftPad(2, '0')+'-'+String.valueOf(pt.BH_US_Start_Date__c.day()).leftPad(2, '0') : 'dd/mm/yyyy';
                tw.endDate = (pt.BH_US_End_DAte__c!=null) ? pt.BH_US_End_DAte__c.year() +'-'+String.valueOf(pt.BH_US_End_DAte__c.month()).leftPad(2, '0')+'-'+String.valueOf(pt.BH_US_End_DAte__c.day()).leftPad(2, '0') : 'dd/mm/yyyy';
                tw.status = pt.BH_US_Status__c;
                tw.wiWrapperList = wiWrapperByTaskId.get(pi.KimbleOne__Task__c);
                tasksList.add(tw);
            }
        }
        tasksByIdMap = new Map<Id, TaskWrapper>();
        for(TaskWrapper tw : tasksList) {
            tasksByIdMap.put(tw.id, tw);
        }
    }

    public void saveRecords() {
        Set<Id> completedTaskIds = new Set<Id>();
        Map<String, TaskWrapper> taskWrapperListToUpdate;
        //save plan task records
        String tasksData = Apexpages.currentPage().getParameters().get('tasksData');
        if(!String.isBlank(tasksData)) {
            System.debug('save tasksData records data----' + tasksData);
            try {
                taskWrapperListToUpdate = (Map<String, TaskWrapper>) JSON.deserializeStrict(tasksData, Map<String, TaskWrapper>.class);
            }
            catch(Exception e) {
                
                return;
            }
            System.debug('taskWrapperListToUpdate---' + taskWrapperListToUpdate);
            List<KimbleOne__PlanTask__c> planTaskToUpdate = new List<KimbleOne__PlanTask__c>();
            for(TaskWrapper tw : taskWrapperListToUpdate.values()) {
                KimbleOne__PlanTask__c taskToUpdate = new KimbleOne__PlanTask__c();
                taskToUpdate.id = tw.Id;
                taskToUpdate.BH_US_Expended_Minutes__c  = getDecimalValueFromInt(tw.expendedMinutes);
                if(engagement.KimbleOne__ProductGroup__r.Name.contains('Informatics')) {
                    taskToUpdate.Expended_Hours__c = getDecimalValueFromString(tw.expendedHours);
                    
                }
                else {
                    taskToUpdate.Expended_Hours__c=0;
                }

                taskToUpdate.BH_US_Start_Date__c = getDateValueFromString(tw.startDate);
                taskToUpdate.BH_US_End_DAte__c = getDateValueFromString(tw.endDate);
                
                if(tw.status != null) {
                    if(completionStatusByObj.containsKey(tw.status)) {
                        taskToUpdate.KimbleOne__Status__c = completionStatusByObj.get(tw.status).id;
                    }
                    taskToUpdate.BH_US_Status__c = tw.status;
                }

                planTaskToUpdate.add(taskToUpdate);

                if(tw.status == STATUS_COMPLETED) {
                    completedTaskIds.add(tw.taskId);
                }
            }
            System.debug('plan task list to update----' + planTaskToUpdate);
            if(planTaskToUpdate.size() > 0) {
                try {
                    update planTaskToUpdate;
                } catch(Exception e) {
                    System.debug('Error updating plan task and work item records---' + e.getStackTraceString());
                }
            }
        }
        //save workitem records
        String workItemData = Apexpages.currentPage().getParameters().get('workItemData');
        List<KimbleOne__WorkItem__c> userUpdatedWorkItems;
        List<KimbleOne__WorkItem__c> workItemsToSave;
        if(!String.isBlank(workItemData)) {
            workItemsToSave = new List<KimbleOne__WorkItem__c>();
            System.debug('save workitem  data----' + workItemData);
            Map<String, WorkItemWrapper> workItemWrapperListToUpdate = (Map<String, WorkItemWrapper>) JSON.deserializeStrict(workItemData, Map<String, WorkItemWrapper>.class);
            System.debug('workItemWrapperListToUpdate---' + workItemWrapperListToUpdate);
            userUpdatedWorkItems = new List<KimbleOne__WorkItem__c>();
            for(WorkItemWrapper wi : workItemWrapperListToUpdate.values()) {

                KimbleOne__WorkItem__c wiToUpdate = new KimbleOne__WorkItem__c();
                wiToUpdate.id = wi.Id;
                wiToUpdate.KimbleOne__Task__c = wi.taskId;
                wiToUpdate.KimbleOne__Notes__c = wi.notes;
                wiToUpdate.BH_US_Start_Date__c = getDateValueFromString(wi.startDate);
                wiToUpdate.BH_US_End_Date__c = getDateValueFromString(wi.endDate);
                if(wi.status != null) {
                    if(completionStatusByObj.containsKey(wi.status)) {
                        wiToUpdate.KimbleOne__Status__c = completionStatusByObj.get(wi.status).id;
                    } else {
                        wiToUpdate.KimbleOne__Status__c = null;
                    }
                    wiToUpdate.BH_US_Status__c = wi.status;
                }

                userUpdatedWorkItems.add(wiToUpdate);
            }
            System.debug('work items user updated----' + userUpdatedWorkItems);
        }

        List<KimbleOne__WorkItem__c> systemUpdatedWorkItems;

        if(completedTaskIds.size() > 0) {
            systemUpdatedWorkItems = updateWorkItemStatusToCompleted(completedTaskIds, userUpdatedWorkItems);
        }
        System.debug('work items system updated----' + systemUpdatedWorkItems);

        if(systemUpdatedWorkItems == null || systemUpdatedWorkItems.isEmpty()) {
            workItemsToSave = userUpdatedWorkItems;
        } else {
            workItemsToSave = systemUpdatedWorkItems;
        }
        System.debug('work items to save----' + workItemsToSave);

        if(workItemsToSave != null && !workItemsToSave.isEmpty()) {
            try {
                update workItemsToSave;
            } catch(Exception e) {
                System.debug('Error updating work item records---' + e.getStackTraceString());
            }
        }
        
        initializePlanTaskAndWorkItemData();
    }

    private List<KimbleOne__WorkItem__c> updateWorkItemStatusToCompleted(Set<Id> completedTaskIds, List<KimbleOne__WorkItem__c> userUpdatedWorkItems) {
        List<KimbleOne__WorkItem__c> workItemsStatusUpdated = new List<KimbleOne__WorkItem__c>();
        if(completedTaskIds != null && !completedTaskIds.isEmpty()) {
            List<KimbleOne__WorkItem__c> completedTaskWorkItems;
            
            System.debug('userUpdatedWorkItems ---' + completedTaskWorkItems);
            if(userUpdatedWorkItems == null || userUpdatedWorkItems.isEmpty()) {
                completedTaskWorkItems = [Select Id,KimbleOne__Task__c,BH_US_Status__c from KimbleOne__WorkItem__c where KimbleOne__Task__c IN :completedTaskIds];
            } else {
                Set<Id> userChangedWorkItemIds = new Set<Id>();
                for(KimbleOne__WorkItem__c wi : userUpdatedWorkItems) {
                    userChangedWorkItemIds.add(wi.Id);
                }
                completedTaskWorkItems = [Select Id,KimbleOne__Task__c,BH_US_Status__c from KimbleOne__WorkItem__c where Id NOT IN :userChangedWorkItemIds AND KimbleOne__Task__c IN :completedTaskIds];
                completedTaskWorkItems.addAll(userUpdatedWorkItems);
            }
            
            System.debug('completedTaskWorkItems ---' + completedTaskWorkItems);

            for(KimbleOne__WorkItem__c wi : completedTaskWorkItems) {
                if(wi.KimbleOne__Task__c != null && completedTaskIds.contains(wi.KimbleOne__Task__c)) {
                    if(String.isBlank(wi.BH_US_Status__c) || !exceptionStatusList.contains(wi.BH_US_Status__c)) {
                        wi.KimbleOne__Status__c = completionStatusByObj.get(STATUS_COMPLETED).id;
                        wi.BH_US_Status__c = STATUS_COMPLETED;
                    }
                }
                workItemsStatusUpdated.add(wi);
            }
        }
        return workItemsStatusUpdated;
    }

    private void updateWorkItemStatusToCompleted(Set<Id> completedTaskIds) {
        List<WorkItemWrapper> wiToUpdate = new List<WorkItemWrapper>();
        for(Id taskId : completedTaskIds) {
            if(tasksByIdMap.get(taskId).wiWrapperList != null) {
                wiToUpdate.addAll(tasksByIdMap.get(taskId).wiWrapperList);
            }
        }
        if(wiToUpdate.size() > 0) {
            List<KimbleOne__WorkItem__c> workItemToUpdate = new List<KimbleOne__WorkItem__c>();
            for(WorkItemWrapper wi : wiToUpdate) {
                workItemToUpdate.add(new KimbleOne__WorkItem__c(
                    id = wi.id,
                    KimbleOne__Status__c = completionStatusByObj.get(STATUS_COMPLETED).id,
                    BH_US_Status__c = STATUS_COMPLETED
                ));
            }
            try {
                update workItemToUpdate;
            } catch(Exception e) {
                System.debug('Error updating WorkItem status to completed based on Task complted: ' + e.getStackTraceString());
            }
        }
    }

    public void saveNewWI() {
        String newWorkItem = Apexpages.currentPage().getParameters().get('newWorkItem');
        WorkItemWrapper wiWrapper = (WorkItemWrapper) JSON.deserializeStrict(newWorkItem, WorkItemWrapper.class);
        System.debug('wiWrapper---'+ wiWrapper);
        KimbleOne__WorkItem__c workItem = new KimbleOne__WorkItem__c(
            KimbleOne__Task__c = taskIdByPlanTaskId.get(wiWrapper.taskId),
            Name = wiWrapper.name,
            KimbleOne__Notes__c = wiWrapper.notes,
            KimbleOne__Status__c = completionStatusByObj.get(wiWrapper.status).id
        );
        System.debug('inserting wi---' + workItem);
        try {
            insert workItem;
        } catch(Exception e) {
            System.debug('Error inserting WorkItem----'+ e.getStackTraceString());
        }
    }
    private Date getDateValueFromString(String dtStr) {
        System.debug('dtStr---' + dtStr);
        Date dt;
        try {
            dt = Date.parse(dtStr);
            System.debug('dt---' + dt);
        } catch(Exception e) {
            System.debug('Error converting String to Date locale---' + dtStr);
        }
        if(dt == null) {
            try {
                dt = Date.valueOf(dtStr);
                System.debug('dt---' + dt);
            } catch(Exception e) {
                System.debug('Error converting String to Date value of---' + dtStr);
            }
        }
        return dt;
    }
    private Decimal getDecimalValueFromString(String str) {
        System.debug('Inside mthod getDecimalValueFromString');
        System.debug(str);
        Decimal dec1 = 0;
        try {
            dec1 = Decimal.valueOf(str);
        }catch(Exception e) {
            System.debug('Error converting int to decimal--' + str);
        }
        System.debug(dec1);
        return dec1;
 
    }

    private Decimal getDecimalValueFromInt(Integer intValue) {
        Decimal dec = 0;
        try {
            dec = Decimal.valueOf(intValue);
        }catch(Exception e) {
            System.debug('Error converting int to decimal--' + intValue);
        }
        return dec;
    }
    class TaskWrapper {
        public TaskWrapper() {}
        public String id {get; set;}
        public String taskId {get;set;}
        public String taskName {get; set;}
        public Integer baselineEffort {get; set;}
       // public Integer expendedEffort {get; set;}
        public String remainingEffort {get; set;}
        public Decimal percentCompleted {get; set;}
        public String expendedHours {get; set;}
        public Integer expendedMinutes {get; set;}
        public String startDate {get; set;}
        public String endDate {get; set;}
        public String status {get; set;}
        public List<WorkItemWrapper> wiWrapperList {get; set;}
    }

    class WorkItemWrapper {
        public WorkItemWrapper() {}
        public String id {get; set;}
        public String taskId {get;set;}
        public String name {get; set;}
        public String notes {get; set;}
        public String status {get; set;}
        public String startDate {get;set;}
        public String endDate {get;set;}
    }

    //Redirect page to Engagement Home
    public PageReference redirectToEngagementHome() {
        PageReference pageRef = new PageReference('/' + engagementId);
        System.debug('redirect page reference---' + pageRef);
        // pageRef.setRedirect(true);
        return pageRef;
    }
}
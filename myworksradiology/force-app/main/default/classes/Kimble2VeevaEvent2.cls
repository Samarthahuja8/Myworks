global class Kimble2VeevaEvent2 implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public static string queryforTestClass {get;set;}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       
       if(!Test.isRunningTest()){
            
            // getting parts order line
            /*
         
            Added the condition of SVMXC__Order_Type__c LIKE 'Rental Contract' and SVMXC__Order_Type__c LIKE '%Order w/o DeliveryRI%' for Kimble Phase 2 Requirement Id - H2_025
           
*/

 return Database.getQueryLocator([SELECT Id, name, KimbleOne__StartDate__c,KimbleOne__ForecastP1EndDate__c,
         KimbleOne__ForecastP3EndDate__c,KimbleOne__ForecastUsage__c, BH_US_Type__c,BH_US_Site_Name__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__c, KimbleOne__TotalActualUsage__c, KimbleOne__EntryRemainingUsage__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Clinical_Rep__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__r.name,                                              
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c,
            KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name,                                             
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.id,
           KC_Kimble_to_Veeva__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Account__c,                                    
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Primary_Clinical_Rep_Name__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__Location__r.name,  
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Notes__c,                        
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c,                        
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c,                        
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.id, 
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.SVMXC__Component__c, 
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.BH_US_SM_Superior_Asset_Formula__c,	
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.AccountId,                         
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Sales_Rep_Name__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Service_Rep_Name__c,  
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Strategic_Accounts_Rep_Name__c,                         
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Street__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__City__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__State__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Country__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Zip__c,        
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Latitude__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Longitude__c
          FROM KimbleOne__ActivityAssignment__c WHERE KC_Kimble_to_Veeva__c!=true and createddate >= 2019-08-10T00:00:00+00:00 and KimbleOne__Resource__r.KC_Clinical__c=True  ]);        
         /* and (not (KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name like '%Default%')) 
          and (not (KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name like '%Techcare%'))]);*/
              


 /*
             return Database.getQueryLocator([SELECT Id, name, KimbleOne__StartDate__c,KimbleOne__ForecastP1EndDate__c,KimbleOne__ForecastUsage__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__c, KimbleOne__TotalActualUsage__c, KimbleOne__EntryRemainingUsage__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Clinical_Rep__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__r.name,                                              
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c,
            KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name,                                             
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.id,
           KC_Kimble_to_Veeva__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Account__c,                                    
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Primary_Clinical_Rep_Name__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__Location__r.name,  
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.id, 
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Street__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__City__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__State__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Country__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Zip__c,        
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Latitude__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Longitude__c
          FROM KimbleOne__ActivityAssignment__c WHERE KC_Kimble_to_Veeva__c!=true and KimbleOne__Resource__r.KC_Clinical__c=True and (KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.name like '%P008287077%' or KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.name like '%P704646119%')]);
           */  
       } 
       else{
              return Database.getQueryLocator(queryforTestClass);
       }
    }
   
    /**
     * scope will have only 1 part order line as we are makking call out in the execute method
     */
    global void execute(Database.BatchableContext BC, List<KimbleOne__ActivityAssignment__c> scope){
        system.debug('\n--scope--'+scope);
        if(scope.size()>0)
        {    
        TriggerHandler_AC.processData(scope);
        }    
        
    }
   
    global void finish(Database.BatchableContext BC){
        
        For(cronTrigger ct:[select Id,CronJobDetail.Name, State, NextFireTime, CronJobDetailId from CronTrigger where NextFireTime = Null AND State = 'DELETED' and CronJobDetail.Name like '%Kimble2Veeva Job Started At%' limit 100])
{
    system.abortJob(ct.id);
}   

       
    }
    
    
}
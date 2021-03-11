/***
 * Author: Vishruth Reddy
 * Date: 1/9/2017
 * Description: This class will create kimble proposal,
                All records are processed when part order KC_Proposal_Batch__c is true(default on creation thie field will be true)
                The size of the batch will be 1 so that we have only 1 order process at 1 time.
 */

 
global class KC_KimbleProposal implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public static string queryforTestClass {get;set;}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       
       if(!Test.isRunningTest()){
            
            // getting parts order line
            /*
            Hena T 11/22/2017: 
            Added the condition of SVMXC__Order_Type__c LIKE 'Rental Contract' and SVMXC__Order_Type__c LIKE '%Order w/o DeliveryRI%' for Kimble Phase 2 Requirement Id - H2_025
            */    
             return Database.getQueryLocator([SELECT Id, KC_Proposal_Batch__c ,(Select id,SVMXC__Product__c,Kimble_Propositions__c,Kimble_Milestone__c,Kimble_Product_Type__c,Kimble_Element_Name__c,BH_US_SM_Qty_Ordered__c,SVMXC__RMA_Shipment_Order__c,SVMXC__RMA_Shipment_Order__r.BH_US_SM_PO__c,SVMXC__Serial_Number__c from SVMXC__RMA_Shipment_Line__r ) from SVMXC__RMA_Shipment_Order__c where RecordTypeId = '012d0000000lICM' AND(SVMXC__Order_Type__c LIKE '%Service and Maint.%' OR SVMXC__Order_Type__c LIKE '%BOMThirdParty Order%' OR SVMXC__Order_Type__c LIKE '%LSc Extensive Order%' OR SVMXC__Order_Type__c LIKE '%Rental Contract%' OR SVMXC__Order_Type__c LIKE '%YLOL%' OR SVMXC__Order_Type__c LIKE '%Order w/o DeliveryRI%') AND KC_Proposal_Batch__c = true ]);
              
       }
       else{
              return Database.getQueryLocator(queryforTestClass);
       }
    }
   
    /**
     * scope will have only 1 part order line as we are makking call out in the execute method
     */
    global void execute(Database.BatchableContext BC, List<SVMXC__RMA_Shipment_Order__c> scope){
        system.debug('\n--scope--'+scope);
        
        // this will save part order lins to be updated
        list<sobject> lstUpdate = new list<sobject>();
        
        
        
        for(SVMXC__RMA_Shipment_Order__c partorder : scope){
            System.debug('parts order scope-----' + partOrder);
            // creating instance to update kimble parts order update
            SVMXC__RMA_Shipment_Order__c rec = new SVMXC__RMA_Shipment_Order__c();
            rec.KC_Proposal_Batch__c = false;
            rec.id = partorder.Id;
            lstUpdate.add(rec);
            
            //checking if the order has part orders lines
            if(!partorder.SVMXC__RMA_Shipment_Line__r.isEmpty()){
                System.debug('parts order with line-----' + partOrder);
                // updating kimble proposition and product type
                List<SVMXC__RMA_Shipment_Line__c> lstLines = KC_PartOrderLineHelperClass.updateKimbleProposition(partorder.SVMXC__RMA_Shipment_Line__r);
                
                //PS20201008 START Added Code for CCR 200 
                //lstLines = KC_PartsOrderMaterialsProcessor_PS01.processOrderMaterials(lstLines);
                //PS20201008 END Added Code for CCR 200 
                
                // method for calling unique name
                lstLines = KC_PartOrderLineHelperClass.updateKimbleElementName(lstLines);
                system.debug('\n--lstLines--'+lstLines);
                
                // adding to list to be updated 
                lstUpdate.addAll((sobject[]) lstLines);

                // making callout
                KC_PartOrderLineHelperClass.proposalOperation(lstLines, null,false);
                
            }
        }
        system.debug('\n--lstUpdate--'+lstUpdate);
        
        if(!lstUpdate.isEmpty()){
            update lstUpdate;
        }
    }
   
    global void finish(Database.BatchableContext BC){
       
    }
    
    
}
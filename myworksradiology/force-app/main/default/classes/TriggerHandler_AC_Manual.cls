public class TriggerHandler_AC_Manual {
  //@future
  public static void processData(String jsonString){
     //  public static void processData(){
       List<KimbleOne__ActivityAssignment__c> activityAssignmengtList = (List<KimbleOne__ActivityAssignment__c>)Json.deserialize(jsonString,List<KimbleOne__ActivityAssignment__c>.class);
    
       Map<id,KimbleOne__DeliveryGroup__c> LstDE1 ;
    List<EM_Event_vod__c> lve= new List<EM_Event_vod__c>();
    Set<id> lstDE = New Set<id>();
    String vename;
    String LocationAddress;
    for(KimbleOne__ActivityAssignment__c acs1:activityAssignmengtList){
        lstDE.add(acs1.id);     
    }
    system.debug('Set Id +==='+lstDE);   
      map<id,KimbleOne__ActivityAssignment__c> mapActivityAssignmentDetails = 
          new map<id,KimbleOne__ActivityAssignment__c>([SELECT Id, KimbleOne__StartDate__c,KimbleOne__ForecastP1EndDate__c,KimbleOne__ForecastUsage__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__c, KimbleOne__TotalActualUsage__c, KimbleOne__EntryRemainingUsage__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Clinical_Rep__c,
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__r.name,                                              
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c,
            KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name,                                             
          KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID,
           KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.id,
           
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
          FROM KimbleOne__ActivityAssignment__c WHERE ID IN:lstDE and KimbleOne__Resource__r.KC_Clinical__c=True and (NOT createdby.name like '%Kimble Machine%')]);
 // CPU Limit error    system.debug('Query____'+mapActivityAssignmentDetails.values()); 
/*  LstDE1 = [Select id,KimbleOne__Account__c, KimbleOne__ProductGroup__c,
              KimbleOne__ProductGroup__r.id,OwnerID, 
              Primary_Clinical_Rep_Name__c,KC_Clinical_Rep__c from KimbleOne__DeliveryGroup__c 
              where id IN: lstDE];*/
    //for(KimbleOne__DeliveryGroup__c DE:LstDE1){
    for(KimbleOne__ActivityAssignment__c acs:mapActivityAssignmentDetails.values()){
           EM_Event_vod__c ve= new EM_Event_vod__c();
            ve.BH_US_Delivery_Engagement__c= acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__c;
            ve.Activity_Assignment__c= acs.id;
            Integer d = acs.KimbleOne__StartDate__c.day();
            Integer mo = acs.KimbleOne__StartDate__c.month();
            Integer yr = acs.KimbleOne__StartDate__c.year();
            if (acs.KimbleOne__StartDate__c==null)
            {
             yr = Date.Today().Year()+10;   
            }
             
             DateTime DT = DateTime.newInstance(yr, mo, d,06, 00, 00);
        system.debug('String.valueOf(acs.KimbleOne__EntryRemainingUsage__c)'+String.valueOf(acs.KimbleOne__EntryRemainingUsage__c));
        system.debug('String.valueOf(acs.KimbleOne__TotalActualUsage__c)'+String.valueOf(acs.KimbleOne__TotalActualUsage__c));
             ve.BH_US_Expected_duration__c=  String.valueOf(acs.KimbleOne__EntryRemainingUsage__c);
            ve.BH_US_Actual_Duration__c=String.valueof(acs.KimbleOne__TotalActualUsage__c);
            ve.Start_Time_vod__c=DT;
            ve.BH_US_Event_Manager__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID;
            ve.Event_Configuration_vod__c='a670m000000UsbzAAC';
              Integer de = acs.KimbleOne__ForecastP1EndDate__c.day();
            Integer moe = acs.KimbleOne__ForecastP1EndDate__c.month();
            Integer yre = acs.KimbleOne__ForecastP1EndDate__c.year();
            if (acs.KimbleOne__ForecastP1EndDate__c==null)
            {
             yre = Date.Today().Year()+10;   
            }
         
            ve.End_Time_vod__c= DateTime.newInstance(yre, moe, de,22, 00, 00);
            ve.Country_vod__c='a60d000000000Y4AAI';
            ve.RecordTypeId='0120m000000frzpAAA';
            vename=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__r.name+
                '-'+ string.valueOfGmt(DT)+
                (acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c==null ?
                '':('-'+acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name));
              
            if(vename.length()>75)
                ve.name=vename.substring(0,75);
            else
                ve.name=vename;
        //ve.name='Tarun Test 23';
            ve.BH_US_Type__c='In-service';
            ve.BH_US_Account__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c;
            ve.BH_US_KimProduct_Group__c = acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c;
            ve.OwnerID =acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID;
            ve.BH_US_Primary_Clinical_Rep__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Primary_Clinical_Rep_Name__c;
            ve.BU_US_Primary_Clinical_Rep_Territory__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Clinical_Rep__c;          
            ve.BH_US_Geolocation_del__Latitude__s=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Latitude__c;
            ve.BH_US_Geolocation_del__Longitude__s=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Longitude__c;
            //ve.Location_Address_vod__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__Location__r.name;
            if((acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c!=null))
            {
                if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.id==acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c)
                {
                 ve.BH_US_Location__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.id;
                 } 
            }    
         // CPU Limit error   System.debug('--------address----'+acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__City__c);    
        LocationAddress = acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Street__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__City__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__State__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Country__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Zip__c;
      // CPU Limit error   System.debug('-------Full-address----'+LocationAddress);    
        if(LocationAddress.length()>0){
           //CPU Limit error System.debug('-------Full-address-1---'+LocationAddress);
            ve.Location_Address_vod__c=LocationAddress;
           // CPU Limit error System.debug('-------Full-address-2---'+ve.Location_Address_vod__c);
            }
            lve.add(ve);
      // CPU Limit error       system.debug('List  VE<<<<<<<'+ve);
    }
    //}
 // CPU Limit error    system.debug('List <<<<<<<'+lve);
    if(lve.size()>0){
        insert lve; 
    }
}

       
       
   }
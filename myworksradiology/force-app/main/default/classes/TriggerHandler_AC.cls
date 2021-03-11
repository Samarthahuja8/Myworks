public class TriggerHandler_AC {
 // @future
   public static void processData( List<KimbleOne__ActivityAssignment__c> activityAssignmengtList){
    List<EM_Event_Configuration_vod__c> Event=[select id from EM_Event_Configuration_vod__c where Event_Type_vod__c ='Project_Training_Event' limit 1]; 
    List<Country_vod__c> Country =[select id,name from Country_vod__c where name='US' limit 1];
    List<RecordType> RecTypeId=new List<RecordType>();
//  List<RecordType> RecTypeId = [SELECT Id FROM RecordType WHERE SobjectType='EM_Event_vod__c' and DeveloperName='Project_Training_Event' LIMIT 1];
     //  List<KimbleOne__ActivityAssignment__c> activityAssignmengtList = (List<KimbleOne__ActivityAssignment__c>)Json.deserialize(jsonString,List<KimbleOne__ActivityAssignment__c>.class);
    list<KimbleOne__ActivityAssignment__c> toUpdateAClist=new List<KimbleOne__ActivityAssignment__c>();
       Map<id,KimbleOne__DeliveryGroup__c> LstDE1 ;
    List<EM_Event_vod__c> lve= new List<EM_Event_vod__c>();
    Set<id> lstDE = New Set<id>();
    String vename;
    String prGroup, prGroupShort;  
    String accName, accNameShort;   
    String sapNum='';
    String LocationAddress;
   /* for(KimbleOne__ActivityAssignment__c acs1:activityAssignmengtList){
        lstDE.add(acs1.id);     
    }
    system.debug('Set Id +==='+lstDE);   
      map<id,KimbleOne__ActivityAssignment__c> mapActivityAssignmentDetails = 
          new map<id,KimbleOne__ActivityAssignment__c>([SELECT Id, KimbleOne__StartDate__c,KimbleOne__ForecastP1EndDate__c,KimbleOne__ForecastP3EndDate__c,KimbleOne__ForecastUsage__c,
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
          FROM KimbleOne__ActivityAssignment__c WHERE ID IN:lstDE and KimbleOne__Resource__r.KC_Clinical__c=True]);
 // CPU Limit error    system.debug('Query____'+mapActivityAssignmentDetails.values());
/*  LstDE1 = [Select id,KimbleOne__Account__c, KimbleOne__ProductGroup__c,
              KimbleOne__ProductGroup__r.id,OwnerID, 
              Primary_Clinical_Rep_Name__c,KC_Clinical_Rep__c from KimbleOne__DeliveryGroup__c 
              where id IN: lstDE];*/
    //for(KimbleOne__DeliveryGroup__c DE:LstDE1){
      //************New IP Relted list logic*************************
     
    set<id> PartsOrderId = new Set<Id>();
      List<Case> caseList=new List<Case>();
      for(KimbleOne__ActivityAssignment__c acs:activityAssignmengtList)
      {
          if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c!=null)
          {
          PartsOrderId.add(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c);
          }
      }
      system.debug('Size *****************'+PartsOrderId.size());
      system.debug('system.debug *************** *****************'+PartsOrderId);
      if(PartsOrderId!=null)
      {
        caseList=[select id,SVMXC__Component__r.SVMXC__Company__c, SVMXC__Component__c, BH_US_SM_Superior_Asset_Formula__c,BH_US_SM_Order__c from Case where BH_US_SM_Superior_Asset_Formula__c= true and BH_US_SM_Order__c in: PartsOrderId ];
             
      }
      

      //************New IP Relted list logic ends*************************
      
       
    for(KimbleOne__ActivityAssignment__c acs:activityAssignmengtList){
           acs.KC_Kimble_to_Veeva__c=true;
           EM_Event_vod__c ve= new EM_Event_vod__c();           
            ve.BH_US_Delivery_Engagement__c= acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__c;
            ve.Activity_Assignment__c= acs.id;  
            ve.BH_US_Send_Closed_Notification_to_Reps__c=true;
                  
            
                  if(acs.BH_US_Site_Name__c!=null)
        {
        ve.BH_US_Site_Name__c=acs.BH_US_Site_Name__c;
        }
        
            Integer d,mo,yr;
            if(acs.KimbleOne__StartDate__c!=null)
            {   
             d = acs.KimbleOne__StartDate__c.day();
             mo = acs.KimbleOne__StartDate__c.month();
             yr = acs.KimbleOne__StartDate__c.year();
            }    
            else
            {
                d=Date.today().day();
                mo=Date.today().month();
                yr = Date.Today().Year()+10;   
            }
             
            // DateTime DT = DateTime.newInstance(yr, mo, d, 08, 00, 00);
         DateTime DT = DateTime.newInstance(yr, mo, d, 04, 00, 00);//TG
        system.debug('String.valueOf(acs.KimbleOne__EntryRemainingUsage__c)'+String.valueOf(acs.KimbleOne__EntryRemainingUsage__c));
        system.debug('String.valueOf(acs.KimbleOne__TotalActualUsage__c)'+String.valueOf(acs.KimbleOne__TotalActualUsage__c));
             ve.BH_US_Expected_duration__c=  String.valueOf(acs.KimbleOne__EntryRemainingUsage__c);
            ve.BH_US_Actual_Duration__c=String.valueof(acs.KimbleOne__TotalActualUsage__c);
            ve.Start_Time_vod__c=DT;
            ve.BH_US_Event_Manager__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID;
            If(Event!=null && !Event.IsEmpty()) 
            {
            ve.Event_Configuration_vod__c=Event[0].id;
             }
            Integer de, moe, yre;
            if (acs.KimbleOne__ForecastP1EndDate__c!=null)
            {
               de = acs.KimbleOne__ForecastP1EndDate__c.day();
             moe = acs.KimbleOne__ForecastP1EndDate__c.month();
             yre = acs.KimbleOne__ForecastP1EndDate__c.year();
            } 
              else if(acs.KimbleOne__ForecastP3EndDate__c!=null)
            {
            de = acs.KimbleOne__ForecastP3EndDate__c.day();
             moe = acs.KimbleOne__ForecastP3EndDate__c.month();
             yre = acs.KimbleOne__ForecastP3EndDate__c.year();
            }   
            else 
            {
                de=Date.today().day();
                moe=Date.today().month();
                yre = Date.Today().Year()+10;   
            }
         
          //  ve.End_Time_vod__c= DateTime.newInstance(yre, moe, de,22, 00, 00);
        //  ve.End_Time_vod__c= DateTime.newInstance(yr, mo, d, 09, 00, 00);
        ve.End_Time_vod__c= DateTime.newInstance(yr, mo, d, 05, 00, 00);  // TG
      //  ve.BH_US_Kimble_Notes__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Notes__c;
            If(Country!=null && !Country.IsEmpty()) {
            ve.Country_vod__c=Country[0].id;
            }
            // New code for new Arterion record type
            if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.Name=='Arterion Implementation') {
                RecTypeId = [SELECT Id FROM RecordType WHERE SobjectType='EM_Event_vod__c' and DeveloperName='Project_Training_Event_Arterion' LIMIT 1];
            }
            else {
                RecTypeId = [SELECT Id FROM RecordType WHERE SobjectType='EM_Event_vod__c' and DeveloperName='Project_Training_Event' LIMIT 1];
            }
            If(RecTypeId!=null && !RecTypeId.IsEmpty()) {
            ve.RecordTypeId=RecTypeId[0].id;
            }
          /*  vename=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__r.name+
                '-'+ string.valueOfGmt(DT)+
                (acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c==null ?
                '':('-'+acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name));
          */ 
          if((acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c!=null))
            {
                
                
              //Phase 2 start
                 //
                 /*
                if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__c !=null)
                {
                    if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.SVMXC__Component__c !=null)
                {
                    system.debug('Superior Asset : - '+acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.BH_US_SM_Superior_Asset_Formula__c);
                    system.debug('DE Account :- '+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c);
                    system.debug('Case Account '+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.AccountId);
                    //(Veeva Event: Account ID EQUALS Installed Product: Account ID) AND (Installed Product: Superior AssetEQUALSTrue)
                   //KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.BH_US_SM_Superior_Asset_Formula__c,    
          //KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.Account,
                    if((acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.BH_US_SM_Superior_Asset_Formula__c) && (acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c==acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.AccountId))
                       {
                    ve.BH_US_Installed_Product__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.SVMXC__Case__r.SVMXC__Component__c;
                
                       }
                                        
                }
               }*/
                Id ip;
                for(case c:caseList)
                {   system.debug('Test1');
                    if(c.SVMXC__Component__c!=null)                    
                {   system.debug('Test2');
                    if((c.SVMXC__Component__r.SVMXC__Company__c!=null)&&(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c!=null))
                {   system.debug('Test3');
                    if((c.BH_US_SM_Order__c==acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c)
                       &&(c.SVMXC__Component__r.SVMXC__Company__c==acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c)
                        )
                    {
                        system.debug('Test4');
                      ip=c.SVMXC__Component__c;
                    }
                }
                }
                }
                if(ip!=null)
                {
                    ve.BH_US_Installed_Product__c=ip;
                }
                
                
                //Phase 2 ends 
                
                if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c!=null)
                {
                    sapNum=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c;
                }
            } 
        prGroup=  (acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c==null ?
                '':('-'+acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__r.name));
        //TG
        if(prGroup.contains('Devices'))
       { prGroup= 'Device Add On'; 
       }
        
        if(prGroup=='Informatics Implementation')
       { prGroup= 'Informatics Add On'; 
       }
        //TG ends
       if(prGroup.contains('Implementation'))
       { prGroupShort= prGroup.substring(0, prGroup.indexOf(' Implementation')); 
       }
        else 
        {
          prGroupShort= prGroup;  
        }
        accName=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__r.name;
         if(accName.length()>45)
                accNameShort=accName.substring(0,45);
            else
                accNameShort=accName;
         vename=accNameShort+'-'+ sapNum  +'-'+prGroupShort;
        
            if(vename.length()>75)
                ve.name=vename.substring(0,75);
            else
                ve.name=vename;
        //ve.name='Tarun Test 23';
        if (acs.name.contains('#Generic - 1_Clinical Informatics Resource for Clinical Kickoff'))
        {
            ve.BH_US_Type__c='Kickoff';
        }
        else if(acs.name.contains('#Generic - 2_Clinical Informatics Resource Kickoff Prep & Support'))
        {
            ve.BH_US_Type__c='Kickoff  Prep & Support';
        }
        else if(acs.name.contains('#Generic - 3_Clinical Informatics Resource for LOE'))
        {
            ve.BH_US_Type__c='LOE';
        }
        else if(acs.name.contains('#Generic - 4_Clinical Informatics Resource LOE Prep & Support'))
        {
            ve.BH_US_Type__c='LOE Prep & Support';
        }
        else if(acs.name.contains('#Generic - 6_Clinical Informatics Resource Onsite Prep & Support'))
        {
            ve.BH_US_Type__c='Onsite Prep & Support';
        }
        else if(acs.name.contains('#Generic - Virtual Training'))
        {
            ve.BH_US_Type__c='Virtual Training';
        }
        else if(acs.BH_US_Type__c!=null)
        { 
            if(acs.BH_US_Type__c=='Virtual Training')
        {
            ve.BH_US_Type__c='Virtual Training';
        }
            else if(acs.BH_US_Type__c=='Kickoff')
        {
            ve.BH_US_Type__c='Kickoff';
        }
              else if(acs.BH_US_Type__c=='Kickoff Prep & Support')
        {
            ve.BH_US_Type__c='Kickoff Prep & Support';
        }
              else if(acs.BH_US_Type__c=='LOE')
        {
            ve.BH_US_Type__c='LOE';
        }
              else if(acs.BH_US_Type__c=='LOE Prep & Support')
        {
            ve.BH_US_Type__c='LOE Prep & Support';
        }
              else if(acs.BH_US_Type__c=='Onsite Prep & Support')
        {
            ve.BH_US_Type__c='Onsite Prep & Support';
        }
              else if(acs.BH_US_Type__c=='Onsite')
        {
            ve.BH_US_Type__c='Onsite';
        }
        }
        else        
        { 
        ve.BH_US_Type__c='Onsite';
        }
        
        if(acs.BH_US_Type__c!=null)
        {
            if((acs.BH_US_Type__c=='Kickoff') || (acs.BH_US_Type__c=='LOE') )
            {
                ve.Start_Time_vod__c= DateTime.newInstance(yr, mo, d, 04, 00, 00);
            ve.End_Time_vod__c= DateTime.newInstance(yre, moe, de, 05, 00, 00);
                
            }
        }
        
            ve.BH_US_Account__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c;
            ve.BH_US_KimProduct_Group__c = acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__ProductGroup__c;
            ve.OwnerID =acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.OwnerID;
            ve.BH_US_Primary_Clinical_Rep__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Primary_Clinical_Rep_Name__c;
            ve.BU_US_Primary_Clinical_Rep_Territory__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KC_Clinical_Rep__c;          
            
          //Phase 2 
     if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Sales_Rep_Name__c!=null)
     {
         ve.BH_US_Sales_Rep__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Sales_Rep_Name__c;
     }
          if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Service_Rep_Name__c!=null)
     {
         ve.BH_US_Service_Rep__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Service_Rep_Name__c;
     }
             if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Strategic_Accounts_Rep_Name__c!=null)
     {
         ve.BH_US_Strategic_Accounts_Rep__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.Strategic_Accounts_Rep_Name__c;
     }
        
        //Phase 2 ends
       
        
        if((acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c!=null))
            {
                                if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c!=null)
                {
                    ve.BH_US_SAP_Order__c = acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c;   
                }
                ve.BH_US_Parts_Order__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c;
            }
        
        
        if(ve.BH_US_Type__c=='Onsite')
        {
            
            ve.Start_Time_vod__c= DateTime.newInstance(yr, mo, d, 06, 00, 00);
            ve.End_Time_vod__c= DateTime.newInstance(yre, moe, de,22, 00, 00);
            
             if((acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c!=null))
            {
                      /*          if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c!=null)
                {
                    ve.BH_US_SAP_Order__c = acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SAP_Order__c;   
                }
                ve.BH_US_Parts_Order__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__c;
            */
                ve.BH_US_Geolocation_del__Latitude__s=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Latitude__c;
            ve.BH_US_Geolocation_del__Longitude__s=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Longitude__c;
            //ve.Location_Address_vod__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__Location__r.name;
            if(acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Account__c==acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Account__c)
                {
                ve.BH_US_Location__c=acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.id;
                }
                    // CPU Limit error   System.debug('--------address----'+acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__City__c);    
        LocationAddress = acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Street__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__City__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__State__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Country__c +','+ acs.KimbleOne__ResourcedActivity__r.KimbleOne__DeliveryGroup__r.KimbleOne__Proposal__r.KC_Parts_Order__r.BH_US_SM_End_User__r.SVMXC__Zip__c;
      // CPU Limit error   System.debug('-------Full-address----'+LocationAddress);    
         if (LocationAddress!=null)  
      {
                if(LocationAddress.length()>0){
           //CPU Limit error System.debug('-------Full-address-1---'+LocationAddress);
            ve.Location_Address_vod__c=LocationAddress;
           // CPU Limit error System.debug('-------Full-address-2---'+ve.Location_Address_vod__c);
            }
      }
            }
        }
            lve.add(ve);
            toUpdateAClist.add(acs);
      // CPU Limit error       system.debug('List  VE<<<<<<<'+ve);
    }
    //}
 // CPU Limit error    system.debug('List <<<<<<<'+lve);
    if(lve.size()>0){
        insert lve; 
        update toUpdateAClist;
    }
}

       
       
   }
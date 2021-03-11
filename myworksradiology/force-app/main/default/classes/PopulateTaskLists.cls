/***
 * Author: Samarth Ahuja
 * Date: 7/24/2020
 * Description: This class populates the value of start date of Veeva Event to Kimble Work item start date.
                This class is executed from the Process builder Populate Task List.
                   
 */

public class PopulateTaskLists {
    @InvocableMethod
    public static void updateTaskFields(List<EM_Event_vod__c> Vevent) {
        System.debug('Inside Method update');
        if(Vevent.size()==0 || Vevent[0].Start_Time_vod__c==null) {
            return;
        }
        Boolean temp=false;
        List<KimbleOne__WorkItem__c> witemlist1=new List<KimbleOne__WorkItem__c>();
        Set<Id> pid=new Set<Id>();
        Set<Id> pid1=new Set<id>();
        Set<Id> pid2=new Set<Id>();
        //Set<String> trainingDateWorkItems = new Set<String>{'Training Scheduled', 'Training', 'Onsite Training', 'Training Date/Go-Live Date'};
        for(EM_Event_vod__c ev :Vevent) {
                Id dg=ev.BH_US_Delivery_Engagement__c;
                System.debug('dg-->'+dg);
                pid.add(dg);
                System.debug('pId-->'+pid);
                 
        }
        List<KimbleOne__DeliveryGroup__c> deng=[Select ID,name,KimbleOne__ProductGroup__c,KimbleOne__ProductGroup__r.Name, KimbleOne__Proposal__c, KimbleOne__Proposal__r.KimbleOne__Proposition__c from KimbleOne__DeliveryGroup__c where ID IN :pid];
        for(KimbleOne__DeliveryGroup__c d1: deng) {
            pid2.add(d1.KimbleOne__Proposal__r.KimbleOne__Proposition__c);
        }
        List<KimbleOne__Proposition__c> kp=[Select id,Name from KimbleOne__Proposition__c where id IN :pid2];
        List<KimbleOne__PlanItem__c> pitemlist=[Select id, name, KimbleOne__DeliveryGroup__c, KimbleOne__Task__c from KimbleOne__PlanItem__c where KimbleOne__DeliveryGroup__c IN :pid];
        for(KimbleOne__PlanItem__c p: pitemlist) {
            Id ts1=p.KimbleOne__Task__c;
            System.debug('ts1-->'+ts1);
            pid1.add(ts1);
            System.debug('Task ID-->'+pid1); 
        }
        
        List<KimbleOne__WorkItem__c> witemlist=[Select id, name, BH_US_Start_Date__c, KimbleOne__Task__c from KimbleOne__WorkItem__c where KimbleOne__Task__c IN :pid1];
        System.debug('Work Item-->'+witemlist);
        
        for(KimbleOne__DeliveryGroup__c d: deng) {
       
            if(d.KimbleOne__ProductGroup__r.Name=='Devices Implementation' || d.KimbleOne__ProductGroup__r.Name=='Arterion Implementation' || d.KimbleOne__ProductGroup__r.Name=='Flex Implementation' || d.KimbleOne__ProductGroup__r.Name=='Solaris Implementation' || d.KimbleOne__ProductGroup__r.Name=='Stellant Implementation' || d.KimbleOne__ProductGroup__r.Name=='MRX Implementation' || d.KimbleOne__ProductGroup__r.Name=='Intego Implementation' || d.KimbleOne__ProductGroup__r.Name=='TechCARE' || kp[0].Name=='Device Add On' ) {  
                 for(KimbleOne__WorkItem__c w: witemlist) {
                    if(w.name != null && (w.name).equals('Training Scheduled')) {
                        witemlist1.add(w);
                        System.debug('Work Item1-->'+witemlist1);
                        temp=true;
                    }
                 }
            
                
            }
            else if(d.KimbleOne__ProductGroup__r.Name=='MRX w/Informatics' || d.KimbleOne__ProductGroup__r.Name=='Flex W Informatics Implementation' || d.KimbleOne__ProductGroup__r.Name=='Certegra w/Stellant' || d.KimbleOne__ProductGroup__r.Name=='Certegra Implementation') {
                Set<String> wkitem= new Set<String>{'Training'};
                 for(KimbleOne__WorkItem__c w: witemlist) {
                    if(w.name != null && wkitem.contains(w.Name)) {
                        witemlist1.add(w);
                        System.debug('Work Item1-->'+witemlist1);
                        temp=true;
                    }
                 }
                
            }
            else if(kp[0].Name=='Informatics Add On') {
                Set<String> wkitem= new Set<String>{'Training Date/Go-Live Date'};
                   for(KimbleOne__WorkItem__c w: witemlist) {
                    if(w.name != null && wkitem.contains(w.Name)) {
                        witemlist1.add(w);
                        System.debug('Work Item1-->'+witemlist1);
                        temp=true;
                    }
                 }
                
            }
          /*  else if(kp[0].Name=='RDM' || kp[0].Name=='CDM') {
                if(Vevent[0].BH_US_Type__c=='Onsite') {
                    Set<String> wkitem= new Set<String>{'Onsite Training'};
                    for(KimbleOne__WorkItem__c w: witemlist) {
                        if(w.name != null && wkitem.contains(w.Name)) {  
                            witemlist1.add(w);
                            System.debug('Work Item1-->'+witemlist1);
                            temp=true;
                        }
                    }
                    
                }
                
            } */

                
           
         }
        
        if(witemlist1.size()>0 && temp) {
                 for(KimbleOne__WorkItem__c w: witemlist1) {
                    DateTime dt = Vevent[0].Start_Time_vod__c;
                    DateTime dt1 = Vevent[0].End_Time_vod__c;
                    System.debug('dt-->'+dt);
                    w.BH_US_Start_Date__c=dt.date();
                    w.BH_US_End_Date__c=dt1.date();
                    System.debug('w.BH_US_Start_Date__c-->'+w.BH_US_Start_Date__c);
                 }
                 update witemlist1; 
        }
            
    }

}
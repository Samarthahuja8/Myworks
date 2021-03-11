/***
 * Author: Samarth Ahuja
 * Date: 7/24/2020
 * Description: This class populates the value of scheduled date on Work Order to Kimble Work item start date.
                This class is executed from the Process builder Populate Task List for WO.                 
 */


public class PopulateTaskListforWO {
    @InvocableMethod
    public static void updateTaskFieldsforWO(List<SVMXC__Service_Order__c> wolist) {
        System.debug('Inside Method update for WO');
        if(wolist.size()==0 || wolist[0].SVMXC__Scheduled_Date_Time__c==null) {
            return;
        } 
        Boolean temp=false;
        List<KimbleOne__WorkItem__c> witemlist1=new List <KimbleOne__WorkItem__c>();
        List<Case> cslist=new List<Case>();
        Set<Id> pidcs=new Set<Id>();
        Set<Id> pid1=new Set<id>();
        Set<Id> pid=new Set<id>();
        Set<Id> pid2=new Set<Id>();
      //  Set<String> installationDateWorkItems = new Set<String>{'Installation Scheduled', 'Installation', 'CT Study Retrieval'};
            for(SVMXC__Service_Order__c wo :wolist) {
                Id cs=wo.SVMXC__Case__c;
                System.debug('cs-->'+cs);
                pidcs.add(cs);
                System.debug('pIdcs-->'+pidcs);
                 
            }
        cslist=[Select id, BH_US_Kimble_Engagement__c from Case where Id IN :pidcs];
        for(Case c: cslist ) {
            Id dg=c.BH_US_Kimble_Engagement__c;
            pid.add(dg);
            System.debug('Engagement id-->'+pid);
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

            if(d.KimbleOne__ProductGroup__r.Name=='Devices Implementation' || d.KimbleOne__ProductGroup__r.Name=='Arterion Implementation' || d.KimbleOne__ProductGroup__r.Name=='Flex Implementation' || d.KimbleOne__ProductGroup__r.Name=='Solaris Implementation' || d.KimbleOne__ProductGroup__r.Name=='Stellant Implementation' || d.KimbleOne__ProductGroup__r.Name=='MRX Implementation' || d.KimbleOne__ProductGroup__r.Name=='Intego Implementation' || d.KimbleOne__ProductGroup__r.Name=='TechCARE' || kp[0].Name=='Device Add On') { 
                for(KimbleOne__WorkItem__c w: witemlist) {
                    if(w.name != null && (w.name).equals('Installation Scheduled')) {
                        witemlist1.add(w);
                        System.debug('Work Item1-->'+witemlist1);
                        temp=true;
                    }
                }
                
            }
            else if(d.KimbleOne__ProductGroup__r.Name=='MRX w/Informatics' || d.KimbleOne__ProductGroup__r.Name=='Flex W Informatics Implementation' || d.KimbleOne__ProductGroup__r.Name=='Certegra w/Stellant' || d.KimbleOne__ProductGroup__r.Name=='Certegra Implementation') {
                Set<String> wkitem= new Set<String>{'Installation'};
                 for(KimbleOne__WorkItem__c w: witemlist) {
                    if(w.name != null && wkitem.contains(w.Name)) {
                        witemlist1.add(w);
                        System.debug('Work Item1-->'+witemlist1);
                        temp=true;
                    }
                 }
                
            }
            else if(kp[0].Name=='Informatics Add On') {
                Set<String> wkitem= new Set<String>{'System Integrations Install date'};
                   for(KimbleOne__WorkItem__c w: witemlist) {
                    if(w.name != null && wkitem.contains(w.Name)) {
                        witemlist1.add(w);
                        System.debug('Work Item1-->'+witemlist1);
                        temp=true;
                    }
                 }
                
            }
          /*  else if(kp[0].Name=='RDM' || kp[0].Name=='CDM') {
                    Set<String> wkitem= new Set<String>{'CT Study Retrieval'};
                    for(KimbleOne__WorkItem__c w: witemlist) {
                        if(w.name != null && wkitem.contains(w.Name)) {  
                            witemlist1.add(w);
                            System.debug('Work Item1-->'+witemlist1);
                            temp=true;
                        }
                    }
                    
                
            }        */    

            
        }
        if(witemlist1.size()>0 && temp) {
                 for(KimbleOne__WorkItem__c w: witemlist1) {
                    DateTime dt= wolist[0].SVMXC__Scheduled_Date_Time__c;
                    w.BH_US_Start_Date__c=dt.date();
                    w.BH_US_End_Date__c=dt.date();
                    System.debug('w.BH_US_Start_Date__c-->'+w.BH_US_Start_Date__c);
                 }
                 update witemlist1;
            
        }
                     
            
    }

}
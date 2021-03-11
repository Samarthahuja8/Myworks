public class Send_Email_Extension {
    private final EM_Event_vod__c vevent;
    public Boolean temp=true;
    public id event_id;
    public string eventdate;
    public id attendee_id;
    public Boolean chckclose=false;
    public List<string> str1=new List<string>();
    public List<String> certificatevalues = new List<String>();
    public Set<Id> reids = new Set<Id>();
    public string enteredText1{get;set;}
    public String[] email=new String[]{};
    public List<EM_Event_vod__c> eventrec =new List<EM_Event_vod__c>();    
    public List<EM_Attendee_vod__c> list_attendees =new List<EM_Attendee_vod__c>();
    public List<EM_Attendee_vod__c> list_attendees1 =new List<EM_Attendee_vod__c>();
    public List<EM_Attendee_vod__c> list_attendees2 =new List<EM_Attendee_vod__c>();
    public List<EM_Attendee_vod__c> list_attendees3 =new List<EM_Attendee_vod__c>();
    public List<EM_Attendee_vod__c> list_attendees4 =new List<EM_Attendee_vod__c>();
    public Map<Id,EM_Attendee_vod__c> map_attendee = new Map<Id,EM_Attendee_vod__c>();
    
    public Send_Email_Extension(ApexPages.StandardController controller) {
        
        this.vevent = (EM_Event_vod__c)controller.getRecord();
        event_id=vevent.Id;

       // System.debug(certificatevalues);
    }
    public List<EM_Attendee_vod__c> getAttendees() {
        System.debug('Inside method Attendees');
        if(temp) {
            list_attendees=[Select Id,Attendee_Name_vod__c,Send_The_Certificate__c,Status_vod__c,Email_vod__c from EM_Attendee_vod__c where Event_vod__c= :event_id];
        
           for(EM_Attendee_vod__c at : list_attendees) {
               list_attendees2.add(at); 
               temp=false;
               
            /*  if(at.Status_vod__c=='Signed_vod') {
                    list_attendees2.add(at); 
                    temp=false;
                } */
           }    
        }
    
        System.debug(list_attendees2.size());
      
        return list_attendees2;
    }
    public PageReference updateattendeecb() {
        Integer j=0;
        str1=enteredText1.split(',');
        for(String s: str1) {
            attendee_id=Id.ValueOf(s);
            reids.add(attendee_id);
        }
        

        System.debug(str1);
        System.debug(reids);
        return sendPdf(reids);
        
    }
    public PageReference choosefromtype(String pagename) {
        PageReference choose_type;
        if(pagename=='Arterion_Certificate') {
            choose_type=Page.Arterion_Certificate1;
        }
        else if(pagename=='Stellant_Flex_Certificate') {
            choose_type=Page.Stellant_Flex_Certificate_pdf;
        }
        else if(pagename=='Intego_Certificate') {
            choose_type=Page.Intego_Certificate_pdf;
        }
        else if(pagename=='MRXP_Certificate') {
            choose_type=Page.MRXP_Certificate_pdf;
        }
        else if(pagename=='POC_Certificate') {
            choose_type=Page.POC_Certificate_pdf;
        }
        else if(pagename=='Stellant_CWSC_Certificate') {
            choose_type=Page.Stellant_CWSC_Certificate_pdf;
        }
        else if(pagename=='MRXP_Webinar_Certificate') {
            choose_type=Page.MRXP_Webinar_Certificate_pdf;
        }
        else if(pagename=='Stellant_Flex_Webinar_Certificate') {
            choose_type=Page.Stellant_Flex_Webinar_Certificate_pdf;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Certificate Type is chosen.'));
            return null;
        }
        return choose_type;
    }
    public PageReference sendPdf(Set<id> lids) {
        
        list_attendees3=[Select Id,First_Name_vod__c,Last_Name_vod__c,Email_vod__c,Send_The_Certificate__c, Override_Lock_vod__c, Event_vod__r.Certificate_Type__c, Event_vod__r.Status_vod__c, Event_vod__r.Owner.Name, Event_vod__r.Start_Time_vod__c from EM_Attendee_vod__c where Id in :lids];
        eventrec=[Select Certificate_Types__c from EM_Event_vod__c where Id= :event_id];
        DateTime dt=list_attendees3[0].Event_vod__r.Start_Time_vod__c;
        eventdate=String.valueOf(dt.month())+'/'+String.valueOf(dt.day())+'/'+String.valueOf(dt.year());
      //  List<EM_Event_vod__c> e1=[Select Id,Status_vod__c,Certificate_Type__c from EM_Event_vod__c where Id= :event_id];
        System.debug('l3-->'+list_attendees3.size());
        if(list_attendees3[0].Event_vod__r.Status_vod__c=='Closed_vod') {
            chckclose=true;    
        }
    /*   
     * if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='Arterion Certificate') {
            choose_type=Page.Arterion_Certificate1;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='Stellant-Flex Certificate') {
            choose_type=Page.Stellant_Flex_Certificate_pdf;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='Intego Certificate') {
            choose_type=Page.Intego_Certificate_pdf;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='MRXP Certificate') {
            choose_type=Page.MRXP_Certificate_pdf;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='POC Certificate') {
            choose_type=Page.POC_Certificate_pdf;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='Stellant-CWS Certificate') {
            choose_type=Page.Stellant_CWSC_Certificate_pdf;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='MRXP Webinar Certificate') {
            choose_type=Page.MRXP_Webinar_Certificate_pdf;
        }
        else if(list_attendees3[0].Event_vod__r.Certificate_Type__c=='Stellant-Flex Webinar Certificate') {
            choose_type=Page.Stellant_Flex_Webinar_Certificate_pdf;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Certificate Type is chosen.'));
            return null;
        } */
       
        try {
            certificatevalues.addAll(eventrec[0].Certificate_Types__c.split(';'));
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Certificate Type is chosen.'));
            return null;

        }
        
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        for(EM_Attendee_vod__c et : list_attendees3 ) {
            
            for(integer i=0;i<certificatevalues.size();i++) {
               
                PageReference pdf = choosefromtype(certificatevalues[i]);
                email.add(et.Email_vod__c);
                // add parent id to the parameters for standardcontroller
                pdf.getParameters().put('id',et.ID);
                list_attendees4.add(et);
                // the contents of the attachment from the pdf
                Blob body;
                
                try {
            
                  // returns the output of the page as a PDF
                  body = pdf.getContent();
            
                } catch (VisualforceException e) {
                  body = Blob.valueOf('Some Text');
                }
            
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType('application/pdf');
                attach.setFileName('Certificate.pdf');
                attach.setInline(false);
                attach.Body = body;
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setToAddresses(email);
                mail.setSubject('Bayer Training: Your CEU Credits –Certificate');
                String body1='Dear '+et.First_Name_vod__c+' '+et.Last_Name_vod__c+','+'<br/>';
                body1 += 'Thank you for attending Bayer/Medrad Training conducted on '+eventdate+'. Attached please find '+certificatevalues[i]+' of completion that includes continuing education credit for your licensure.<br/><br/>';
                body1 += 'Should you have further questions please call or email the Clinical Performance Center <br/>';
                body1 += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.  1-800-633-7237 <br/>';
                body1 += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.  Clinicalperformancecenter@bayer.com <br/><br/>';
                body1 += 'Regards,'+'<br/>'+et.Event_vod__r.Owner.Name+'<br/><br/>';
                body1 += '<em>Please maintain a copy of this certificate  for your records. Bayer is not responsible for filing any credits with licensing agencies or ASRT.</em>';
                mail.setHtmlBody(body1);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            
                // Send the email
                allMails.add(mail);
                email.clear();
                System.debug('Last Line of ext');

            }
             
        }
        Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(allMails,false);
        System.debug(emailResult);
        Set<ID> targetIdsFailed = new Set<ID>();
        Integer recnum=0;
        Boolean flag1=false;
        for(Messaging.SendEmailResult r : emailResult) {
           
            recnum++;
            if(!r.IsSuccess())
            {
                Messaging.SendEmailError[] errArr = r.getErrors(); 
                System.debug(errArr);
                targetIdsFailed.add(errArr[0].getTargetObjectId()); 
                System.debug(targetIdsFailed);
            } 
            else {
                if(list_attendees4[recnum-1].Send_The_Certificate__c==false) {
                    list_attendees4[recnum-1].Send_The_Certificate__c=true;
                    if(chckclose) {
                        if(list_attendees4[recnum-1].Override_Lock_vod__c == false) {
                            list_attendees4[recnum-1].Override_Lock_vod__c =true;
                        }
                        
                    }
                            
                    flag1=true;
                }
                
                
            }
              
        }
        if(flag1) {
            map_attendee.putAll(list_attendees4);
            update map_attendee.values();
        }
        if(targetIdsFailed.size()!=0) {
            list_attendees1=[Select Id,Send_The_Certificate__c from EM_Attendee_vod__c where id in :targetIdsFailed];
        }
        
        if(list_attendees1.size()!=0) {
            for(EM_Attendee_vod__c l:list_attendees1) {
                l.Send_The_Certificate__c=false;
            }
            map_attendee.putAll(list_attendees1);
            update map_attendee.values();
        }
        
        return popup();
 
    }
    public PageReference popup() {
        System.debug('Inside method popup');
        PageReference pgref = Page.EM_Event_View_vod;
        pgref.getParameters().put('id',event_id);
        pgref.setRedirect(true);
        return pgref;

    }

}
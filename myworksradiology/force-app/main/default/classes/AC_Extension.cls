public class AC_Extension {
    private final EM_Attendee_vod__c vspeak;
    public Id attid;
    public List<EM_Attendee_vod__c> attend_list = new List<EM_Attendee_vod__c>(); 
    public List<EM_Attendee_vod__c> attend_list1 = new List<EM_Attendee_vod__c>(); 
    public List<EM_Event_vod__c> eventrec =new List<EM_Event_vod__c>();
    public List<String> certificatevalues = new List<String>();
    public List<String> certificatevalues1 = new List<String>();
    public String eventmonth,eventdate,eventyear;
    public String[] email=new String[]{};
    String pageName;
    public string callfunc{get;set;}    

    public AC_Extension(ApexPages.StandardController controller) {
        this.vspeak = (EM_Attendee_vod__c)controller.getRecord();
        attid=vspeak.Id;
        attend_list=[Select Id, Event_vod__r.Start_Time_vod__c, Send_The_Certificate__c, Email_vod__c, Event_vod__r.Owner.Name, First_Name_vod__c, Last_Name_vod__c, Override_Lock_vod__c from EM_Attendee_vod__c where Id= :attid];
        eventrec=[Select Certificate_Types__c, RecordType.Name from EM_Event_vod__c where Id= :attend_list[0].Event_vod__c];
        pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        System.debug(pageName);

    }
    public ID getAttId() {
        return attid;
    }
    
    public String getNameattendee() {
       // attend_list1=[Select Id, First_Name_vod__c, Last_Name_vod__c from EM_Attendee_vod__c where id= :attid];
        if(attend_list.size()==0) {
            return null;
        }
        else {
            return attend_list[0].First_Name_vod__c+' '+attend_list[0].Last_Name_vod__c;
        }
      //  return attend_list[0].First_Name_vod__c+' '+attend_list[0].Last_Name_vod__c;
    }
    public List<SelectOption> getTypes() {
        System.debug('In getTypes method');
        certificatevalues.addAll(eventrec[0].Certificate_Types__c.split(';'));
        for(String s : certificatevalues) {
            if(s==pageName) {
                continue;
            }
            certificatevalues1.add(s);
        }
        
        Schema.DescribeFieldResult fieldResult = EM_Event_vod__c.Certificate_Types__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<SelectOption> options = new List<SelectOption>();          
        for(Schema.PicklistEntry f : ple)
        {
            for(String s : certificatevalues1) {
                if(s==f.getValue()) {
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                    break;
                }
                
            }
        //   options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;  

    }
    
    public String getDateevent() {
        
        if(attend_list.size()==0) {
            return null;
        }
        DateTime dt=attend_list[0].Event_vod__r.Start_Time_vod__c;
        eventmonth=String.valueOf(dt.month());
        eventdate=String.valueOf(dt.day());
        eventyear=String.valueOf(dt.year());
        System.debug(eventmonth+'/'+eventdate+'/'+eventyear);
        return eventmonth+'/'+eventdate+'/'+eventyear;
    }
    
    public Boolean getrectype() {
      //  List<RecordType> RecTypeId = [SELECT Id FROM RecordType WHERE SobjectType='EM_Event_vod__c' and DeveloperName='Project_Training_Event' LIMIT 1];
        if(eventrec[0].recordType.Name=='Non-Project Training Event') {
            return false;
        }
        return true;
    }
    
    public PageReference choosefromtype() {
        PageReference choose_type;
        if(attend_list.size()==0) {
            return null;
        }
        else {
            
            if(pageName =='Arterion_Certificate') {
                choose_type=Page.Arterion_Certificate1;
            }
            else if(pageName=='Stellant_Flex_Certificate') {
                choose_type=Page.Stellant_Flex_Certificate_pdf;
            }
            else if(pageName=='Intego_Certificate') {
                choose_type=Page.Intego_Certificate_pdf;
            }
            else if(pageName=='MRXP_Certificate') {
                choose_type=Page.MRXP_Certificate_pdf;
            }
            else if(pageName=='POC_Certificate') {
                choose_type=Page.POC_Certificate_pdf;
            }
            else if(pageName=='Stellant_CWSC_Certificate') {
                choose_type=Page.Stellant_CWSC_Certificate_pdf;
            }
            else if(pageName=='MRXP_Webinar_Certificate') {
                choose_type=Page.MRXP_Webinar_Certificate_pdf;
            }
            else if(pageName=='Stellant_Flex_Webinar_Certificate') {
                choose_type=Page.Stellant_Flex_Webinar_Certificate_pdf;
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Certificate Type is chosen.'));
                return null;
            }
        }
        return choose_type;
        
    }
    
    public PageReference showPdf() {
            
            PageReference pgref = choosefromtype();
            pgref.getParameters().put('id',vspeak.ID);
            pgref.setRedirect(true);
            return pgref;

    }


    public void sendPdf() {
        
        Boolean flag1=false;     
        email.add(attend_list[0].Email_vod__c);
        PageReference pdf = choosefromtype();
        // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('id',vspeak.ID);
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
        String body1='Dear '+attend_list[0].First_Name_vod__c+' '+attend_list[0].Last_Name_vod__c+','+'<br/>';
        body1 += 'Thank you for attending Bayer/Medrad Training conducted on '+getDateevent()+'. Attached please find '+pageName+' of completion that includes continuing education credit for your licensure.<br/><br/>';
        body1 += 'Should you have further questions please call or email the Clinical Performance Center <br/>';
        body1 += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	1-800-633-7237 <br/>';
        body1 += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.	Clinicalperformancecenter@bayer.com <br/><br/>';
        body1 += 'Regards,'+'<br/>'+attend_list[0].Event_vod__r.Owner.Name+'<br/><br/>';
        body1 += '<em>Please maintain a copy of this certificate  for your records. Bayer is not responsible for filing any credits with licensing agencies or ASRT.</em>';
        mail.setHtmlBody(body1);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
    
        // Send the email
        Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        for(Messaging.SendEmailResult r : emailResult) {
            
            if(r.isSuccess()) {
                if(attend_list[0].Send_The_Certificate__c==false) {
                    attend_list[0].Override_Lock_vod__c=true;
                    attend_list[0].Send_The_Certificate__c=true;
                    flag1=true;
                }
                
            }
            else {
                if(attend_list[0].Send_The_Certificate__c==true) {
                    attend_list[0].Override_Lock_vod__c=true;
                    attend_list[0].Send_The_Certificate__c=false;
                    flag1=true;
                }
                
            }
        }
        if(flag1) {
            update attend_list;
        }
    
        System.debug('Last Line of ext'); 
    
        popup();

   }
    
   public void popup() {
       
       if(attend_list[0].Send_The_Certificate__c==true) {
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email Send Successfuly.'));
           callfunc='<script> showpop(); </script>';
       }
       else {
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There was some issue. Please try after some time.'));
           callfunc='<script> errshowpop(); </script>';
       }
       
           
   /*    System.debug('Inside method popup');
       PageReference pgref = Page.EM_Event_View_vod;
       pgref.getParameters().put('id',attid);
       pgref.setRedirect(true);
       return pgref;  */

    }

    
}
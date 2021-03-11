trigger Kimble2VeevaEvent on KimbleOne__ActivityAssignment__c (after insert) {
    if(RecursiveTriggerHandler.isFirstTime){
        RecursiveTriggerHandler.isFirstTime = false;
   
        String jsonString = json.serialize(Trigger.NEW);

    String hour = String.valueOf(Datetime.now().hour());
String min = String.valueOf(Datetime.now().minute() + 10); 
        if((Datetime.now().minute() + 10)>=60) 
        {
            hour = String.valueOf(Datetime.now().hour()+1);
            min = String.valueOf(Datetime.now().minute()-50); 
        }
String mon = String.valueOf(Datetime.now().month());
        String dt = String.valueOf(Datetime.now().day());
                String yr = String.valueOf(Datetime.now().year());
        String ss = String.valueOf(Datetime.now().second());
        system.debug('Cron '+ dt +'--'+mon+'--'+yr);
        
 String month1;
        
        
        Switch on Datetime.now().month()
        {
            when 1 {month1='JAN';}
            when 2 {month1='FEB';}
            when 3 {month1='MAR';}
            when 4 {month1='APR';}
            when 5 {month1='MAY';}
            when 6 {month1='JUN';}
            when 7 {month1='JUL';}
            when 8 {month1='AUG';}
            when 9 {month1='SEP';}
            when 10 {month1='OCT';}
            when 11 {month1='NOV';}
            when 12 {month1='DEC';}
        }
                       
//0 0 0 4 JUL ? 2014
//parse to cron expression
String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+ dt +' '+month1+' ? '+yr;
system.debug('nextFireTime'+ nextFireTime);
ScheduleClassKimble2Veeva s = new ScheduleClassKimble2Veeva(jsonString); 
System.schedule('Kimble2Veeva Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);
        
        
  //  TriggerHandler_AC_Manual.processData(jsonString);

}
}
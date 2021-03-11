global class Kimble2VeevaSchedule implements Schedulable{
   global void execute(SchedulableContext sc) {
        Kimble2VeevaEvent2 veevaEvent = new Kimble2VeevaEvent2();
        database.executebatch(veevaEvent,1); 

   }
}
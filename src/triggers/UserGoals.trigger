/* Created By:     Michelle Mallo
 * Created Date:    9/23/2015
 * Description:   User Goals Trigger for all events, trigger should contain no business logic, but hand off 
 *           to other classes for processing.
 *  
 * 
 */
trigger UserGoals on User_Goals__c (before update, before insert, after update, after insert, after delete) {
  
  // Profile & User Bypass
  if(Ctrl_UserGoal__c.getInstance().UserGoalTrigger__c == false) { 
      
      if (Trigger.isBefore && Trigger.isUpdate){
         
      }
      
      if (Trigger.isBefore && Trigger.isInsert){
       
      }
      
      if(Trigger.isAfter && Trigger.isUpdate){
         //Update User Goals on standard User object
         UserGoalUtility.setUserGoals(Trigger.new);
             
      }
      if(Trigger.isAfter && Trigger.isInsert){
         //Insert User Goals into standard User object
         UserGoalUtility.setUserGoals(Trigger.new);

             
      }
      
      if(Trigger.isAfter && Trigger.isDelete){
         
      }
  }
}
trigger Events on Event (after insert) {


 //if(Ctrl_UserGoal__c.getInstance().UserGoalTrigger__c == false) { 
            //more code that is well written

      if(Trigger.isAfter && Trigger.isInsert){
         //Insert User Goals into standard User object
         //UserGoalUtility.setUserGoals(Trigger.new);
        // Call the Flow
        for(Event events:Trigger.New){
            Map<String, Object> params = new Map<String, Object>();
            params.put('varAssignedID', events.OwnerId);
            params.put('varID', events.Id);
            Flow.Interview.Update_Event_Branch eventFlow = new Flow.Interview.Update_Event_Branch(params);
            eventFlow.start();
 
            // Obtain the results
            Double returnValue = (Double) eventFlow.getVariableValue('ReturnValue');
            System.debug('Flow returned ' + returnValue);
        
        }
             
      }
      
  //}

}
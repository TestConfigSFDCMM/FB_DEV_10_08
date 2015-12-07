@isTest
private class UserGoalUtility_Test
{
  @isTest
  static void setUserGoalsTest() {
    
    //create required test data
    TestDataFactory.createAllData();
        
    List<User_Goals__c> userGoals = [select User__c, Deposit_Goal_Amount__c, User__r.User_Name__c from User_Goals__c];
        
    //check that we have two user goals as expected
    system.assertequals(userGoals.size(), 2);    

    //check that the User has been updated   
    List<User> userRecord = [select Id, Deposit_Goal_Amount__c from User where Id = :userGoals[0].User__c];
    
    for(User user: userRecord){
        system.assertEquals(user.Deposit_Goal_Amount__c, 10000 );
    }
     
    for(User user: userRecord){
        system.assertEquals(user.Deposit_Goal_Amount__c, 10000 );
    }
  }
  
  static void updateUserGoalsTest() {
    
    //create required test data
    //TestDataFactory.updateUserGoals();
        
    //    List<User_Goals__c> userGoals = [select User__c, Deposit_Goal_Amount__c, User__r.User_Name__c from User_Goals__c];
        
    //check that the User has been updated
    
    //List<User> userRecord = [select Id, Deposit_Goal_Amount__c from User where Id = :userGoals[0].User__c];
    
    //for(User user: userRecord){
    //    system.assertEquals(user.Deposit_Goal_Amount__c, 22222 );
      //if(lead.FirstName == 'First_Mort'){
        //system.assertEquals(lead.BranchLookup__r.Name, 'LOANSMORT' );
      //}
    //}
  }
}
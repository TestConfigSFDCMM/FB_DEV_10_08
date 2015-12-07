public with sharing class UserGoalUtility {
/* Created By:   Michelle Mallo
 * Created Date:  9/23/2015
 * Description: Helper class for all logic associated with User Goal Trigger
 *  
 * 
 */

  //helper method to set User Goals on the standard user object
  public static void setUserGoals(List <User_Goals__c> newUserGoalList){

    Map<Id, User_Goals__c> goalsToProcess = new Map<Id, User_Goals__c>();  
    Map<Id, User_Goals__c> activeToProcess = new Map<Id, User_Goals__c>();   
    Map<Id, User_Goals__c> inactiveToProcess = new Map<Id, User_Goals__c>(); 
    List <User> usersToUpdate = new List <User>();
    
    //Place List values into Map  
    for(User_Goals__c goal: newUserGoalList){
        goalsToProcess.put(goal.Id, goal); 
        system.debug('first for loop ' + goal.Id);
    }
    
    //Select standard User ID and place in Map
    Map <Id, User_Goals__c> usersList = new Map<Id, User_Goals__c>([Select User__r.User_Name__c, Is_Active__c, Deposit_Goal_Amount__c, Loan_Goal_Amount__c, Product_Goal__c, Business_Lending_Goal__c, Community_Event_Goal__c, Customer_Call_Goal__c, Mortgage_Goal_Count__c From User_Goals__c WHERE Id IN :goalsToProcess.keySet()]);  
    
    //Filter records for active versus inactive
    for(User_Goals__c goalEval: usersList.values()){
    
          If (goalEval.Is_Active__c == True) {
              activeToProcess.put(goalEval.User__r.User_Name__c, goalEval); 
              system.debug('active loop ' + goalEval.User__r.User_Name__c);
          }else{
              inactiveToProcess.put(goalEval.User__r.User_Name__c, goalEval); 
              system.debug('inactive loop ' + goalEval.User__r.User_Name__c);
          }
          
    }
      
    //Set User Goal fields for active records
    for(User_Goals__c active : activeToProcess.values()){

         User user = new user(ID = active.User__r.User_Name__c); ///need to define based on ID request.Id
         system.debug('active update ' + active.User__r.User_Name__c);
         user.Deposit_Goal_Amount__c = active.Deposit_Goal_Amount__c; 
         user.Loan_Goal_Amount__c = active.Loan_Goal_Amount__c;
         user.Product_Goal__c = active.Product_Goal__c;
         user.Business_Lending_Goal__c = active.Business_Lending_Goal__c;
         user.Community_Event_Goals__c = active.Community_Event_Goal__c;
         user.Customer_Call_Goal__c = active.Customer_Call_Goal__c;
         user.Mortgage_Goal__c = active.Mortgage_Goal_Count__c;
         usersToUpdate.add(user);
    }
    
    //Set User Goal fields to NULL for inactive records  
    for(User_Goals__c inactive : inactiveToProcess.values()){

         User user = new user(ID = inactive.User__r.User_Name__c); ///need to define based on ID request.Id
         system.debug('inactive update ' + inactive.User__r.User_Name__c);
         user.Deposit_Goal_Amount__c = null; 
         user.Loan_Goal_Amount__c = null;
         user.Product_Goal__c = null;
         user.Business_Lending_Goal__c = null;
         user.Community_Event_Goals__c = null;
         user.Customer_Call_Goal__c = null;
         user.Mortgage_Goal__c = null;
         usersToUpdate.add(user);
    }
      
    try{
        //Perform bulk UPDATE to User object
        update usersToUpdate;
        system.debug('users to update ' + usersToUpdate);
    }
    catch(Exception e){
        System.debug(e); 
    }
  }
}
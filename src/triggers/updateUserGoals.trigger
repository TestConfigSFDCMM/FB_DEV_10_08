trigger updateUserGoals on User_Goals__c (after insert, after update) {
   
   for (User_Goals__c objUserFbGoals: Trigger.new) {        
                        
       //Alert message for troubleshooting
       //objUser.addError(objUser.FB_Market__c);
                 
       //Update Goals on standard User object if User Goals row is active 
       If (objUserFbGoals.Is_Active__c == True) {            

          //Select the User ID from User FirstBank
          for(User_FirstBank__c userFB:  [Select User_Name__c From User_FirstBank__c Where Id = :objUserFbGoals.User__c]) {        
                                
              for(User objStdUser:  [Select Id From User Where Id = :userFB.User_Name__c]) {         
                            
                    //Update the Goals on the User standard object
                    objStdUser.Deposit_Goal_Amount__c = objUserFbGoals.Deposit_Goal_Amount__c; 
                    objStdUser.Loan_Goal_Amount__c = objUserFbGoals.Loan_Goal_Amount__c; 
                    objStdUser.Product_Goal__c = objUserFbGoals.Product_Goal__c; 
                    objStdUser.Business_Lending_Goal__c = objUserFbGoals.Business_Lending_Goal__c; 
                    objStdUser.Community_Event_Goals__c = objUserFbGoals.Community_Event_Goal__c; 
                    objStdUser.Customer_Call_Goal__c = objUserFbGoals.Customer_Call_Goal__c; 
                    objStdUser.Mortgage_Goal__c = objUserFbGoals.Mortgage_Goal_Count__c; 
                    update objStdUser;
              }
          }
      }
      
      Else{
          for(User_FirstBank__c userFB:  [Select User_Name__c From User_FirstBank__c Where Id = :objUserFbGoals.User__c]) {        
                                
              for(User objStdUser:  [Select Id From User Where Id = :userFB.User_Name__c]) {         
                            
                    //Update the Goals on the User standard object
                    objStdUser.Deposit_Goal_Amount__c = null; 
                    objStdUser.Loan_Goal_Amount__c = null; 
                    objStdUser.Product_Goal__c = null; 
                    objStdUser.Business_Lending_Goal__c = null; 
                    objStdUser.Community_Event_Goals__c = null; 
                    objStdUser.Customer_Call_Goal__c = null; 
                    objStdUser.Mortgage_Goal__c = null; 
                    update objStdUser;
               }       
          }
      }
   } 
}
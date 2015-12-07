@isTest

private class UpdateUserGoalTest {    
    
private static testmethod void updateUserGoalTest(){  

    double totalGoal = 0;
    double totalUserGoal = 0;
    final double testGoal = 20000;
    
    User_Goals__c userobj = new User_Goals__c();
           
    userobj.User__c = 'a00G000000QllbM';
    userobj.Year__c = '2016';    
    userobj.Is_Active__c = False;    
    userobj.Deposit_Goal_Amount__c = 10000;    
    userobj.Loan_Goal_Amount__c = 20000;    
    userobj.Product_Goal__c = 300;    
    userobj.Business_Lending_Goal__c = 40000;   
    userobj.Mortgage_Goal_Count__c = 400;  
    userobj.Customer_Call_Goal__c= 356;  
    userobj.Community_Event_Goal__c= 654;    
    insert userobj;
    
    system.debug(userobj.Is_Active__c);
    
    //userobj.Is_Active__c = false;
    //update userobj;
    //system.debug(userobj.Is_Active__c);
    
    //userobj.Is_Active__c = true;
    //update userobj;
    //system.debug(userobj.Is_Active__c);
    }    
        
        //totalGoal +=  userobj.Loan_Goal_Amount__c;
        //totalUserGoal += stnduser.Loan_Goal_Amount__c;      
        
        //System.assertEquals(testGoal, totalGoal);
        //System.assertEquals(testGoal, totalUserGoal);

}
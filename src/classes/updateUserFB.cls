global class updateUserFB{

@future(callout=true)
static webservice void updateUserFB(String userid, String market)
{      
    //Alert message for troubleshooting
    //objUser.addError(objUser.FB_Market__c);
                 
    //Select the User ID from User FirstBank
    for(User_FirstBank__c userFB:  [Select Id From User_FirstBank__c Where USER_NAME__C = :userid ]){        
                            
        //Select the Market object ID    
        for(Market__c mktObj:  [Select Id  From Market__c Where Name = :market]){ 
                                
            //Update the Marekt on the User FirstBank (Goals)
            userFB.Market__c = mktObj.Id; 
            update userFB; 
        }  
    }
}}
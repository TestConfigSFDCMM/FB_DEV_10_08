@isTest

private class UpdateUserMarketTest {    

private static testmethod void UpdateUserMarketTest(){            

        User userobj = new User();    
        userobj.LastName= 'Test Trigger';    
        userobj.Alias= 'ttest';    
        userobj.Email= 'ttest@efirstbank.com';    
        userobj.Username= 'ttest@efirstbank.com';    
        userobj.CommunityNickname= 'test.trigger';    
        userobj.TimeZoneSidKey= 'America/Denver';    
        userobj.LocaleSidKey= 'en_US';    
        userobj.EmailEncodingKey= 'ISO-8859-1';    
        userobj.ProfileId= '00eG0000001IjpC';    
        userobj.LanguageLocaleKey= 'en_US';    
        userobj.FB_Market__c = 'BOLD';
        insert userobj;        
        
        //User tuserobj = [SELECT FB_Market__c FROM User WHERE Id = :userobj.Id];
        
        //system.assertEquals(tuserobj.FB_Market__c , userobj.FB_Market__c );
        
        userobj.FB_Market__c = 'DENV';   
        update userobj;
        
        //User tuserobj2 = [SELECT FB_Market__c FROM User WHERE Id = :userobj.Id];
        
        //system.assertEquals(tuserobj2.FB_Market__c , userobj.FB_Market__c );
}
}
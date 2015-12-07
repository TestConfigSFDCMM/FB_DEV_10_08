@isTest
private class ChangeDefaultUserRoleTest {

    private static testmethod void testTrigger(){
        
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
    insert userobj;

        
    }

}
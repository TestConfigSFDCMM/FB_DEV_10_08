public with sharing class UserUtility {
    
    //Set Market on User_FB__c when there is a change in Market on User
    public static void updateUserMarket(Map<ID, User> newMap, Map<ID,User> oldMap){
        
        Map<ID,String> userIdMkt = new Map<ID,String>();
        Map<ID,ID> userIdMktId = new Map<ID,ID>();
        Map<User_FirstBank__c,ID> userFBMktId = new Map<User_FirstBank__c,ID>();
        Map<String,ID> mktIdMktName = new Map<String, ID>();
        Map<ID, User_FirstBank__c> userIdUserFb = new Map<ID, User_FirstBank__c>();
        List<User_FirstBank__c> fBUsers = new list<User_FirstBank__c>();
        User_FirstBank__c userFB = new User_FirstBank__c();
        
        String marketID;
        String marketName;
        String fbUserId;
        
        //Create a map of User IDs and Market Names that have a new value
        for(User passUser : newMap.values()){
            if(passUser.FB_Market__c != oldMap.get(passUser.Id).FB_Market__c){
               userIdMkt.put(passUser.ID, passUser.FB_Market__c);
            }
        }
        
        //Create a map of all Market Names and Market IDs
        for(Market__c mktObj:  [Select ID, Name  From Market__c]){ 
        	mktIdMktName.put(mktObj.Name, mktObj.ID);
    	}
        
        //Create a map of User IDs and Market Ids
        for(Id userObjId : userIdMkt.keyset()){
            marketName = userIdMkt.get(userObjId);
            MarketID = mktIdMktName.get(marketName);
            userIdMktId.put(userObjId, MarketID);
        }
        
        //Create a map of all User_FB__c with User IDs
        for(User_FirstBank__c userFbObj:  [Select Id, User_Name__c From User_FirstBank__c]){ 
            userIdUserFb.put(userFbObj.User_Name__c, userFbObj);
		}
        
        //Create a map of User_FB__c with Market IDs
        for(Id userObjId : userIdMktId.keySet()){
        	userFB = userIdUserFb.get(userObjId);
            marketID = userIdMktId.get(userObjId);
            userFBMktId.put(userFB, marketId);
        }
        
        //Set User_FB__c.Market__c and add to list
        for(User_FirstBank__c userFbObj : userFBMktId.keySet()){
            userFB.Market__c = userFBMktId.get(userFbObj);
            fBUsers.add(userFB);
        }
        
        try{
        	update fBUsers;
        }
        catch(Exception e) {
            System.debug(e);
        
		}
    }
    
    //Sets User Role to 'Default' if it is blank
    public static void changeDefaultUserRole(List<User> userList){
    	UserRole usrRole =[Select Id, Name from UserRole where name =: 'Default Role' LIMIT 1];
		list<User> listUsers = new list<User>();
    	for (User objUser: userList ) {
        	if(objUser.UserRoleId == null) {
            	objUser.UserRoleId = usrRole.Id;
                listUsers.add(objUser);
        	}
    	}
        
        try{
        	update listUsers ;
        }
        catch(Exception e) {
            System.debug(e);
        
		}
    }
}
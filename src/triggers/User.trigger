trigger User on User (before insert, before update, after insert, after update, after delete) {
    if(Trigger.isBefore && Trigger.isInsert){
    	UserUtility.changeDefaultUserRole(Trigger.new);    
    }  
    if(Trigger.isBefore && Trigger.isUpdate){
        UserUtility.updateUserMarket(Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        
    }
    if(Trigger.isAfter && Trigger.isDelete){
        
    }
}
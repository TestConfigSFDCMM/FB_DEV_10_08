/* Created By:   	Chad Stewart, Slalom LLC
 * Created Date:  	9/9/2015
 * Description: 	Lead Trigger for all events, trigger should contain no business logic, but hand off 
 * 					to other classes for processing.
 *  
 * 
 */
trigger Lead on Lead (before update, before insert, after update, after insert, after delete) {
	
	// Profile & User Bypass
	if(Ctrl_Lead__c.getInstance().LeadTrigger__c == false) { 
	    
	    if (Trigger.isBefore && Trigger.isUpdate){
	       
	    }
	    
	    if (Trigger.isBefore && Trigger.isInsert){
	     	//Set default values for market and branck mort and 1031 leads
	     	LeadUtility.setLeadDefaults(Trigger.new);
	     
	    }
	    
	    if(Trigger.isAfter && Trigger.isUpdate){

	           
	    }
	    if(Trigger.isAfter && Trigger.isInsert){

	           
	    }
	    
	    if(Trigger.isAfter && Trigger.isDelete){
	       
	    }
	}
}
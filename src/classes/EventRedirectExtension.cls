public with sharing class EventRedirectExtension {

	private ApexPages.StandardController controller = null;

	public EventRedirectExtension (ApexPages.StandardController controller){
		this.controller = controller;
	}


	public PageReference redirect(){
		try {
    		String BranchID;
    		String prefix = Event.SObjectType.getDescribe().getKeyPrefix();
    		String param = getParameters() + '&(your field id)=(your field value)';
    		//Default the Branch from User so that User does not have to enter.  Worklfow will update during save
    		String Branch = [select FB_Branch_Short_Name__c from User where id = :UserInfo.getUserId()].FB_Branch_Short_Name__c;
    		Branch__c[] objBranch = [select ID from Branch__c where Name = :Branch];
    		
            if (objBranch.size() > 0) {
        		BranchID = objBranch[0].ID;
        		return new PageReference('/'+prefix+'/e?nooverride=1&'+param+'&CF00NZ0000001k0pl='+Branch+'&CF00NZ0000001k0pl_lkid='+BranchID); 
    		} else {
        		Branch = 'Invalid Branch';
        		return new PageReference('/'+prefix+'/e?nooverride=1&'+param+'&CF00NZ0000001k0pl='+Branch+'&CF00NZ0000001k0pl_lkid='+BranchID); 
    		}
 		} catch(DmlException e) {
    		System.debug('The following exception has occurred: ' + e.getMessage());
    		return null;
    	}
	}

	// Inherit previous parameters, more importantly, RecordType parameter!
	private String getParameters(){
		string param = '';
		Map<String, String> strMap = ApexPages.currentPage().getParameters();
		String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL', 'Name', 'who_id', 'what_id'};
		
      	for(String s : keys){
			if(strMap.containsKey(S)) param += s + '=' + strMap.get(s) + '&';
		}
		if(param.length() > 0) param = param.substring(0, param.length()-1);
			return param;
		}

}
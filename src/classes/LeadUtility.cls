/* Created By:   Chad Stewart, Slalom LLC
 * Created Date:  9/9/2015
 * Description: Helper class for all logic associated with Lead Trigger
 *  
 * 
 */
public with sharing class LeadUtility {

	//helper method to set default market and branch for new leads. Currently only sets for 
	//1031 and mort lead record types.
	public static void setLeadDefaults(List<Lead> newLeadList){

		List<Lead> leadsToProcess = new List<Lead>();
		List<Lead> updateLeads = new List<Lead>();
		
		//Filter for records that should be processed - those with a blank branch and market, 
		//and have a record type of mort or 1031
		for(Lead leadChk: newLeadList){
			If (leadChk.LeadSource.contains('Mortgage') || leadChk.LeadSource == '1031') {
					leadsToProcess.add(leadChk);
			}
		}


		//This works, but still uses 4 queries - easy way to reduce? Also - what if data is not present, should we check?
		string mortBranch = [Select Id from Branch__c where Name = 'LOANSMORT' limit 1].Id; 
		string exBranch = [Select Id from Branch__c where Name = 'LGMT' limit 1].Id; 

		System.debug('Ids found' + exBranch);

		//Process filtered list of leads to set Market and Branch to defaults when the user has not selected values
		for(Lead lead: leadsToProcess){

			//Updated reference to record type name instead of ID
			If (lead.LeadSource.contains('Mortgage')) {
		          lead.BranchLookup__c = mortBranch;
		          updateLeads.add(lead);
		          
		      } else {
		      
		      //Updated reference to record type name instead of ID
		      If (lead.LeadSource == '1031') {
		         Lead.BranchLookup__c = exBranch;
		         system.debug('Branch = ' +  Lead.BranchLookup__c);
		         updateLeads.add(lead);
		      }
		    }
		}
		try{
			update updateLeads;
			system.debug('leads to update ' + updateLeads);
		}
		catch(Exception e){
            System.debug(e); 
		}
	}
}
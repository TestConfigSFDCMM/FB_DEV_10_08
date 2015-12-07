/* Created By:   	Chad Stewart, Slalom LLC
 * Created Date:  	9/25/2015
 * Description: 	Test class to cover lead utility logic
 *  
 * 
 */
@isTest
private class LeadUtility_Test
{
	//positive test to ensure branch and market defaults are occuring as expected
    @isTest
	static void leadDefaultTest() {
		
		//create required test data
		TestDataFactory.createBranchMarketRegion();
		TestDataFactory.createLeads();
	
        list<lead> leads = [select firstname, BranchLookup__r.Name from lead];		

		//check that the leads have the correct market/branch
		for(Lead lead: leads){
			if(lead.FirstName == 'First_1031'){
				system.assertEquals(lead.BranchLookup__r.Name, 'LGMT' );
			}
			if(lead.FirstName == 'First_Mort'){
				system.assertEquals(lead.BranchLookup__r.Name, 'LOANSMORT' );
			}
		}
	}
    
    //test method to cover remaing test data factory methods.
    @isTest
	static void testDataFactory() {
        TestDataFactory.createAllData();
    
    }
}
/* Created By:   	Chad Stewart, Slalom LLC
 * Created Date:  	9/23/2015
 * Description: 	Class to create data for any/all objects needed for test classes
 *  
 * 
 */
@IsTest
public class TestDataFactory {

  /** Map of Salesforce profile names to profile records */
  public static final Map<String,Profile> PROFILE_MAP = new Map<String,Profile>();
    
  /** Map of Salesforce record type object::developer name to record type records */
  public static final Map<String,RecordType> RECORD_TYPE_MAP = new Map<String,RecordType>();  
  
  /** Set database options for user insert */
  public static final Database.DMLOptions dmo = new Database.DMLOptions();
    
    
	/** Static initializer */ 
	static {
	    
	  // Initialize the profile name to identifier map */
	  for (profile prof : [SELECT Name, UserLicenseId, UserType FROM profile]) {
	  	PROFILE_MAP.put(prof.Name, prof);
	  }
	    
	  // Initialize the record type developer name to identifier map */
	  for (RecordType rType : [SELECT DeveloperName, IsActive, SobjectType FROM RecordType]) {
	   	RECORD_TYPE_MAP.put(rType.SobjectType + '::' + rType.DeveloperName, rType);
	  } 
	  	
		// Initialize the data base options
	    dmo.EmailHeader.triggerAutoResponseEmail  = false;
	    dmo.EmailHeader.triggerOtherEmail  = false;
	    dmo.EmailHeader.triggerUserEmail = false;   	
	  }

	public static void createLeads() {

		
		// Configure a set of test leads
	    List<sObject> leads = new List<sObject>();
	    leads.add(new Lead(FirstName= 'First_1031', LeadSource='1031', LastName= 'Last_1031', Company= 'Company',Email= 'email@email.com',Status= 'Open', RecordTypeId=RECORD_TYPE_MAP.get('Lead::X1031').id));
	    leads.add(new Lead(FirstName= 'First_Mort', LeadSource='Mortgage', LastName= 'Last_Mort', Company= 'Company',Email= 'email@email.com',Status= 'Open', RecordTypeId=RECORD_TYPE_MAP.get('Lead::Mortgages').id));
	    insert leads;

	}

	//create suite of test regions, markets and branches
	public static void createBranchMarketRegion() {

		// Configure a set of test regions
	    List<sObject> regions = new List<sObject>();
	    regions.add(new Region__c(Name= 'Northern Colorado/Arizona', IsActive__c= true));
	    regions.add(new Region__c(Name= 'FBSS/FHC',IsActive__c = true));
	    insert regions;

		// Configure a set of test markets
	    List<sObject> markets = new List<sObject>();
	    markets.add(new Market__c(Name= 'FBSS', IsActive__c= true, Region__c=regions[1].id));
	    markets.add(new Market__c(Name= 'LONG',IsActive__c = true,  Region__c=regions[0].id));
	    insert markets;

	    // Configure a set of test branches
	    List<sObject> branches = new List<sObject>();
	    branches.add(new Branch__c(Name= 'LOANSMORT', Is_Active__c= true, Market__c=markets[0].id));
	    branches.add(new Branch__c(Name= 'LGMT',Is_Active__c = true,  Market__c=markets[1].id));
	    insert branches;    

	}

	//create a suite of test accounts. Use only after region, Market and Branches have been created
	public static void createContactsAccountsOpps(){
		
        //get the branch and related market id for contact, account and opp insert
		list<Branch__c> branches = [select name, Market__r.id from Branch__c order by name];
		
		// Configure a set of test accounts
	    List<sObject> accounts = new List<sObject>();
	    accounts.add(new Account(Name= 'AcctTestClass', Type= 'Prospective', Branch__c=branches[0].id, RecordTypeId=RECORD_TYPE_MAP.get('Account::Households').id));
	    accounts.add(new Account(Name= 'Acc2', Type= 'Prospective', Branch__c=branches[0].id, RecordTypeId=RECORD_TYPE_MAP.get('Account::Households').id));
	    insert accounts;

	    // Configure a set of test contacts
	    List<sObject> contacts = new List<sObject>();
	    contacts.add(new Contact(FirstName= 'ContactFirst1', LastName='ContactLast1' , FB_Type__c='Prospective', Branch__c=branches[0].id, AccountId=accounts[1].Id));
	    contacts.add(new Contact(FirstName= 'ContactFirst2', LastName='ContactLast2' , FB_Type__c='Prospective', Branch__c=branches[0].id, AccountId=accounts[0].id));
	    insert contacts;

	    //configure a set of test opps
	    List<sObject> opps = new list<sObject>();
	    opps.add(new Opportunity(Name='Test Opp', CloseDate = System.today(), StageName = 'Open', Amount = 100000, FB_Opportunity_Source__c = 'Cross Sale', BranchLookup__c=branches[0].id, AccountId=accounts[0].id, RecordTypeId=RECORD_TYPE_MAP.get('Opportunity::FB_Loan_Opportunities').id));
	    opps.add(new Opportunity(Name='Test Opp2', CloseDate = System.today(), StageName = 'Open', Amount = 100000, FB_Opportunity_Source__c = 'Cross Sale', BranchLookup__c=branches[0].id, AccountId=accounts[1].id, RecordTypeId=RECORD_TYPE_MAP.get('Opportunity::FB_Loan_Opportunities').id));
	    opps.add(new Opportunity(Name='Test Opp3', CloseDate = System.today(), StageName = 'Open', Amount = 100000, FB_Opportunity_Source__c = 'Cross Sale', BranchLookup__c=branches[0].id, AccountId=accounts[0].id, RecordTypeId=RECORD_TYPE_MAP.get('Opportunity::FB_Loan_Opportunities').id));
		insert opps;
	}

	//create user goals, must have markets to create FB users - create markets 1st
	public static void createUserGoals(){
		
        //get the market id of FB user insert
        List<Market__c> markets = [select name from Market__c where name = 'FBSS'];        
        
        //Create a user with the appropriate market, to create user goals
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'admin', Email='testuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FB_Market__c='FBSS', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='FirstBank_SuperAwesome_Tester@supertest.com');
        insert u;
        
        
        //Configure a set of FB User records
		List<sObject> FBUsers = new List<sObject>();
	    FBUsers.add(new User_FirstBank__c(User_Name__c=u.Id, Market__c=markets[0].id));   
	    insert FBUsers;
        
        
        System.runAs(u) {
        // Configure a set of test Goals
	    List<sObject> goals = new List<sObject>();
	    goals.add(new User_Goals__c(User__c=FBUsers[0].id, Year__c = '2016', Is_Active__c = true, Deposit_Goal_Amount__c = 10000, Loan_Goal_Amount__c = 20000, Product_Goal__c = 300, Business_Lending_Goal__c = 40000, Mortgage_Goal_Count__c = 400, Customer_Call_Goal__c= 356, Community_Event_Goal__c= 654));   
	    goals.add(new User_Goals__c(User__c=FBUsers[0].id, Year__c = '2015', Is_Active__c = False, Deposit_Goal_Amount__c = 10000, Loan_Goal_Amount__c = 20000, Product_Goal__c = 300, Business_Lending_Goal__c = 40000, Mortgage_Goal_Count__c = 400, Customer_Call_Goal__c= 356, Community_Event_Goal__c= 654));
	    insert goals;
        }
	}

	//create all data when needed
	public static void createAllData(){

		createBranchMarketRegion();
        createUserGoals();
        createContactsAccountsOpps();
        createLeads();
	}

}
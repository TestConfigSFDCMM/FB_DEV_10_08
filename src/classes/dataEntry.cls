//adding comment, wonder if it shows.
//still more comments needed wow love comments.
Public with sharing class dataEntry {
    
	public Contact c1{get{
   		if (c1 == null)
       	c1 = new Contact(FB_Type__c = 'Prospective');
        return c1;
    }
    set;}
    
    public Contact c2{get{
      	if (c2 == null)
        c2 = new Contact(FB_Type__c = 'Prospective');
        return c2;
    }
    set;}
    
    public Account acc{get{
    	String strBranch;
        currentUser=[Select FB_Branch_Short_Name__c from User where Id=:userinfo.getuserId() LIMIT 1];   
        strBranch = currentUser.FB_Branch_Short_Name__c;                         
        objBranchId = [Select Id from Branch__c where Name = :strBranch LIMIT 1];  
                            
        if (objBranchId.size() > 0) {
        	if (acc == null)
            	acc = new Account( Type = 'Prospective', Branch__c = objBranchId[0].Id, OwnerID=UserInfo.getUserId());                             
            	return acc;
       	} else {
        	if (acc == null)
                acc = new Account( Type = 'Prospective', OwnerID=UserInfo.getUserId());                             
                return acc;
        }
    }
    set;}
    
    public String rt{get;set;}
    public String ptc1{get;set;}
    public String ptc2{get;set;}
    public String accb{get;set;}
    public String accs{get;set;}   
    public User currentUser{get;set;}
    public Branch__c[] objBranchId{get;set;}
    public Branch__c branchLookup = new Branch__c();
    Id branchMarketId;
    
    public dataEntry(){
        
    }
    
    public void copyAddress(){        
        c2.MailingStreet = c1.MailingStreet;
        c2.MailingCity = c1.MailingCity;
        c2.MailingStateCode = c1.MailingStateCode;
        c2.MailingPostalCode = c1.MailingPostalCode;
        c2.MailingCountryCode = c1.MailingCountryCode;
        ptc2 = ptc1;
        
    }
    
    public void updateAccount(){        
        if ((rt == 'Households') && (c1.LastName != null) && (c1.LastName != '')){
            if ((c1.FirstName != null) && (c1.FirstName != ''))
                acc.Name = c1.FirstName + ' ' + c1.LastName + ' - Household';
            else
                acc.Name = c1.LastName + ' - Household';
        }        
    }
    
    public void copyAddressFromContact(){        
        acc.BillingStreet = c1.MailingStreet;
        acc.BillingCity = c1.MailingCity;
        acc.BillingStateCode = c1.MailingStateCode;
        acc.BillingPostalCode = c1.MailingPostalCode;
        acc.BillingCountryCode = c1.MailingCountryCode;
        accb = ptc1;        
    }
    
    public void copyAddressFromAccount(){        
        acc.ShippingStreet = acc.BillingStreet;
        acc.ShippingCity = acc.BillingCity;
        acc.ShippingStateCode = acc.BillingStateCode;
        acc.ShippingPostalCode = acc.BillingPostalCode;
        acc.ShippingCountryCode = acc.BillingCountryCode;
        accs = accb;       
    }
    
    public pageReference save(){
        
        if ((((c1.FirstName != null) && (c1.FirstName != '')) || ((c1.HomePhone != null) && (c1.HomePhone != '')) || ((c1.MobilePhone != null) && (c1.MobilePhone != '')) ||
           ((c1.Email != null) && (c1.Email != '')) || ((c1.MailingStreet != null) && (c1.MailingStreet != '')) || ((c1.MailingCity != null) && (c1.MailingCity != ''))
             || ((c1.MailingPostalCode != null) && (c1.MailingPostalCode != '')) ) && ((c1.LastName == null) || (c1.LastName == ''))){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must enter a Last Name to save Contact 1.'));
                return null;
        }
           
        if (((c1.LastName != null) || (c1.LastName != '')) && ((c1.FB_Type__c== null) || (c1.FB_Type__c== ''))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a Type to save the Contact 1.'));
            return null;
        }
        
        if ((((c2.FirstName != null) && (c2.FirstName != '')) || ((c2.HomePhone != null) && (c2.HomePhone != '')) || ((c2.MobilePhone != null) && (c2.MobilePhone != '')) ||
           ((c2.Email != null) && (c2.Email != '')) || ((c2.MailingStreet != null) && (c2.MailingStreet != '')) || ((c2.MailingCity != null) && (c2.MailingCity != ''))
             || ((c2.MailingPostalCode != null) && (c2.MailingPostalCode != ''))) && ((c2.LastName == null) || (c2.LastName == ''))){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must enter a Last Name to save Contact 2.'));
                return null;
        }
        
        if (((c2.LastName != null) || (c2.LastName != '')) && ((c2.FB_Type__c== null) || (c2.FB_Type__c== ''))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a Type to save the Contact 2.'));
            return null;
        }
        
        if ((acc.Name == null) || (acc.Name == '')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an Account Name to save the account.'));
            return null;
        }
                       
        if ((acc.Type == null) || (acc.Type == '')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a Type to save the Account.'));
            return null;
        }
       
        if ((acc.Name != null) && (acc.Name != '')){
            acc.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name = : rt and SobjectType ='Account' limit 1].Id;
            if ((accs != null) && (accs != '-None-') && (acc.ShippingStateCode == null))
                acc.ShippingStateCode = accs;
            if ((accb != null) && (accb != '-None-') && (acc.BillingStateCode == null))
                acc.BillingStateCode = accb;
            insert acc;
        }
         
        if ((c1.LastName != null) && (c1.LastName != '')){
            c1.AccountId = acc.Id;
            c1.Branch__c = acc.Branch__c;
            c1.OwnerId= acc.OwnerId;
            if ((ptc1 != null) && (ptc1 != '-None-') && (c1.MailingStateCode == null))
                c1.MailingStateCode = ptc1;
            insert c1;
        }
        
        
        if ((c2.LastName != null) && (c2.LastName != '')){
            c2.AccountId = acc.Id;
            c2.Branch__c = acc.Branch__c;
            c2.OwnerId= acc.OwnerId;
            if ((ptc2 != null) && (ptc2 != '-None-') && (c2.MailingStateCode == null))
                c2.MailingStateCode = ptc2;
            insert c2;
        }
        
        if (c1.Id != null){
            Associated_Customer__c ac1 = new Associated_Customer__c(Contact__c = c1.Id, Customer__c = acc.Id);
            ac1.OwnerId= acc.OwnerId;
            insert ac1;
        }
        
        if (c2.Id != null){
            Associated_Customer__c ac2 = new Associated_Customer__c(Contact__c = c2.Id, Customer__c = acc.Id);
            ac2.OwnerId= acc.OwnerId;
            insert ac2;
        }
                
        pageReference pr = new pageReference('/' + acc.Id);
        return pr;
        
    }
    
    public pageReference cancel(){        
        pageReference pr = new pageReference('/');
        return pr;      
    }
    
    public pageReference toWeb(){       
        pageReference pr = Page.dataEntryWeb;
        pr.setRedirect(true);
        return pr;       
    }
    
    public pageReference toMobile(){        
        pageReference pr = Page.dataEntry;
        pr.setRedirect(true);
        return pr;       
    }
    
    public List<SelectOption> getrtitems() {        
        List<SelectOption> options = new List<SelectOption>(); 
        Map<String, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        for (String sindex : rtMap.keySet())
            if (sindex != 'Master')
                options.add(new SelectOption(sindex, sindex)); 
        return options;
    }
    
    public String getrt() {       
        return rt;        
    }
                    
    public void setrt(String rt) { this.rt = rt; }
    
    public List<SelectOption> getptitems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldResult = Contact.MailingStateCode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('-None-', '-None-'));
        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getValue(), f.getValue())); 
        
        return options; 
        
    }
}
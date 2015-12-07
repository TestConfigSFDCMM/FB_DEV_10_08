@isTest
private class RedirectTests {

	private static testmethod void AccountRedirectTest (){     
         
        
         ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        PageReference pageRef = Page.Account_Page;
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        AccountRedirectExtension oPRE = new AccountRedirectExtension(new ApexPages.StandardController(new Account()));
        System.assert(oPRE.redirect()!=null);        
	}
    
    private static testmethod void ContactRedirectTest (){     
         
        
         ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        PageReference pageRef = Page.Contact_Page;
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        ContactRedirectExtension oPRE = new ContactRedirectExtension(new ApexPages.StandardController(new Contact()));
        System.assert(oPRE.redirect()!=null);
    
	}
    
    private static testmethod void EventRedirectTest (){     
         
        
         ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        PageReference pageRef = Page.Event_Page;
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        EventRedirectExtension eKRE = new EventRedirectExtension(new ApexPages.StandardController(new Event()));
        System.assert(eKRE.redirect()!=null);        
	}
    
    private static testmethod void OpportunityRedirectTest (){     
         
        
         ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        PageReference pageRef = Page.Opportunity_Page;
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        OpportunityRedirectExtension oPRE = new OpportunityRedirectExtension(new ApexPages.StandardController(new Contact()));
        System.assert(oPRE.redirect()!=null);       
	}
    
    private static testmethod void TaskRedirectTest (){     
         
        
         ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        PageReference pageRef = Page.Task_Page;
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        TaskRedirectExtension tKRE = new TaskRedirectExtension(new ApexPages.StandardController(new Task()));
        System.assert(tKRE.redirect()!=null);        
	}
}
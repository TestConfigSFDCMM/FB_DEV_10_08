@isTest(SeeAllData=true)
public with sharing class dataEntryTest {

    public User currentUser{get;set;}
    public Branch__c objBranchId{get;set;}

    private static testmethod void AcctUpdateTest(){
        
        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        User currentUser=[Select FB_Branch_Short_Name__c from User where Id = :UserInfo.getUserId()];  
        strBranch = currentUser.FB_Branch_Short_Name__c; 
        Branch__c objBranchId = [Select Id from Branch__c where Name = :strBranch];   
        de.acc.Branch__c = objBranchId.Id;
        Test.startTest();
        de.updateAccount();
        de.save();
        Test.stopTest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                
    }
    
    //private static testmethod void copyCntctAddressTest(){
        
        //Test.startTest();
        
        //dataEntry de = new dataEntry();
        //de.copyAddress();
        //de.rt = 'Households';
        //de.c1.LastName = 'lname';
        //de.c2.LastName = 'lname2';
        //de.updateAccount();
        //de.copyAddressFromContact();
        //de.save();

        
        //Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        //system.assertEquals(tacc.Name, 'lname - Household');
        //Test.stopTest();
                
    //}
    
        private static testmethod void copyAcctAddressTest(){

        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        de.updateAccount();
        de.copyAddressFromAccount();
        Test.startTest();
        de.save();
        Test.stopTest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                        
    }
    
        private static testmethod void CancelTest(){
        
        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        User currentUser=[Select FB_Branch_Short_Name__c from User where Id = :UserInfo.getUserId()]; 
        strBranch = currentUser.FB_Branch_Short_Name__c;
        Branch__c objBranchId = [Select Id from Branch__c where Name = :strBranch];   
        de.acc.Branch__c = objBranchId.Id;
        de.updateAccount();
        Test.startTest();
        de.save();
        de.cancel();
        Test.stoptest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                
    }
    
    private static testmethod void toWebTest(){
        
        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        User currentUser=[Select FB_Branch_Short_Name__c from User where Id = :UserInfo.getUserId()];  
        strBranch = currentUser.FB_Branch_Short_Name__c; 
        Branch__c objBranchId = [Select Id from Branch__c where Name = :strBranch];   
        de.acc.Branch__c = objBranchId.Id;
        de.updateAccount();
        Test.startTest();
        de.save();
        de.toWeb();
        Test.stoptest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                
    }
    
        private static testmethod void toMobileTest(){
        
        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        User currentUser=[Select FB_Branch_Short_Name__c from User where Id = :UserInfo.getUserId()];   
        strBranch = currentUser.FB_Branch_Short_Name__c;
        Branch__c objBranchId = [Select Id from Branch__c where Name = :strBranch];   
        de.acc.Branch__c = objBranchId.Id;
        de.updateAccount();
        Test.startTest();
        de.save();
        de.toMobile();
        Test.stoptest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                
    }

        private static testmethod void getrtitemsTest(){
        
        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        User currentUser=[Select FB_Branch_Short_Name__c from User where Id = :UserInfo.getUserId()]; 
        strBranch = currentUser.FB_Branch_Short_Name__c;
        Branch__c objBranchId = [Select Id from Branch__c where Name = :strBranch];   
        de.acc.Branch__c = objBranchId.Id;
        de.updateAccount();
        Test.startTest();
        de.save();
        de.getrtitems();
        Test.stoptest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                
    }
    
    private static testmethod void getptitemsTest(){
        
        String strBranch;
        
        dataEntry de = new dataEntry();
        de.copyAddress();
        de.rt = 'Households';
        de.c1.LastName = 'lname';
        de.c2.LastName = 'lname2';
        User currentUser=[Select FB_Branch_Short_Name__c from User where Id = :UserInfo.getUserId()]; 
        strBranch = currentUser.FB_Branch_Short_Name__c;
        Branch__c objBranchId = [Select Id from Branch__c where Name = :strBranch];   
        de.acc.Branch__c = objBranchId.Id;
        de.acc.Branch__c = objBranchId.Id;
        de.updateAccount();
        Test.startTest();
        de.save();
        de.getptitems();
        Test.stoptest();
        
        Account tacc = [SELECT Id, Name FROM Account WHERE Id =: de.acc.Id];
        
        system.assertEquals(tacc.Name, 'lname - Household');
                
    }
}
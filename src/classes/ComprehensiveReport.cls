/* Created By:      VertibaAdmin
 * Created Date:    
 * Description:     Controller for comprehensive report
 * Updates:         Chad Stewart - Updated test method to increase coverage. 10-08-2015
 *  
 * 
 */
public with sharing class ComprehensiveReport {
     
    public boolean checkActivities { get; set; }
    public boolean checkOpportunities { get; set; }
    public boolean checkAccounts { get; set; }
    public boolean checkContacts { get; set; }
    public boolean checkAny {
        get {
            boolean anyCheck = false;
            if (SelectedObjects != null && SelectedObjects.size() > 0)
                anyCheck = true;
            return anyCheck || checkActivities || checkOpportunities || checkAccounts || checkAccounts;
        }
    }
    public boolean rendered { get; set; }
       
    public contact timeFrameC1 { get; set; }
    public contact timeFrameC2 { get; set; }
    public string selectedTimeRange { get; set; }
    
    public string selectedActivities1 { get; set; }
    public string selectedActivities2 { get; set; }
    
    public string selectedOpportunities { get; set; }
    
    public List<Activity> activityvar { get; set; }
    public string activitytitle { get { return 'Activities ' + ((activityvar.size() > 499)?'(this table was limited to 500 rows)':''); } }
    public List<Opportunity> oppvar { get; set; }
    public string opptitle { get { return 'Opportunities ' + ((oppvar.size() > 499)?'(this table was limited to 500 rows)':''); } }
    public List<Account> accvar { get; set; }
    public string acctitle { get { return 'Accounts ' + ((accvar.size() > 499)?'(this table was limited to 500 rows)':''); } }
    public List<Contact> contvar { get; set; }
    public string conttitle { get { return 'Contacts ' + ((contvar.size() > 499)?'(this table was limited to 500 rows)':''); } }
    public Map<String, sObjectListWrapper> otherObjectsVar { get; set; }
    
    public class sObjectListWrapper {
        public Map<Id, sObjectWrapper> objects { get; set; }
        public string objtitle { get { return ((objects.size() > 499)?'(this table was limited to 500 rows)':''); } }
        public Map<String, String> fieldsY { get; set; }
        public boolean hasName { get; set; }
        public sObjectListWrapper(List<sObject> sObj, Map<String, String> flds, boolean hn) {
            objects = new Map<Id,sObjectWrapper>();
            for (sObject sO : sObj)
                objects.put(sO.Id, new sObjectWrapper(sO));
            fieldsY = flds;
            hasName = hn;
        }
    }
    
    public class sObjectWrapper {
        
        public sObject obj { get; set; } 
        
        public sObjectWrapper(sObject sObj) {
            obj = sObj;
        }
    }
       
    public String selectedOwners { get; set; }
    
    public ExcelDataModel dm {get;set;}

    public List<SelectOption> getUserGroupTypes() {
        list <selectOption> options = new list<selectOption>();
        options.add(new selectOption('Users' , 'Users'));
        options.add(new selectOption('Roles' , 'Roles' ));
        options.add(new selectOption('Roles and Subordinates' , 'Roles and Subordinates'));
        return options;
    }
    public string SelectedUserGroupType { get; set; }
    public string UserSearchTerm { get; set; }
    public List<UserGroup> UserGroups { get; set; }
    public class UserGroup {
        public string GroupType { get; set; }
        public string GroupName { get; set; }
        public Id GroupId { get; set; }
        
        public UserGroup(Id gId, String gType, String gName) {
            GroupId = gId;
            GroupType = gType;
            GroupName = gName;
        }
    }
    private Map<Id, String> elemsMap;
    public List<SelectOption> getUserGroupElems() {
        elemsMap = new Map<Id, String>();
        list <selectOption> options = new list<selectOption>();
        string searchTerm = '%' + UserSearchTerm + '%';
        if (SelectedUserGroupType == 'Users') {
            List<User> usrxs = [SELECT Id, Name FROM User WHERE Name LIKE :searchTerm];
            for (User usrx : usrxs) {
                boolean found = false;
                for (SelectOption option : options) {
                    if (option.getValue() == usrx.Id)
                        found = true;
                }
                for (UserGroup ugx : UserGroups) {
                    if (ugx.GroupId == usrx.Id)
                        found = true;
                }
                if (!found) {
                    options.add(new selectOption(usrx.Id , 'Users:' + usrx.Name));
                    elemsMap.put(usrx.Id, 'Users:' + usrx.Name);
                }
            }
        }
        if (SelectedUserGroupType == 'Roles' || SelectedUserGroupType == 'Roles and Subordinates') {
            List<UserRole> usrxs = [SELECT Id, Name FROM UserRole WHERE Name LIKE :searchTerm];
            for (UserRole usrx : usrxs) {
                boolean found = false;
                for (SelectOption option : options) {
                    if (option.getValue() == usrx.Id)
                        found = true;
                }
                for (UserGroup ugx : UserGroups) {
                    if (ugx.GroupId == usrx.Id)
                        found = true;
                }
                if (!found) {
                    options.add(new selectOption(usrx.Id , SelectedUserGroupType + ':' + usrx.Name));
                    elemsMap.put(usrx.Id, SelectedUserGroupType + ':' + usrx.Name);
                }
            }
        }
        return options;
    }
    public List<String> SelectedUserGroupElems { get; set; }
    public List<SelectOption> getUserGroupElems2() {
        list <selectOption> options = new list<selectOption>();
        for (UserGroup ugx : UserGroups)
            options.add(new SelectOption(ugx.GroupId, ugx.GroupName));
        return options;
    }
    public List<String> SelectedUserGroupElems2 { get; set; }
    public void AddGroupElems() {
        for (String elem1 : SelectedUserGroupElems)
            UserGroups.add(new UserGroup(elem1, SelectedUserGroupType, elemsMap.get(elem1)));
    }
    public void RemoveGroupElems() { 
        for (String elem1 : SelectedUserGroupElems2)
            for (integer i = 0; i < UserGroups.size(); i++)
                if (elem1 == UserGroups[i].GroupId)
                    UserGroups.remove(i);
    }
    
    public List<SelectOption> SelectedObjects { get; set; }
    public List<SelectOption> AvailableObjects { get; set; }
    public List<String> objsToAdd { get; set; }
    public List<String> objsToRem { get; set; }
    public void Add() {
        for (String obj : objsToAdd) {
            for (integer i = 0; i < AvailableObjects.size(); i++) {
                SelectOption so = AvailableObjects.get(i);
                if (obj == so.getValue()) {
                    SelectedObjects.add(so);
                    AvailableObjects.remove(i);
                    break;
                }
            }
        }
        objsToAdd = new List<String>();
        SelectedObjects = Sort(SelectedObjects);
    }
    public void Rem() {
        for (String obj : objsToRem) {
            for (integer i = 0; i < SelectedObjects.size(); i++) {
                SelectOption so = SelectedObjects.get(i);
                if (obj == so.getValue()) {
                    AvailableObjects.add(so);
                    SelectedObjects.remove(i);
                    break;
                }
            }
        }
        objsToRem = new List<String>();
        AvailableObjects = Sort(AvailableObjects);
    }
    
    private List<SelectOption> Sort(List<SelectOption> ListToSort) {
        if(ListToSort == null || ListToSort.size() <= 1)
            return ListToSort;
            
        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = 0;
        
        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        
        for(SelectOption x : ListToSort)
        {
            if(x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
            else if(x.getLabel() > pivotValue.getLabel()) Greater.add(x);   
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(Sort(Less));
        returnList.add(pivotValue);
        returnList.addAll(Sort(Greater));
        return returnList; 
    }
    
    public ComprehensiveReport() {
        date y = date.today();
        timeFrameC1 = new contact();
        timeFrameC2 = new contact();
        selectedTimeRange = 'THIS MONTH';
        date yf = y.tostartofmonth();
        date yt = y.addmonths(1).tostartofmonth().adddays(-1);
        timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
        timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        //selectedOwners = 'ALL DATA';
        selectedOwners = 'DATA I OWN';
        selectedActivities1 = 'OPEN & COMPLETED ACTIVITIES';
        selectedActivities2 = 'TASKS AND EVENTS';
        selectedOpportunities = 'ANY';
        UserSearchTerm = '';
        checkActivities = true;
        checkOpportunities = true;
        checkAccounts = true;
        checkContacts = true;
        SelectedUserGroupType = 'Users';
        UserGroups = new List<UserGroup>();
        SelectedUserGroupElems = new List<String>();
        SelectedUserGroupElems2 = new List<String>();
        rendered = false;
        AvailableObjects = new List<SelectOption>();
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        for (String key : gd.keyset()) {
            Schema.DescribeSObjectResult sod = gd.get(key).getDescribe();
            if (!sod.isCustomSetting() && sod.isQueryable() && sod.IsCustom()) {
                AvailableObjects.add(new SelectOption(sod.getName(), sod.getLabel()));
            }
        }
        AvailableObjects = Sort(AvailableObjects);
        SelectedObjects = new List<SelectOption>();
    }
    
    public PageReference export(){
        
        dm = new ExcelDataModel(); 
        dm.data = new list<ExcelDataModel.SingleDataModel>();
        ExcelDataModel.SingleDataModel model;
        
        if (activityvar != null) {
            model = new ExcelDataModel.SingleDataModel();
            model.sheetname = 'Activities';
            model.headers = new list<string>{'Subject','Assigned','Date','Task','Priority','Status' ,'Contact2' ,'Related to','Created By'};
            model.data = new list<map<string,string>>();
            for (Activity act : activityvar){
                map<string,string> rowdata = new map<string,string>();
                if (act.getSubject() == NULL)
                    rowdata.put('Subject', '');
                else
                    rowdata.put('Subject', act.getSubject());
                    
                if (act.getAssigned() == NULL)
                    rowdata.put('Assigned', '');
                else
                    rowdata.put('Assigned', act.getAssigned());
                    
                if (act.getDate() == NULL)
                    rowdata.put('Date', '');
                else
                    rowdata.put('Date', act.getDate().format());
                    
                if (act.getTask() == true)
                    rowdata.put('Task', 'Yes');
                else
                    rowdata.put('Task', 'No');  
                    
                if (act.getPriority() == NULL)
                    rowdata.put('Priority', '');
                else    
                    rowdata.put('Priority', act.getPriority());
                    
                if (act.getStatus() == NULL)
                    rowdata.put('Status', '');
                else
                    rowdata.put('Status', act.getStatus());
                    
                if (act.getContact() == NULL)
                    rowdata.put('Contact2', '');
                else
                    rowdata.put('Contact2', act.getContact());
                    
                /*if (act.getContact() == NULL)
                    rowdata.put('Lead', '');
                else
                    rowdata.put('Lead', act.getContact());*/
                    
                if (act.getOpportunity() == NULL)
                    rowdata.put('Related to', '');
                else
                    rowdata.put('Related to', act.getOpportunity());
                    
                if (act.getCreatedBy() == NULL)
                    rowdata.put('Created BY', '');
                else
                    rowdata.put('Created By', act.getCreatedBy());
                model.data.add(rowdata);
            } 
            dm.data.add(model);
        }
        
        if (oppvar != null) {
            model = new ExcelDataModel.SingleDataModel();
            model.sheetname = 'Opportunities';
            model.headers = new list<string>{'Opportunity Name', 'Account Name', 'Type', 'Lead source', 'Amount', 'Closed Date', 'Probability %', 'Owner'};
            model.data = new list<map<string, string>>();
            for (Opportunity opp : oppvar){
                map<string,string> rowdata = new map<string,string>();
                if (opp.Account.Name == NULL)
                    rowdata.put('Opportunity Name', '');
                else
                    rowdata.put('Opportunity Name', opp.Account.Name);
                    
                if (opp.Name == NULL)
                    rowdata.put('Account Name', '');
                else
                    rowdata.put('Account Name', opp.Name);
                    
                if (opp.Type == NULL)
                    rowdata.put('Type', '');
                else
                    rowdata.put('Type', opp.Type);
                    
                if (opp.LeadSource == NULL)
                    rowdata.put('Lead source', '');
                else
                    rowdata.put('Lead source', opp.LeadSource);
                    
                if (opp.Amount == NULL)
                    rowdata.put('Amount', '');
                else
                    rowdata.put('Amount', opp.Amount.format());
                    
                if (opp.CloseDate == NULL)
                    rowdata.put('Closed Date', '');
                else
                    rowdata.put('Closed Date', opp.CloseDate.format());
                    
                if (opp.Probability == NULL)
                    rowdata.put('Probability %', '');
                else
                    rowdata.put('Probability %', opp.Probability.format());
                    
                if (opp.Owner.Name == NULL)
                    rowdata.put('Owner', '');
                else
                    rowdata.put('Owner', opp.Owner.Name);
                model.data.add(rowdata);    
            }
            dm.data.add(model);
        }
        
        if (accvar != null) {
            model = new ExcelDataModel.SingleDataModel();
            model.sheetname = 'Accounts';
            model.headers  = new list<string>{'Account Name', 'Industry', 'Billing Street', 'Billing City', 'Billing State', 'Billing Zipcode', 'Owner'};
            model.data = new list<map<string,string>>();
            for (Account acc : accvar) {
                map<string,string> rowdata = new map<string,string>();
                if (acc.Name == NULL)
                    rowdata.put('Account Name', '');
                else
                    rowdata.put('Account Name', acc.Name);
                    
                if (acc.Industry == NULL)
                    rowdata.put('Industry', '');
                else
                    rowdata.put('Industry', acc.Industry);
                    
                if (acc.BillingStreet == NULL)
                    rowdata.put('Billing Street', '');
                else
                    rowdata.put('Billing Street', acc.BillingStreet);
                    
                if (acc.BillingCity == NULL)
                    rowdata.put('Billing City', '');
                else    
                    rowdata.put('Billing City', acc.BillingCity);
                
                if (acc.BillingState == NULL)
                    rowdata.put('Billing State', '');
                else
                    rowdata.put('Billing State', acc.BillingState);
                
                if (acc.BillingPostalCode == NULL)
                    rowdata.put('Billing Zipcode', '');
                else
                    rowdata.put('Billing Zipcode', acc.BillingPostalCode);
                
                if (acc.Owner.Name == NULL)
                    rowdata.put('Owner', '');
                else
                    rowdata.put('Owner', acc.Owner.Name);
                model.data.add(rowdata);
             }
             dm.data.add(model);
        }
        
        if (contvar != null) { 
            model = new ExcelDataModel.SingleDataModel();
            model.sheetname = 'Contacts';
            model.headers = new list<string>{'Name', 'Account Name', 'Phone', 'Email', 'Mailing Street', 'Mailing City', 'Mailing State', 'Mailing Zipcode', 'Owner'};
            model.data = new list<map<string,string>>();
            for (Contact cont : contvar){
                map<string,string> rowdata = new map<string,string>();
                //Account.Name, Name, FirstName, LastName, Phone, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode, Owner.Name
                if (cont.Account.Name == NULL)
                    rowdata.put('Name', '');
                else
                    rowdata.put('Name', cont.Account.Name);
                
                if (cont.Name == NULL)
                    rowdata.put('Account Name', '');
                else
                    rowdata.put('Account Name', cont.Name);
                    
                if (cont.Phone == NULL)
                    rowdata.put('Phone', '');
                else
                    rowdata.put('Phone', cont.Phone);
                
                if (cont.Email == NULL)
                    rowdata.put('Email', '');
                else
                    rowdata.put('Email', cont.Email);
                    
                if (cont.MailingStreet == NULL)
                    rowdata.put('Mailing Street', '');
                else    
                    rowdata.put('Mailing Street', cont.MailingStreet);
                
                if (cont.MailingCity == NULL)
                    rowdata.put('Mailing City', '');
                else
                    rowdata.put('Mailing City', cont.MailingCity);
                    
                if (cont.MailingState == NULL)
                    rowdata.put('Mailing State', '');
                else
                    rowdata.put('Mailing State', cont.MailingState);
                    
                if (cont.MailingPostalCode == NULL)
                    rowdata.put('Mailing Zipcode', '');
                else    
                    rowdata.put('Mailing Zipcode', cont.MailingPostalCode);
                
                if (cont.Owner.Name == NULL)
                    rowdata.put('Owner', '');
                else
                    rowdata.put('Owner', cont.Owner.Name);
                model.data.add(rowdata);
            }
            dm.data.add(model);
        }
        
        for (String ObjectName : otherObjectsVar.keyset()) {
            model = new ExcelDataModel.SingleDataModel();
            model.sheetname = ObjectName;
            model.headers = new list<string>();
            if (otherObjectsVar.get(ObjectName).hasName)
                model.headers.add('Name');
            else
                model.headers.add('Id');
            for (string fieldKey : otherObjectsVar.get(ObjectName).fieldsY.keyset())
                model.headers.add(otherObjectsVar.get(ObjectName).fieldsY.get(fieldKey));
            model.data = new list<map<string,string>>();
            Schema.SObjectType objType = null;
            for (sObjectWrapper sobj : otherObjectsVar.get(ObjectName).objects.values()) {
                if (objType == null)
                    objType = sobj.obj.getSObjectType();
                map<string,string> rowdata = new map<string,string>();
                if (otherObjectsVar.get(ObjectName).hasName) {
                    if (sobj.obj.get('Name') == NULL)
                        rowdata.put('Name', '');
                    else
                        rowdata.put('Name', (string)sobj.obj.get('Name'));
                } else {
                    if (sobj.obj.get('Id') == NULL)
                        rowdata.put('Id', '');
                    else
                        rowdata.put('Id', (string)sobj.obj.get('Id'));
                }
                for (string fieldKey : otherObjectsVar.get(ObjectName).fieldsY.keyset())
                    if (sobj.obj.get(fieldKey) == null)
                        rowdata.put(otherObjectsVar.get(ObjectName).fieldsY.get(fieldKey), '');
                    else
                        rowdata.put(otherObjectsVar.get(ObjectName).fieldsY.get(fieldKey), string.valueof(sobj.obj.get(fieldKey)));
                
                model.data.add(rowdata);
            }
            dm.data.add(model);
        }
        
        PageReference acctPage = Page.ExcelGenerate;
        acctPage.setRedirect(false);
        return acctPage;
        
    }
       
    public void calculatedate() {
        date y,y1,y2;
        y=date.today();
        
        if (selectedTimeRange == 'Current FY') {
            timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
            timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
        }
        
        if (selectedTimeRange == 'Previous FY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-1,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()-1,12,31);
        }
        
        if (selectedTimeRange == 'Previous 2 FY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-2,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()-1,12,31);
        }
        
        if (selectedTimeRange == '2 FY Ago') {
            timeFrameC1.birthdate = date.newInstance(y.year()-2,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()-2,12,31);
        }
        
        if (selectedTimeRange == 'Next FY') {
            timeFrameC1.birthdate = date.newInstance(y.year()+1,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()+1,12,31);
        }
            
        if (selectedTimeRange == 'Current and Previous FY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-1,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
        }
        
        if (selectedTimeRange == 'Current and Previous 2 FY') {   
            timeFrameC1.birthdate = date.newInstance(y.year()-2,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
        }
        
        if (selectedTimeRange == 'Current and Next FY') {
            timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()+1,12,31);
        }
        
        if (selectedTimeRange == 'Current FQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),3,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
        }
        
        if (selectedTimeRange == 'Current and Next FQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,3,31);
            }
        }
        
        if (selectedTimeRange == 'Current and Previous FQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year()-1,10,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),3,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
        }
        
        if (selectedTimeRange == 'Next FQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year()+1,1,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,3,31);
            }
        }
        
        if (selectedTimeRange == 'Previous FQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year()-1,10,1);
                timeFrameC2.birthdate = date.newInstance(y.year()-1,12,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),3,31);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
        }
        if (selectedTimeRange == 'Current and Next 3 FQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,3,31);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,6,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,9,30);
            }
        }
            
        if (selectedTimeRange == 'Current CY') {  
            timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
            timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
        }
         
        if (selectedTimeRange == 'Previous CY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-1,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()-1,12,31);
        }
        
        if (selectedTimeRange == 'Previous 2 CY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-2,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()-1,12,31);
        }
        
        if (selectedTimeRange == '2 CY Ago') {
            timeFrameC1.birthdate = date.newInstance(y.year()-2,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()-2,12,31);
        }
        
        if (selectedTimeRange == 'Next CY') {
            timeFrameC1.birthdate = date.newInstance(y.year()+1,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()+1,12,31);
        }
        
        if (selectedTimeRange == 'Current and Previous CY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-1,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
        }
        
        if (selectedTimeRange == 'Current and Previous 2 CY') {
            timeFrameC1.birthdate = date.newInstance(y.year()-2,1,1);
            timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
        }
        
        if (selectedTimeRange == 'Current and Next CY') {
            timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
            timeFrameC2.birthdate = date.newInstance(y.year()+1,12,31);
        }
            
        if (selectedTimeRange == 'Current CQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),3,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
        }
        
        if (selectedTimeRange == 'Current and Next CQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,3,31);
            }
        }
        
        if (selectedTimeRange == 'Current and Previous CQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year()-1,10,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),3,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
        }
        
        if (selectedTimeRange == 'Next CQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year()+1,1,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,3,31);
            }
        }
        
        if (selectedTimeRange == 'Previous CQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year()-1,10,1);
                timeFrameC2.birthdate = date.newInstance(y.year()-1,12,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),3,31);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),6,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),9,30);
            }
        }
        
        if (selectedTimeRange == 'Current and Next 3 CQ') {
            if ((y.month() >= 1) && (y.month()<=3)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),1,1);
                timeFrameC2.birthdate = date.newInstance(y.year(),12,31);
            }
            if ((y.month()>= 4) && (y.month()<=6)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),4,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,3,31);
            }
            if ((y.month()>= 7) && (y.month()<=9)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),7,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,6,30);
            }
            if ((y.month()>= 10) && (y.month()<=12)) {
                timeFrameC1.birthdate = date.newInstance(y.year(),10,1);
                timeFrameC2.birthdate = date.newInstance(y.year()+1,9,30);
            }
        }
            
        if (selectedTimeRange == 'Last Month') {
            date yf = y.addmonths(-1).tostartofmonth();
            date yt = y.tostartofmonth().adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'This Month') {
            date yf = y.tostartofmonth();
            date yt = y.addmonths(1).tostartofmonth().adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'Next Month') {
            date yf = y.addmonths(1).tostartofmonth();
            date yt = y.addmonths(2).tostartofmonth().adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }

        if (selectedTimeRange == 'Current and Previous Month') {
            date yf = y.addmonths(-1).tostartofmonth();
            date yt = y.addmonths(1).tostartofmonth().adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }

        if (selectedTimeRange == 'Current and Next Month') {
            date yf = y.tostartofmonth();
            date yt = y.addmonths(2).tostartofmonth().adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'Last Week') {
            date yf = y.tostartofweek().adddays(-7);
            date yt = y.tostartofweek().adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }

        if (selectedTimeRange == 'This Week') {
            date yf = y.tostartofweek();
            date yt = y.tostartofweek().adddays(6);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }

        if (selectedTimeRange == 'Next Week') {
            date yf = y.tostartofweek().adddays(7);
            date yt = y.tostartofweek().adddays(13);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'Yesterday') {
            date yf = y.adddays(-1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
        }
        
        if (selectedTimeRange == 'Today') {
            timeFrameC1.birthdate = date.newInstance(y.year(), y.month(), y.day());
            timeFrameC2.birthdate = date.newInstance(y.year(), y.month(), y.day());
        }
        
        if (selectedTimeRange == 'Tomorrow') {
            date yf = y.adddays(1);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
        }
        
        if (selectedTimeRange == 'Last 7 Days') {
            date yf = y.adddays(-6);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(y.year(), y.month(), y.day());
        }
        
        if (selectedTimeRange == 'Last 30 Days') {
            date yf = y.adddays(-29);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(y.year(), y.month(), y.day());
        }
        
        if (selectedTimeRange == 'Last 60 Days') {
            date yf = y.adddays(-59);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(y.year(), y.month(), y.day());
        }
        
        if (selectedTimeRange == 'Last 90 Days') {
            date yf = y.adddays(-89);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(y.year(), y.month(), y.day());
        }
        
        if (selectedTimeRange == 'Last 120 Days') {
            date yf = y.adddays(-119);
            timeFrameC1.birthdate = date.newInstance(yf.year(), yf.month(), yf.day());
            timeFrameC2.birthdate = date.newInstance(y.year(), y.month(), y.day());
        }
        
        if (selectedTimeRange == 'Next 7 Days') {
            date yt = y.adddays(6);
            timeFrameC1.birthdate = date.newInstance(y.year(), y.month(), y.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }

        if (selectedTimeRange == 'Next 30 Days') {
            date yt = y.adddays(29);
            timeFrameC1.birthdate = date.newInstance(y.year(), y.month(), y.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'Next 60 Days') {
            date yt = y.adddays(59);
            timeFrameC1.birthdate = date.newInstance(y.year(), y.month(), y.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'Next 90 Days') {
            date yt = y.adddays(89);
            timeFrameC1.birthdate = date.newInstance(y.year(), y.month(), y.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
        
        if (selectedTimeRange == 'Next 120 Days'){
            date yt = y.adddays(119);
            timeFrameC1.birthdate = date.newInstance(y.year(), y.month(), y.day());
            timeFrameC2.birthdate = date.newInstance(yt.year(), yt.month(), yt.day());
        }
    }
       
    public void changetocustom() {
        selectedTimeRange= 'CUSTOM';
    }
       
    public list <selectOption> getRitems() {
        list <selectOption> options = new list <selectOption>() ;
        //options.add(new selectOption('ALL DATA' , 'All Data'));
        options.add(new selectOption('DATA I OWN' , 'Data I Own' ));
        options.add(new selectOption('MY TEAM\'S DATA' , 'My Team\'s Data' ));
        options.add(new selectOption('DATA OF SPECIFIC GROUP OF USERS' , 'Data Of Specific Group Of Users'));
        return options;
    }
       
    public list <selectOption> getDitems() {
        list <selectOption> options = new list<selectOption>();
        options.add(new selectOption('CUSTOM' , 'Custom'));
        options.add(new selectOption('CURRENT FY' , 'Current FY' ));
        options.add(new selectOption('PREVIOUS FY' , 'Previous FY'));
        options.add(new selectOption('PREVIOUS 2 FY' , 'Previous 2 FY'));
        options.add(new selectOption('2 FY AGO' , '2 FY Ago'));
        options.add(new selectOption('NEXT FY' , 'Next FY'));
        options.add(new selectOption('CURRENT AND PREVIOUS FY' , 'Current and Previous FY'));
        options.add(new selectOption('CURRENT AND PREVIOUS 2 FY' , 'Current and Previous 2 FY'));
        options.add(new selectOption('CURRENT AND NEXT FY' , 'Current and Next FY'));
        options.add(new selectOption('CURRENT FQ' , 'Current FQ'));
        options.add(new selectOption('CURRENT AND NEXT FQ' , 'Current and Next FQ'));
        options.add(new selectOption('CURRENT AND PREVIOUS FQ' , 'Current and Previous FQ'));
        options.add(new selectOption('NEXT FQ' , 'Next FQ'));
        options.add(new selectOption('PREVIOUS FQ' , 'Previous FQ'));
        options.add(new selectOption('CURRENT AND NEXT 3 FQ' , 'Current and Next 3 FQ'));
        options.add(new selectOption('CURRENT CY' , 'Current CY'));
        options.add(new selectOption('PREVIOUS CY' , 'Previous CY'));
        options.add(new selectOption('PREVIOUS 2 CY' , 'Previous 2 CY'));
        options.add(new selectOption('2 CY AGO' , '2 CY Ago'));
        options.add(new selectOption('NEXT CY' , 'Next CY'));
        options.add(new selectOption('CURRENT AND PREVIOUS CY' , 'Current and Previous CY'));
        options.add(new selectOption('CURRENT AND PREVIOUS 2 CY' , 'Current and Previous 2 CY'));
        options.add(new selectOption('CURRENT AND NEXT CY' , 'Current and Next CY'));
        options.add(new selectOption('CURRENT CQ' , 'Current CQ'));
        options.add(new selectOption('CURRENT AND NEXT CQ' , 'Current and next CQ'));
        options.add(new selectOption('CURRENT AND PREVIOUS CQ' , 'Current and previous CQ'));
        options.add(new selectOption('NEXT CQ' , 'Next CQ'));
        options.add(new selectOption('PREVIOUS CQ' , 'Previous CQ'));
        options.add(new selectOption('CURRENT AND NEXT 3 CQ' , 'Current and Next 3 CQ'));
        options.add(new selectOption('LAST MONTH' , 'Last Month'));
        options.add(new selectOption('THIS MONTH' , 'This Month'));
        options.add(new selectOption('NEXT MONTH' , 'Next Month'));
        options.add(new selectOption('CURRENT AND PREVIOUS MONTH' , 'Current and Previous Month'));
        options.add(new selectOption('CURRENT AND NEXT MONTH' , 'Current and Next Month'));
        options.add(new selectOption('LAST WEEK' , 'Last Week'));
        options.add(new selectOption('THIS WEEK' , 'This Week'));
        options.add(new selectOption('NEXT WEEK' , 'Next Week'));
        options.add(new selectOption('YESTERDAY' , 'Yesterday'));
        options.add(new selectOption('TODAY' , 'Today'));
        options.add(new selectOption('TOMORROW' , 'Tomorrow'));
        options.add(new selectOption('LAST 7 DAYS' , 'Last 7 Days'));
        options.add(new selectOption('LAST 30 DAYS' , 'Last 30 Days'));
        options.add(new selectOption('LAST 60 DAYS' , 'Last 60 Days'));
        options.add(new selectOption('LAST 90 DAYS' , 'Last 90 Days'));
        options.add(new selectOption('LAST 120 DAYS' , 'Last 120 Days'));
        options.add(new selectOption('NEXT 7 DAYS' , 'Next 7 Days'));
        options.add(new selectOption('NEXT 30 DAYS' , 'Next 30 Days'));
        options.add(new selectOption('NEXT 60 DAYS' , 'Next 60 Days'));
        options.add(new selectOption('NEXT 90 DAYS' , 'Next 90 Days'));
        options.add(new selectOption('NEXT 120 DAYS' , 'Next 120 Days'));
        return options;
    }
       
    public list <selectOption> getActivitiesItems1() {
        list <selectOption> options = new list<selectOption>();
        options.add(new selectOption('OPEN ACTIVITIES' , 'Open Activities'));
        options.add(new selectOption('COMPLETED ACTIVITIES' , 'Completed Activities' ));
        options.add(new selectOption('OPEN & COMPLETED ACTIVITIES' , 'Open & Completed Activities'));
        return options;
    }
       
    public list <selectOption> getActivitiesItems2() {
        list <selectOption> options = new list<selectOption>();
        options.add(new selectOption('TASKS' , 'Tasks'));
        options.add(new selectOption('EVENTS' , 'Events' ));
        options.add(new selectOption('TASKS AND EVENTS' , 'Tasks and Events'));
        return options;
    }
       
    public list <selectOption> getOpportunitiesItems() {
        list <selectOption> options = new list<selectOption>();
        options.add(new selectOption('OPEN' , 'Open'));
        options.add(new selectOption('CLOSED' , 'Closed' ));
        options.add(new selectOption('CLOSED WON' , 'Closed Won'));
        options.add(new selectOption('ANY' , 'Any'));
        options.add(new selectOption('DOWNGRADED' , 'Downgraded'));
        return options;
    }
       
    public void display(){
        
        String users = '';
        if (selectedOwners == 'DATA I OWN') {
            users = '\'' + UserInfo.getUserId() + '\'';
        }
        if (selectedOwners == 'MY TEAM\'S DATA') {
            users = '\'' + UserInfo.getUserId() + '\'';
            List<User> usrxs = [SELECT Id FROM User WHERE UserRole.ParentRoleId = :UserInfo.getUserRoleId()];
            for (User usrx : usrxs)
                users += ',\'' + usrx.Id + '\'';
        }
        if (selectedOwners == 'DATA OF SPECIFIC GROUP OF USERS') {
            users = '';
            for (UserGroup ug : UserGroups) {
                if (ug.GroupType == 'Users') {
                    if (users != '')
                        users += ', ';
                    users += '\'' + ug.GroupId + '\'';
                }
                if (ug.GroupType == 'Roles' || ug.GroupType == 'Roles and Subordinates') {
                    List<User> usrxs = [SELECT Id FROM User WHERE UserRoleId = :ug.GroupId];
                    for (User usrx : usrxs) {
                        if (users != '')
                            users += ', ';
                        users += '\'' + usrx.Id + '\'';
                    }
                }
                if (ug.GroupType == 'Roles and Subordinates') {
                    List<User> usrxs = [SELECT Id FROM User WHERE UserRole.ParentRoleId = :ug.GroupId];
                    for (User usrx : usrxs) {
                        if (users != '')
                            users += ', ';
                        users += '\'' + usrx.Id + '\'';
                    }
                }
            }
            if (users == '') {
                return;
            }
        }
        
        string date1 = String.valueOf(timeFrameC1.birthdate) + 'T00:00:00Z';
        string date2 = String.valueOf(timeFrameC2.birthdate) + 'T23:59:59Z';
           
        activityvar = new List<Activity>();
        if (checkactivities == true) {
            string helpvar, helpvar1;
            if (selectedActivities2 == 'Tasks' || selectedActivities2 == 'Tasks and Events') {
                helpvar = 'SELECT Subject, Owner.Name, ActivityDate, Priority, Status, Who.Name, What.Name, CreatedBy.Name FROM Task WHERE (createddate >= ' + date1 + ' AND  createddate  <= ' + date2 + ') ';
                if (selectedActivities1 == 'Open Activities')
                    helpvar += 'AND Status != \'Completed\' ';
                if (selectedActivities1 == 'Completed Activities')
                    helpvar += ' AND Status = \'Completed\' ';
                if (selectedOwners != 'ALL DATA')
                    helpvar += ' AND OwnerId IN ('+ users +')';
                List<Task> taskvar = database.query(helpvar + ' LIMIT 500 ');
                for (Task ta : taskvar)
                    activityvar.add(new Activity(ta));
            }
            if (selectedActivities2 == 'Events' || selectedActivities2 == 'Tasks and Events') {
                helpvar1 = 'SELECT Subject, Owner.Name, ActivityDate, Who.Name, What.Name, CreatedBy.Name FROM Event WHERE (createddate >= ' + date1 + ' AND  createddate  <= ' + date2 + ') ';
                if (selectedOwners != 'ALL DATA')
                    helpvar1 += ' AND OwnerId IN ('+ users +')';
                List<Event> eventvar = database.query(helpvar1 + ' LIMIT 500');
                for (Event ev : eventvar)
                    activityvar.add(new Activity(ev));
            }
        }
       
        if (checkopportunities == true) {
            string helpvar;
            helpvar = 'SELECT Account.Name, Name, Type, LeadSource, Amount, CloseDate, Probability, Owner.Name FROM Opportunity WHERE (createddate >= '+ date1 + ' AND  createddate  <= ' + date2 +') ';
            if (selectedOpportunities == 'Open')
                helpvar += 'AND (StageName= \'Information Gathering\' OR StageName= \'Plan Development \' OR StageName=\'Drawing Approval \' OR StageName=\'Quote Submitted\')';
            if (selectedOpportunities == 'Closed')
                helpvar += ' AND StageName= \'Closed\'';
            if (selectedOpportunities == 'Closed Won')
                helpvar += ' AND StageName= \'Closed Won\'';
            if (selectedOwners != 'ALL DATA')
                helpvar += ' AND OwnerId IN ('+ users +')';
            oppvar = database.query(helpvar + ' LIMIT 500') ;           
        }
           
        if (checkaccounts == true) {
            string helpvar;
            helpvar = 'SELECT Name, Industry, BillingStreet, BillingCity, BillingState, BillingPostalCode, Owner.Name FROM Account WHERE (createddate >= '+ date1 + ' AND  createddate  <= ' + date2 +') ';
            if (selectedOwners != 'ALL DATA')
                helpvar += ' AND OwnerId IN ('+ users +')';
            accvar = database.query(helpvar + ' LIMIT 500');
        }
       
        if (checkcontacts == true) {
            string helpvar;
            helpvar = 'SELECT Account.Name, Name, FirstName, LastName, Phone, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode, Owner.Name FROM Contact WHERE (createddate >= '+ date1 + ' AND  createddate  <= ' + date2 +') ';
            if (selectedOwners != 'ALL DATA')
                helpvar += ' AND OwnerId IN ('+ users +')';
            contvar = database.query(helpvar + ' LIMIT 500');
        }
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        otherObjectsVar = new Map<String, sObjectListWrapper>();
        for (SelectOption so : SelectedObjects) {
            Map<String, String> fieldsList = new Map<String, String>();
            string addFields = '';
            Schema.DescribeSObjectResult sod = gd.get(so.getValue()).getDescribe();
            Map<String, Schema.FieldSet> FsMap = sod.fieldSets.getMap();
            if (FsMap.containsKey('ComprehensiveReport'))
                for (Schema.FieldSetMember f : FsMap.get('ComprehensiveReport').getFields())
                    if (f.getFieldPath() != 'Name') {
                        addFields += ', ' + f.getFieldPath();
                        fieldsList.put(f.getFieldPath(), f.getLabel());
                    }
                    
            boolean hasName = sod.fields.getMap().containsKey('Name');
            string helpvar;
            helpvar = 'SELECT Id ' + (hasName ? ', Name ' : '') + addFields + ' FROM ' + so.getValue() + ' WHERE (createddate >= '+ date1 + ' AND  createddate  <= ' + date2 +') ';
            if (selectedOwners != 'ALL DATA') {
                if (generateFldObjMapValues(so.getValue(),'OwnerId')) {
                    helpvar += ' AND OwnerId IN ('+ users +')';
                }
            }
            otherObjectsVar.put(so.getLabel(), new sObjectListWrapper(database.query(helpvar + ' LIMIT 500'), fieldsList, hasName));
        }
        rendered = true;
    }
    
    public class Activity {
        
        private Task task = null;
        private Event event = null;
        
        public Activity(Task newTask) {
            task = newTask;
        }
        
        public Activity(Event newEvent) {
            event = newEvent;
        }
        
        public boolean getTask() {
            return (task != null);
        }
        
        public void setTask(boolean value) {
        }
        
        public string getClickURL() { 
            if (event != null)
                return '/' + event.Id;
            if (task != null)
                return '/' + task.Id;
            return '';
        }
        
        public string getSubject() {
            if (event != null)
                return event.Subject;
            if (task != null)
                return task.Subject;
            return '';
        }
        
        public string getAssignedClickURL() {
            if (event != null)
                return '/' + event.OwnerId;
            if (task != null)
                return '/' + task.OwnerId;
            return '';
        }
        
        public string getAssigned() {
            if (event != null)
                return event.Owner.Name;
            if (task != null)
                return task.Owner.Name;
            return '';
        }
        
        public Date getDate() {
            if (event != null)
                return event.ActivityDate;
            if (task != null)
                return task.ActivityDate;
            return null;
        }
        
        public string getPriority() {
            if (task != null)
                return task.Priority;
            return '';
        }
        
        public string getStatus() {
            if (task != null)
                return task.Status;
            return '';
        }
        
        public string getContact() {
            if (event != null)
                return event.Who.Name;
            if (task != null)
                return task.Who.Name;
            return '';
        }
        
        public string getOpportunity() {
            if (event != null)
                return event.What.Name;
            if (task != null)
                return task.What.Name;
            return '';
        }
        
        public string getCreatedByClickURL() {
            if (event != null)
                return '/' + event.CreatedById;
            if (task != null)
                return '/' + task.CreatedById;
            return '';
        }
        
        public string getCreatedBy() {
            if (event != null)
                return event.CreatedBy.Name;
            if (task != null)
                return task.CreatedBy.Name;
            return '';
        }
        
    }
    
    public static boolean generateFldObjMapValues(String objName, String fieldName) {
        Map<String, Schema.SObjectField> fldObjMap;
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            fldObjMap = gd.get(objName).getDescribe().fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = new List<Schema.SObjectField>();
        for (Schema.SObjectField fld : fldObjMap.values()) {
            if (fld.getDescribe().isAccessible() && fld.getDescribe().getName() == fieldName) {
                return true;
            }
        }
        return false;
    }
    
    public static testmethod void test1() {
        comprehensiveReport crd = new comprehensiveReport();
        crd.selectedOwners = 'DATA OF SPECIFIC GROUP OF USERS';
        crd.getUserGroupTypes();
        List<SelectOption> ugs = crd.getUserGroupElems();
        crd.getRitems();
        List<SelectOption> dis = crd.getDitems();
        crd.getActivitiesItems1();
        crd.getActivitiesItems2();
        crd.getOpportunitiesItems();
        crd.SelectedUserGroupElems.add(ugs[0].getValue());
        crd.SelectedUserGroupElems.add(UserInfo.getUserId());
        crd.AddGroupElems();
        ugs = crd.getUserGroupElems2();
        crd.SelectedUserGroupElems2.add(ugs[0].getValue());
        crd.RemoveGroupElems();
        for (Selectoption di : dis) {
            crd.selectedTimeRange = di.getValue();
            crd.calculatedate();
        }
        //crd.changetocustom();  MLM - 06/30/15 Must comment out since Custom Dates not available on page
        crd.selectedTimeRange = 'THIS MONTH';
        //crd.calculatedate();  MLM - 06/30/15 Must comment out since Custom Dates not available on page
        Event ev = new Event();
        ev.DurationInMinutes = 15;
        ev.ActivityDateTime = Datetime.now();
        insert ev;
        Task ta = new Task();
        insert ta;
        Account ac = new Account();
        ac.Name = 'Test ac';
        insert ac;
        Opportunity op = new Opportunity();
        op.Name = 'Test op';
        op.AccountID = ac.ID;
        op.CloseDate = Date.today();
        op.StageName = 'Information Gathering' ;
        insert op;
        Contact co = new Contact();
        co.LastName = 'Test co';
        co.AccountID = ac.ID;
        insert co;
        crd.objsToAdd = new List<String>();
        crd.objsToAdd.add(crd.AvailableObjects[0].getValue());
        crd.Add();
        crd.objsToRem = new List<String>();
        crd.Rem();
        crd.display();
        crd.export();
        crd.activityvar[0].getTask();
        crd.activityvar[0].getSubject();
        crd.activityvar[0].getAssigned();
        crd.activityvar[0].getDate();
        crd.activityvar[0].getPriority();
        crd.activityvar[0].getStatus();
        crd.activityvar[0].getContact();
        crd.activityvar[0].getOpportunity();
        crd.activityvar[0].getCreatedBy();
        crd.activityvar[0].getCreatedByClickURL();
        crd.activityvar[0].getAssignedClickURL();
        crd.activityvar[0].getClickURL();
        crd.activityvar[1].getTask();
        crd.activityvar[1].getSubject();
        crd.activityvar[1].getAssigned();
        crd.activityvar[1].getDate();
        crd.activityvar[1].getPriority();
        crd.activityvar[1].getStatus();
        crd.activityvar[1].getContact();
        crd.activityvar[1].getOpportunity();
        crd.activityvar[1].getCreatedBy();
        crd.activityvar[1].getCreatedByClickURL();
        crd.activityvar[1].getAssignedClickURL();
        crd.activityvar[1].getClickURL();
    }
}
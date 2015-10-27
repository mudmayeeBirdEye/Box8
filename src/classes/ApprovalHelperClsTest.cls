/**
 * This class contains unit tests for validating the behavior of Apex class 'ApprovalHelperCls'.
 */ 
@isTest
private class ApprovalHelperClsTest {

    static testMethod void testDirectTOVAR() {
    	ApprovalHelperCls.describeRecordTypesById();
    	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
	    List<Account> accountList = new List<Account>();
	    Set<String> testid= new Set<String>();
	    Account accObj0 = new Account();
	    accObj0.Name = 'RCTest';
	    accObj0.recordTypeId =rtMapByName.get('Partner Account').getRecordTypeId();
	    system.debug('======= accObj0.recordTypeId ====== '+ accObj0.recordTypeId);
	    accObj0.Partner_Sign_Up_Date__c = System.today();
	    accObj0.Partner_ID__c = '1234';
	    accObj0.Current_Owner__c = System.Userinfo.getUserId();
	    //accObj0.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
	    insert accObj0;
	    system.debug('======= accObj0.recordTypeId ====== '+ accObj0.recordTypeId);
	    accountList.add(accObj0);
	    testid.add(accObj0.Id);
	    Test.startTest();
	    Account accObj = new Account();
	    accObj.Name = 'Rctest1';
	    accObj.ParentId = accObj0.Id;
	    accObj.RC_Account_Status__c ='Paid';
	    accObj0.Partner_ID__c = '1234';
	    accObj.recordTypeId = rtMapByName.get('Customer Account').getRecordTypeId();
	    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
	    accObj.RC_Signup_Date__c = System.Now();
	    accObj.Pay_Referral_Commissions__c = true;
	    accObj.Employees_Override__c = 45;
	    //accObj.ZI_No_of_Employees_Range__c = '50';
	    // accObj.No_of_Employees__c = '60';
	    //accObj.TV_No_of_Employees_Range__c = '60';
	    // accObj.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
	    insert accObj;
	    accObj = [SELECT Effective_No_of_Employees_Range__c, ZI_No_of_Employees_Range__c, Employees_Override__c, No_of_Employees__c FROM Account WHERE Id=:accObj.Id];
	    //Insert Opportunity
	    Opportunity opp = new Opportunity();  
	    opp.name = 'testOppoty';
	    opp.AccountId = accObj.id;
	    opp.Forecasted_Users__c = 50;
		opp.StageName = '3. Qualified';
		opp.CloseDate = System.today();	
	    insert opp;
	   // system.debug('======= opp.EmploRanggeh ====== '+ [SELECT Effective_No_of_Employees_Range__c FROM Opportunity WHERE Id=: opp.Id].Effective_No_of_Employees_Range__c);
	    // Inserting Partner User
	    Id p = [select id from profile where name='RC Partner Modify'].id;
	    Contact con = new Contact(LastName ='testCon',AccountId = accObj0.Id);
        insert con; 
        User user = new User(alias = 'test123', email='test@nemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noema.com');
        
        insert user; 
	    
    	// inserting Approval Object 
    	Approval__c appObj = new Approval__c();
    	if(ApprovalHelperCls.rtMapByID != NULL && ApprovalHelperCls.rtMapByID.get('Channel Cross Sell').getRecordTypeId() != NULL){
    		appObj.RecordTypeId = ApprovalHelperCls.rtMapByID.get('Channel Cross Sell').getRecordTypeId(); 
    	}
    	appObj.Account__c = accObj.id;
    	appObj.Type__c = 'Direct to VAR';
    	appObj.Opportunity__c = opp.id;
    	insert appObj;
    	appObj.Status__c = 'Approved';
    	appObj.Partner_Owner__c = user.Id;
    	update appObj;
        
    }
    static testMethod void testVARToDirect() {
    	ApprovalHelperCls.describeRecordTypesById();
    	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
	    List<Account> accountList = new List<Account>();
	    Set<String> testid= new Set<String>();
	    Account accObj0 = new Account();
	    accObj0.Name = 'RCTest';
	    accObj0.recordTypeId =rtMapByName.get('Partner Account').getRecordTypeId();
	    system.debug('======= accObj0.recordTypeId ====== '+ accObj0.recordTypeId);
	    accObj0.Partner_Sign_Up_Date__c = System.today();
	    accObj0.Partner_ID__c = '1234';
	    //accObj0.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
	    insert accObj0;
	    system.debug('======= accObj0.recordTypeId ====== '+ accObj0.recordTypeId);
	    accountList.add(accObj0);
	    testid.add(accObj0.Id);
	    Test.startTest();
	    Account accObj = new Account();
	    accObj.Name = 'Rctest1';
	    accObj.ParentId = accObj0.Id;
	    accObj.RC_Account_Status__c ='Paid';
	    accObj0.Partner_ID__c = '1234';
	    accObj.recordTypeId = rtMapByName.get('Customer Account').getRecordTypeId();
	    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
	    accObj.RC_Signup_Date__c = System.Now();
	    accObj.Pay_Referral_Commissions__c = true;
	    accObj.Employees_Override__c = 45;
	    //accObj.ZI_No_of_Employees_Range__c = '50';
	    // accObj.No_of_Employees__c = '60';
	    //accObj.TV_No_of_Employees_Range__c = '60';
	    // accObj.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
	    insert accObj;
	    accObj = [SELECT Effective_No_of_Employees_Range__c, ZI_No_of_Employees_Range__c, Employees_Override__c, No_of_Employees__c FROM Account WHERE Id=:accObj.Id];
	    //Insert Opportunity
	    Opportunity opp = new Opportunity();  
	    opp.name = 'testOppoty';
	    opp.AccountId = accObj.id;
	    opp.Forecasted_Users__c = 50;
		opp.StageName = '3. Qualified';
		opp.CloseDate = System.today();	
	    insert opp;
	   // system.debug('======= opp.EmploRanggeh ====== '+ [SELECT Effective_No_of_Employees_Range__c FROM Opportunity WHERE Id=: opp.Id].Effective_No_of_Employees_Range__c);
    	// inserting Approval Object 
    	Approval__c appObj = new Approval__c();
    	if(ApprovalHelperCls.rtMapByID != NULL && ApprovalHelperCls.rtMapByID.get('Channel Cross Sell').getRecordTypeId() != NULL){
    		appObj.RecordTypeId = ApprovalHelperCls.rtMapByID.get('Channel Cross Sell').getRecordTypeId(); 
    	}
    	appObj.Account__c = accObj.id;
    	appObj.Type__c = 'VAR to Direct';
    	appObj.Opportunity__c = opp.id;
    	insert appObj;
    	System.debug('************ = '+ ApprovalHelperCls.opptyToUpdateList);
    	appObj.Status__c = 'Approved';
    	update appObj;
    	System.debug('************ 11111111111 = '+ ApprovalHelperCls.opptyToUpdateList);
    	appObj.Direct_Sales_Rep__c = System.Userinfo.getUserId();
    	System.debug('************ 2222222222 = '+ ApprovalHelperCls.opptyToUpdateList);
    	update appObj;
    	System.debug('************ 333333333 = '+ ApprovalHelperCls.opptyToUpdateList);
        
    }

    static testMethod void testAutoApprovalOnLeadConvert() {
    	
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
    	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
    	TriggerHandler.BY_PASS_CONTACT_ON_INSERT(); 
    	User indiaTeamUser = [Select id,IsActive,Email from user where Id = '00580000003d9rB'];
    	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
	    List<Account> accountList = new List<Account>();
	    Set<String> testid= new Set<String>();
	    Account accObj0 = new Account();
	    accObj0.Name = 'RCTest';
	    accObj0.recordTypeId =rtMapByName.get('Partner Account').getRecordTypeId();
	    system.debug('======= accObj0.recordTypeId ====== '+ accObj0.recordTypeId);
	    accObj0.Partner_Sign_Up_Date__c = System.today();
	    accObj0.Partner_ID__c = '1234';
	    accObj0.Current_Owner__c = System.Userinfo.getUserId();
	    //accObj0.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
	    insert accObj0;
    	// Inserting Partner User
	    Id p = [select id from profile where name='RC Partner Modify'].id;
	    Contact con = new Contact(LastName ='testCon',AccountId = accObj0.Id);
        insert con; 
        User user = new User(alias = 'test123', email='test@nemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noema.com');
        
        insert user;
        
        /********************Segement Object Data Created**************************************************/
		
		Segment_Data__c segData = new Segment_Data__c(Type__c='Industry',Attribute_1__c='Education',Attribute_2__c='SLEd',Postal_Code__c='');
		Segment_Data__c segData1 = new Segment_Data__c(Type__c='Country',Attribute_1__c='USA',Attribute_2__c='United States',Postal_Code__c='');
		Segment_Data__c segData2 = new Segment_Data__c(Type__c='Area Code',Attribute_1__c='991',Attribute_2__c='United States',Postal_Code__c='100');
		
		Segment_Data__c segData3 = new Segment_Data__c(Type__c='Industry',Attribute_1__c='Other',Attribute_2__c='Other',Postal_Code__c='');
		Segment_Data__c segData4 = new Segment_Data__c(Type__c='Country',Attribute_1__c='CN',Attribute_2__c='Canada',Postal_Code__c='');
		Segment_Data__c segData5 = new Segment_Data__c(Type__c='Area Code',Attribute_1__c='999',Attribute_2__c='Canada',Postal_Code__c='100');
		
		List<Segment_Data__c> segmentDataList = new List<Segment_Data__c>{segData,segData1,segData2,segData3,segData4,segData5};
		insert segmentDataList;
		/*************************************************************************************************/
		
		/********************Territory Object Data Created**************************************************/
		
		Territory_Data__c terrData = new Territory_Data__c(Type__c='Industry-Geo',Name='Data1',Country__c='United States',Industry__c='Other',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Alternate_Owner__c=indiaTeamUser.Id);
		Territory_Data__c terrData1 = new Territory_Data__c(Type__c='Geo',Name='Data2',Country__c='United States',Industry__c='',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Territory_Owner__c=indiaTeamUser.Id);			
		
		Territory_Data__c terrData2 = new Territory_Data__c(Type__c='Industry-Geo',Name='Data3',Country__c='Canada',Industry__c='Education',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Alternate_Owner__c=indiaTeamUser.Id);
		Territory_Data__c terrData3 = new Territory_Data__c(Type__c='Geo',Name='Data4',Country__c='Canada',Industry__c='',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Territory_Owner__c=indiaTeamUser.Id);
		
		List<Territory_Data__c> territoryDataList = new List<Territory_Data__c>{terrData,terrData1,terrData2,terrData3};
		insert territoryDataList;
		/*************************************************************************************************/	
		
		/*************************Custom Label data Created*******************************************/
		
		
		system.debug('Label=='+Label.Territory_Employee_Size);
		

		/***********************************************************************************************/
    	
     List<Lead> leadList = new List<Lead>();
        Lead leadObj = new Lead(); 
        leadObj.FirstName='testFirst';
        leadObj.LastName='testLast';
        leadObj.Company='testCompany';
        leadObj.Email='test2.test@test.com';
        leadObj.Phone='9910106804';
        leadObj.LeadSource = 'Inbound Call';
        leadObj.Notes__c = 'Test Notes'; 
        leadObj.Website = 'http://test.com';
        leadObj.NumberOfEmployees = 123;
        leadObj.Industry = 'Other';
        leadObj.NumberOfEmployees__c = '50-249';
        leadObj.Number_of_Locations__c = '50+';
        leadObj.Agent_Email_Address__c = 'test@test.com';  
        leadObj.Eligible_Protection_Period__c = system.today();
        leadObj.Status = '2. Contacted';
        leadObj.Country__c='USA';
        leadObj.Zip_Code__c = '100';
        //leadObj.OwnerId = user.Id;
        leadObj.LS_Primary_NAIC__c='1';
        leadObj.Employees_Override__c='50-249';
        
        Lead leadObj2 = new Lead(); 
        leadObj2.FirstName='testFirst';
        leadObj2.LastName='testLast';
        leadObj2.Company='testCompany';
        leadObj2.Email='test2.test@test.com';
        leadObj2.Phone='9910106804';
        leadObj2.LeadSource = 'Inbound Call';
        leadObj2.Notes__c = 'Test Notes'; 
        leadObj2.Website = 'http://test.com';
        leadObj2.NumberOfEmployees = 123;
        leadObj2.Industry = 'Other';
        leadObj2.NumberOfEmployees__c = '20';
        leadObj2.Number_of_Locations__c = '50+';
        leadObj2.Agent_Email_Address__c = 'test@test.com';  
        leadObj2.Eligible_Protection_Period__c = system.today();
        leadObj2.Status = '2. Contacted';
        leadObj2.Country__c='USA';
        leadObj2.Zip_Code__c = '100';
        //leadObj2.OwnerId = user.Id;
        leadObj2.LS_Primary_NAIC__c='1';
        leadObj2.Employees_Override__c='50-249';
        
        Lead leadObj1 = new Lead(); 
        leadObj1.FirstName='testFirst';
        leadObj1.LastName='testLast';
        leadObj1.Company='testCompany';
        leadObj1.Email='test2.test@test.com';
        leadObj1.Phone='9910106804';
        leadObj1.LeadSource = 'Inbound Call';
        leadObj1.Notes__c = 'Test Notes'; 
        leadObj1.Website = 'http://test.com';
        leadObj1.NumberOfEmployees = 123;
        leadObj1.Industry = 'Other';
        leadObj1.NumberOfEmployees__c = '20+';
        leadObj1.Number_of_Locations__c = '50+';
        leadObj1.Agent_Email_Address__c = 'test@test.com';  
        leadObj1.Eligible_Protection_Period__c = system.today();
        leadObj1.Status = '2. Contacted';
        leadObj1.Country__c='USA';
        leadObj1.Zip_Code__c = '100';
        //leadObj1.OwnerId = user.Id;
        leadObj1.LS_Primary_NAIC__c='1';
        leadObj1.Employees_Override__c='50-249';
        leadList.add(leadObj1);
        leadList.add(leadObj);
        leadList.add(leadObj2);
        
        System.runAs(user){
        	insert leadList; 
        	System.Test.startTest();
        	
	        Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(leadObj.id);
			
			LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
			lc.setConvertedStatus(convertStatus.MasterLabel);
			
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			System.assert(lcr.isSuccess());
			System.test.stopTest();
        }
        
       
    }
    static testMethod void testBadValue() {
    	List<Lead> leadList = new List<Lead>();
    	Lead leadObj = new Lead(); 
        leadObj.FirstName='testFirst';
        leadObj.LastName='testLast';
        leadObj.Company='testCompany';
        leadObj.Email='test2.test@test.com';
        leadObj.Phone='9910106804';
        leadObj.LeadSource = 'Inbound Call';
        leadObj.Notes__c = 'Test Notes'; 
        leadObj.Website = 'http://test.com';
        leadObj.NumberOfEmployees = 123;
        leadObj.Industry = 'Other';
        leadObj.NumberOfEmployees__c = '50-249';
        leadObj.Number_of_Locations__c = '50+';
        leadObj.Agent_Email_Address__c = 'test@test.com';  
        leadObj.Eligible_Protection_Period__c = system.today();
        leadObj.Status = '2. Contacted';
        leadObj.Country__c='USA';
        leadObj.Zip_Code__c = '100';
        //leadObj.OwnerId = user.Id;
        leadObj.LS_Primary_NAIC__c='1';
        leadObj.Employees_Override__c='50-249';
        
        Lead leadObj2 = new Lead(); 
        leadObj2.FirstName='testFirst';
        leadObj2.LastName='testLast';
        leadObj2.Company='testCompany';
        leadObj2.Email='test2.test@test.com';
        leadObj2.Phone='9910106804';
        leadObj2.LeadSource = 'Inbound Call';
        leadObj2.Notes__c = 'Test Notes'; 
        leadObj2.Website = 'http://test.com';
        leadObj2.NumberOfEmployees = 123;
        leadObj2.Industry = 'Other';
        leadObj2.NumberOfEmployees__c = '20';
        leadObj2.Number_of_Locations__c = '50+';
        leadObj2.Agent_Email_Address__c = 'test@test.com';  
        leadObj2.Eligible_Protection_Period__c = system.today();
        leadObj2.Status = '2. Contacted';
        leadObj2.Country__c='USA';
        leadObj2.Zip_Code__c = '100';
        //leadObj2.OwnerId = user.Id;
        leadObj2.LS_Primary_NAIC__c='1';
        leadObj2.Employees_Override__c='50-249';
        
        Lead leadObj1 = new Lead(); 
        leadObj1.FirstName='testFirst';
        leadObj1.LastName='testLast';
        leadObj1.Company='testCompany';
        leadObj1.Email='test2.test@test.com';
        leadObj1.Phone='9910106804';
        leadObj1.LeadSource = 'Inbound Call';
        leadObj1.Notes__c = 'Test Notes'; 
        leadObj1.Website = 'http://test.com';
        leadObj1.NumberOfEmployees = 123;
        leadObj1.Industry = 'Other';
        leadObj1.NumberOfEmployees__c = '20+';
        leadObj1.Number_of_Locations__c = '50+';
        leadObj1.Agent_Email_Address__c = 'test@test.com';  
        leadObj1.Eligible_Protection_Period__c = system.today();
        leadObj1.Status = '2. Contacted';
        leadObj1.Country__c='USA';
        leadObj1.Zip_Code__c = '100';
        //leadObj1.OwnerId = user.Id;
        leadObj1.LS_Primary_NAIC__c='1';
        leadObj1.Employees_Override__c='50-249';
        leadList.add(leadObj1);
        leadList.add(leadObj);
        leadList.add(leadObj2);
        
        insert leadList; 
        
        String expected = ''
                + '"FieldName","delimit1","BadValues","delimit2","GoodValues","delimit3","EOL"\n'
                + '"NumberOfEmployees__c","#","20+","#","Oct-49","#","#EOL#"\n'
				+ '"NumberOfEmployees__c","#","20-24","#","Oct-49","#","#EOL#"\n'
                ;
        	Folder fd = [SELECT Id FROM Folder WHERE Name='Public Documents' LIMIT 1]; 
        	Document dummyDocument = new Document();
            dummyDocument.name = 'No_Employee_Mapping';
            dummyDocument.body = Blob.valueOf(expected);
            dummyDocument.folderId=fd.Id;
            dummyDocument.isPublic=true;
            dummyDocument.type='csv';
            
            insert dummyDocument;
        	
        	LeadTriggerHelperExt.getCheckForBadValue(leadList);
    }    
    
}
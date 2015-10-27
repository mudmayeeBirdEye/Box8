@isTest
private class Test_InventionTicket {

    static testMethod void myUnitTest() {
    	try{
	    	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
	        User u = new User(Alias = 'standt', Email='standardusertest123@testorg.com', 
	            EmailEncodingKey='UTF-8', LastName='Testingtest@123', LanguageLocaleKey='en_US', 
	            LocaleSidKey='en_US', ProfileId = p.Id, 
	            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest123@testorg.com');
	    	insert u;
	    	Legal_Requests__c legalObj = new Legal_Requests__c(); 
	        ApexPages.StandardController sc = new ApexPages.standardController(legalObj);
	        InventionTicket clsObj = new InventionTicket(sc);
	        clsObj.cancelButton();
	        clsObj.inventorId = u.id;
	        clsObj.inventorNameFun(); 
	        legalObj.Title_of_Invention__c = 'Test Data';     
	        clsObj.saveData();
	        clsObj.watcherObj.Advisor_Name__c = u.id;
	        clsObj.saveWatcher();
	        clsObj.commentObj.Comment__c = 'Test';
	        clsObj.saveComment();
	        clsObj.editData();        
	        clsObj.attachObj.Body = blob.valueOf('Test Body');
	        clsObj.attachObj.ParentId = legalObj.Id;
	        clsObj.attachObj.Name = 'Test';
	        clsObj.uploadFile();
	        clsObj.submitCase();
	        ApexPages.currentPage().getParameters().put('id',legalObj.id);
	        clsObj.getIsInventionId();
    	}catch(exception e){
    		system.debug('Exception:'+e.getMessage());
    	}
    }
    
    static testMethod void myUnitTest1() {  
    	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standardusertest456@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testingtest@123', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest456@testorg.com'); 
    	insert u;
    	Legal_Requests__c legalObj	= new Legal_Requests__c();
    	legalObj.Name = 'Test';
    	insert legalObj;
    	Legal_Requests_Watchers__c watcherObj = new Legal_Requests_Watchers__c(Advisor_Name__c=u.Id, Legal_Requests__c=legalObj.id);
        insert watcherObj;
        Legal_Requests_Comments__c commentObj = new Legal_Requests_Comments__c(Legal_Requests__c=legalObj.id);
        insert commentObj;        
        legalObj.Status__c ='Submitted';
        update legalObj;
        delete watcherObj;
        delete commentObj;
        legalObj.Status__c ='Draft';
        ApexPages.currentPage().getParameters().put('id',legalObj.id);
        ApexPages.currentPage().getParameters().put('action','edit');
        ApexPages.StandardController sc1 = new ApexPages.standardController(legalObj);
        InventionTicket clsObj = new InventionTicket(sc1);
        InventionTicket.searchUser('test');
        AutoCompleteController.searchUser('test');
        clsObj.watcherObj.Advisor_Name__c = u.id;
        clsObj.saveWatcher();
        LegalRequestPDFController pdfObj = new LegalRequestPDFController(sc1);        
    }
}
@isTest
private class Test_ResourceTimeCalculation {

    static testMethod void myUnitTest() {
        Project__c phProject = new Project__c(Name='PH - Project',Type__c='Misc',Portfolio__c='GCC',High_Level_Requirements__c='Test',Delivery_Qtr__c='2015Q1',Start_Date__c=system.Today());
		Project__c vacationProject = new Project__c(Name='PH - Vacation',Type__c='Misc',Portfolio__c='GCC',High_Level_Requirements__c='Test',Delivery_Qtr__c='2015Q1',Start_Date__c=system.Today());
		List<Project__c> projectList = new List<Project__c>();
		projectList.add(phProject);
		projectList.add(vacationProject);
		insert projectList;
		
		User indiaTeamUser = [Select id,IsActive,Email from user where id = '00580000003d9rB'];
		
		Account acctest = new Account();
		acctest.Name='TestAccount';
		acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
		acctest.Partner_ID__c ='123';
		acctest.RecordTypeId  = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
		acctest.Current_Owner__c = indiaTeamUser.id;
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
		insert acctest;
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = false;
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
				
		Contact contactObj = new Contact();
		contactObj.AccountId =  acctest.id;
		contactObj.Email = 'test.test@test.com';
		contactObj.Phone = '9910106804';
		contactObj.LastName = 'TestLast';
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
		insert contactObj; 
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = false;
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
		
		Resources__c resourceObj = new Resources__c(Project__c=vacationProject.id,Resource_Name_contact__c=contactObj.Id,Jan__c=1.0,Feb__c=1.0,Mar__c=1.0,Apr__c=1.0,May__c=1.0,Jun__c=1.0,Jul__c=1.0,Aug__c=1.0,Sep__c=1.0,Oct__c=1.0,Nov__c=1.0,Dec__c=1.0);
		insert resourceObj;
		
		Resources__c resourceObj1 = new Resources__c(Project__c=vacationProject.id,Resource_Name_contact__c=contactObj.Id,Jan__c=1.0,Feb__c=1.0,Mar__c=1.0,Apr__c=1.0,May__c=1.0,Jun__c=1.0,Jul__c=1.0,Aug__c=1.0,Sep__c=1.0,Oct__c=1.0,Nov__c=1.0,Dec__c=1.0);
		insert resourceObj1;  
		
		resourceObj.jan__c = 2.0;
		update resourceObj;
		
		delete resourceObj;
    }
}
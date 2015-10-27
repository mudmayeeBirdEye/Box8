public class ResourceProjectManagmentController {
	
	public static void fetchResources(){
		Set<String> projectNameSet = new Set<String>{'PH - Vacation','PH - Capacity','PH - Operations','PH - Support/Maintenance','PH - Quickwin'};
		
		List<Resources__c> resourceList = [SELECT Id,Resource_Name_contact__c FROM Resources__c WHERE Project__r.Name IN : projectNameSet AND Resource_Name_contact__c != NULL];
		
		Set<ID> contactIdSet = new Set<ID>();
		for(Resources__c resourceObj : resourceList){
			contactIdSet.add(resourceObj.Resource_Name_contact__c);
		}
		
		List<Contact> contactResourceList = [SELECT id, (SELECT Id,Resource_Name_contact__c,Project__r.Name,Jan__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,
																Sep__c,Oct__c,Nov__c,Dec__c FROM Resources__r WHERE Project__r.Name IN : projectNameSet) 
																FROM Contact WHERE ID IN : contactIdSet];
																
		List<Project__c> phProjectList = [SELECT id FROM Project__c WHERE Name = 'PH - Project'];
		
		List<Resources__c> resourceInsertList = new List<Resources__c>();
		
		for(Contact conObj : contactResourceList){
			if(conObj.Resources__r != NULL && conObj.Resources__r.size() > 0){
				decimal dJan = 0.0;
				decimal dFeb = 0.0;
				decimal dMar = 0.0;
				decimal dApr = 0.0;
				decimal dMay = 0.0;
				decimal dJun = 0.0;
				decimal dJul = 0.0;
				decimal dAug = 0.0;
				decimal dSep = 0.0;
				decimal dOct = 0.0;
				decimal dNov = 0.0;
				decimal dDec = 0.0;
				for(Resources__c innerProject : conObj.Resources__r){
					if(innerProject.Jan__c!=NULL){
						dJan+= innerProject.Jan__c;
					}
					if(innerProject.Feb__c!=NULL){
						dFeb+= innerProject.Feb__c;
					}
					if(innerProject.Mar__c!=NULL){
						dMar+= innerProject.Mar__c;
					}
					if(innerProject.Apr__c!=Null){
						dApr+= innerProject.Apr__c;
					}
					if(innerProject.May__c!=NULL){
						dMay+= innerProject.May__c;
					}
					if(innerProject.Jun__c!=NULL){
						dJun+= innerProject.Jun__c;
					}
					if(innerProject.Jul__c!=NULL){
						dJul+= innerProject.Jul__c;
					}
					if(innerProject.Aug__c!=NULL){
						dAug+= innerProject.Aug__c;
					}
					if(innerProject.Sep__c!=NULL){
						dSep+= innerProject.Sep__c;
					}
					if(innerProject.Oct__c!=NULL){
						dOct+= innerProject.Oct__c;
					}
					if(innerProject.Nov__c!=NULL){
						dNov+= innerProject.Nov__c;     
					}
					if(innerProject.Dec__c!=NULL){
						dDec+= innerProject.Dec__c;
					}
				}
				
				Resources__c phProjectResource = new Resources__c();
				phProjectResource.Jan__c = dJan;
				phProjectResource.Feb__c = dFeb;
				phProjectResource.Mar__c = dMar;
				phProjectResource.Apr__c = dApr;
				phProjectResource.May__c = dMay;
				phProjectResource.Jun__c = dJun;
				phProjectResource.Jul__c = dJul;
				phProjectResource.Aug__c = dAug;
				phProjectResource.Sep__c = dSep;
				phProjectResource.Oct__c = dOct;
				phProjectResource.Nov__c = dNov;
				phProjectResource.Dec__c = dDec;
				phProjectResource.Project__c = phProjectList[0].Id;
				phProjectResource.Resource_Name_contact__c = conObj.Id;
				resourceInsertList.add(phProjectResource);
			}
		}
		if(resourceInsertList!=NULL && resourceInsertList.size() > 0){
			insert resourceInsertList;
		}
	}
}
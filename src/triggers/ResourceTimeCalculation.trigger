trigger ResourceTimeCalculation on Resources__c (before insert,before update,after delete) {
	
	if(TriggerHandler.BY_PASS_RESOURCE_TRIGGER){
		System.debug('### RETURNED FROM ResourceTimeCalculation TRG ###');
        return;
	}	
	
	Set<Id> contactIdSet = new Set<Id>();
	Set<Id> projectIdSet = new Set<Id>();  
	Set<Id> resourceIdSet = new Set<Id>();
	map<Id,Contact> contactResourceMap;
	map<Id,Project__c> projectMap;
	List<Resources__c> resourceList = new List<Resources__c>();
	Set<String> projectNameSet = new Set<String>{'PH - Vacation','PH - Capacity','PH - Operations','PH - Support/Maintenance','PH - Quickwin','PH - Project'};
	
	if(Trigger.isInsert || Trigger.isUpdate){
		for(Resources__c resourceObj : Trigger.New){
			if(string.isNotBlank(resourceObj.Resource_Name_contact__c)){
				contactIdSet.add(resourceObj.Resource_Name_contact__c);
			}
			if(string.isNotBlank(resourceObj.Project__c)){
				projectIdSet.add(resourceObj.Project__c);         
			}
			if(string.isNotBlank(resourceObj.Id)){
				resourceIdSet.add(resourceObj.Id);
			}
		}
		
		if( contactIdSet != NULL && contactIdSet.size() > 0 ){
			contactResourceMap = new map<Id,Contact>([SELECT id, (SELECT Id,Resource_Name_contact__c,Project__r.Name,Jan__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,
																	Sep__c,Oct__c,Nov__c,Dec__c FROM Resources__r WHERE Project__r.Name IN : projectNameSet  AND Id NOT IN : resourceIdSet) 
																	FROM Contact WHERE ID IN : contactIdSet]);		
			system.debug('=contactResourceMap='+contactResourceMap);
			
			if( projectIdSet != NULL && projectIdSet.size() > 0 ){
				projectMap = new map<Id,Project__c>([SELECT Id,Name FROM Project__c WHERE ID IN : projectIdSet]);
				system.debug('=projectMap='+projectMap);
			}
			
			List<Project__c> phProjectList = [SELECT id FROM Project__c WHERE Name = 'PH - Project'];
		
			for(Resources__c resourceObj : Trigger.New){
				boolean phProjectExists = false;
				Resources__c phProjectResource = new Resources__c();
				if(projectMap!=null && projectMap.get(resourceObj.Project__c)!=NULL && 
					(projectMap.get(resourceObj.Project__c).Name == 'PH - Vacation' || 
					projectMap.get(resourceObj.Project__c).Name == 'PH - Capacity' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Operations' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Support/Maintenance' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Quickwin' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Project')){				
								
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
			
					if(projectMap.get(resourceObj.Project__c).Name != 'PH - Project'){
						if(resourceObj.Jan__c!=null){
							dJan+= resourceObj.Jan__c;
						}
						if(resourceObj.Feb__c!=null){
							dFeb+= resourceObj.Feb__c;
						}
						if(resourceObj.Mar__c!=NULL){
							dMar+= resourceObj.Mar__c;
						}
						if(resourceObj.Apr__c!=Null){
							dApr+= resourceObj.Apr__c;
						}
						if(resourceObj.May__c!=NULL){
							dMay+= resourceObj.May__c;
						}
						if(resourceObj.Jun__c!=NULL){
							dJun+= resourceObj.Jun__c;
						}
						if(resourceObj.Jul__c!=NULL){
							dJul+= resourceObj.Jul__c;
						}
						if(resourceObj.Aug__c!=NULL){
							dAug+= resourceObj.Aug__c;
						}
						if(resourceObj.Sep__c!=NULL){
							dSep+= resourceObj.Sep__c;
						}
						if(resourceObj.Oct__c!=NULL){
							dOct+= resourceObj.Oct__c;
						}
						if(resourceObj.Nov__c!=NULL){
							dNov+= resourceObj.Nov__c;     
						}
						if(resourceObj.Dec__c!=NULL){
							dDec+= resourceObj.Dec__c;
						}
					}
			
					if(string.isNotBlank(resourceObj.Resource_Name_contact__c)){
						if(contactResourceMap!=NULL && contactResourceMap.get(resourceObj.Resource_Name_contact__c)!=NULL){
							if(contactResourceMap.get(resourceObj.Resource_Name_contact__c).Resources__r != NULL &&
								contactResourceMap.get(resourceObj.Resource_Name_contact__c).Resources__r.size() > 0){
								for(Resources__c innerProject : contactResourceMap.get(resourceObj.Resource_Name_contact__c).Resources__r){
									if(innerProject.Project__r.Name == 'PH - Project'){
										phProjectResource = innerProject;
										phProjectExists = true;
									} else {
										if(innerProject.Jan__c!=null){
											dJan+= innerProject.Jan__c;
										}
										if(innerProject.Feb__c!=null){
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
								}
							}
						}
					}
					
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
					
					if(phProjectExists == false){
						phProjectResource.Project__c = (phProjectList!=NULL && phProjectList.size() > 0 ? phProjectList[0].Id : '');
						phProjectResource.Resource_Name_contact__c = resourceObj.Resource_Name_contact__c;	
					}
					resourceList.add(phProjectResource);
				}
			}		
			if(resourceList!=null && resourceList.size() > 0){
				system.debug('=resourceList='+resourceList);
				TriggerHandler.BY_PASS_RESOURCE_TRIGGER = true;
				upsert resourceList;
				TriggerHandler.BY_PASS_RESOURCE_TRIGGER = false;
			}
		}
	} else {
		
		Map<Id,Resources__c> updatedResourceMap = new Map<Id,Resources__c>();
		
		for(Resources__c resourceObj : Trigger.Old){
			if(string.isNotBlank(resourceObj.Resource_Name_contact__c)){
				contactIdSet.add(resourceObj.Resource_Name_contact__c);
			}
			if(string.isNotBlank(resourceObj.Project__c)){
				projectIdSet.add(resourceObj.Project__c);         
			}
			if(string.isNotBlank(resourceObj.Id)){
				resourceIdSet.add(resourceObj.Id);
			}
		}
		
		if( contactIdSet != NULL && contactIdSet.size() > 0 ){
			contactResourceMap = new map<Id,Contact>([SELECT id, (SELECT Id,Resource_Name_contact__c,Project__r.Name,Jan__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,
																	Sep__c,Oct__c,Nov__c,Dec__c FROM Resources__r WHERE Project__r.Name = 'PH - Project' AND Id NOT IN : resourceIdSet) 
																	FROM Contact WHERE ID IN : contactIdSet]);
			if( projectIdSet != NULL && projectIdSet.size() > 0 ){
				projectMap = new map<Id,Project__c>([SELECT Id,Name FROM Project__c WHERE ID IN : projectIdSet]);
				system.debug('=projectMap='+projectMap);
			}
			
			for(Resources__c resourceObj : Trigger.Old){
				if(projectMap!=null && projectMap.get(resourceObj.Project__c)!=NULL && 
					(projectMap.get(resourceObj.Project__c).Name == 'PH - Vacation' || 
					projectMap.get(resourceObj.Project__c).Name == 'PH - Capacity' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Operations' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Support/Maintenance' ||
					projectMap.get(resourceObj.Project__c).Name == 'PH - Quickwin')){
					
					if(string.isNotBlank(resourceObj.Resource_Name_contact__c)){
						if(contactResourceMap!=NULL && contactResourceMap.get(resourceObj.Resource_Name_contact__c)!=NULL){
							if(contactResourceMap.get(resourceObj.Resource_Name_contact__c).Resources__r != NULL &&
								contactResourceMap.get(resourceObj.Resource_Name_contact__c).Resources__r.size() > 0){
								Resources__c phResourceObj = contactResourceMap.get(resourceObj.Resource_Name_contact__c).Resources__r[0];
								if(updatedResourceMap != NULL && updatedResourceMap.get(phResourceObj.Id) != NULL){
									phResourceObj = updatedResourceMap.get(phResourceObj.Id);
								}								
								if(resourceObj.Jan__c!=null){
									phResourceObj.Jan__c = phResourceObj.Jan__c - resourceObj.Jan__c;
								}
								if(resourceObj.Feb__c!=null){
									phResourceObj.Feb__c = phResourceObj.Feb__c - resourceObj.Feb__c;
								}
								if(resourceObj.Mar__c!=NULL){
									phResourceObj.Mar__c = phResourceObj.Mar__c - resourceObj.Mar__c;
								}
								if(resourceObj.Apr__c!=Null){
									phResourceObj.Apr__c = phResourceObj.Apr__c - resourceObj.Apr__c;
								}
								if(resourceObj.May__c!=NULL){
									phResourceObj.May__c = phResourceObj.May__c - resourceObj.May__c;
								}
								if(resourceObj.Jun__c!=NULL){
									phResourceObj.Jun__c = phResourceObj.Jun__c - resourceObj.Jun__c;
								}
								if(resourceObj.Jul__c!=NULL){
									phResourceObj.Jul__c = phResourceObj.Jul__c - resourceObj.Jul__c;
								}
								if(resourceObj.Aug__c!=NULL){
									phResourceObj.Aug__c = phResourceObj.Aug__c - resourceObj.Aug__c;
								}
								if(resourceObj.Sep__c!=NULL){
									phResourceObj.Sep__c = phResourceObj.Sep__c - resourceObj.Sep__c;
								}
								if(resourceObj.Oct__c!=NULL){
									phResourceObj.Oct__c = phResourceObj.Oct__c - resourceObj.Oct__c;
								}
								if(resourceObj.Nov__c!=NULL){
									phResourceObj.Nov__c = phResourceObj.Nov__c - resourceObj.Nov__c;     
								}
								if(resourceObj.Dec__c!=NULL){
									phResourceObj.Dec__c = phResourceObj.Dec__c - resourceObj.Dec__c;
								}
								updatedResourceMap.put(phResourceObj.Id,phResourceObj);
							}
						}
					}	
				}	
			}
			if( updatedResourceMap != NULL && updatedResourceMap.size() > 0 ){
				for(Id idVal : updatedResourceMap.keySet()){
					resourceList.add(updatedResourceMap.get(idVal));
				}
				TriggerHandler.BY_PASS_RESOURCE_TRIGGER = true;
				update resourceList;
				TriggerHandler.BY_PASS_RESOURCE_TRIGGER = false;
			}
		}
	}
}
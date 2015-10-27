trigger AccountHierarchyDuplicacy on Account_Hierarchy__c (before insert) {
	if(Trigger.isBefore){
		
		Set<String> lsDUIDSet = new Set<String>();
		Set<String> domainSet = new Set<String>();
		Set<String> companyNameSet = new Set<String>();
		Set<String> countrySet = new Set<String>();
		Set<String> websiteSet = new Set<String>();		
		
		for(Account_Hierarchy__c accHieObj : Trigger.New){
			if(string.isNotBlank(accHieObj.RUID_Primary_DU__c)){
    			lsDUIDSet.add(accHieObj.RUID_Primary_DU__c);
    		}
    		if(string.isNotBlank(accHieObj.Match_Key_Domain__c)){
				domainSet.add(accHieObj.Match_Key_Domain__c);
    		}
    		if(string.isNotBlank(accHieObj.Name)){ 
				companyNameSet.add(accHieObj.Name);
    		}   		
    		if(string.isNotBlank(accHieObj.AH_Website__c)){ 
				websiteSet.add(accHieObj.AH_Website__c);
    		}
		}
		
		List<Account_Hierarchy__c> accountHierarchyDUIDLst = [SELECT id,Name,RUID_Primary_DU__c,Match_Key_Domain__c,Country__c,AH_Website__c FROM Account_Hierarchy__c WHERE RUID_Primary_DU__c IN : lsDUIDSet];
		
		List<Account_Hierarchy__c> accountHierarchyDomainLst = [SELECT id,Name,RUID_Primary_DU__c,Match_Key_Domain__c,Country__c,AH_Website__c FROM Account_Hierarchy__c WHERE Match_Key_Domain__c IN : domainSet];		
		
		List<Account_Hierarchy__c> accountHierarchyNameLst = [SELECT id,Name,RUID_Primary_DU__c,Match_Key_Domain__c,Country__c,AH_Website__c FROM Account_Hierarchy__c WHERE Name IN : companyNameSet];
				
		List<Account_Hierarchy__c> accountHierarchyWebsiteLst = [SELECT id,Name,RUID_Primary_DU__c,Match_Key_Domain__c,Country__c,AH_Website__c FROM Account_Hierarchy__c WHERE AH_Website__c IN : websiteSet];
		
		List<Account_Hierarchy__c> accountHierarchyLst = new List<Account_Hierarchy__c>();
		
		Set<Account_Hierarchy__c> accHeiSet = new Set<Account_Hierarchy__c>();
		List<Account_Hierarchy__c> finalAccountHierarchyLst = new List<Account_Hierarchy__c>();
		
		if(accountHierarchyDUIDLst!=NULL && accountHierarchyDUIDLst.size() > 0 ){
			accountHierarchyLst.addAll(accountHierarchyDUIDLst);
		}
		if(accountHierarchyDomainLst!=NULL && accountHierarchyDomainLst.size() > 0 ){
			accountHierarchyLst.addAll(accountHierarchyDomainLst);
		}
		if(accountHierarchyNameLst!=NULL && accountHierarchyNameLst.size() > 0 ){
			accountHierarchyLst.addAll(accountHierarchyNameLst);
		}
		if(accountHierarchyWebsiteLst!=NULL && accountHierarchyWebsiteLst.size() > 0 ){
			accountHierarchyLst.addAll(accountHierarchyWebsiteLst);
		}
		
		if(accountHierarchyLst!=NULL && accountHierarchyLst.size() > 0){		
			accHeiSet.addAll(accountHierarchyLst);
			finalAccountHierarchyLst.addAll(accHeiSet);
		}
		
		if(finalAccountHierarchyLst != NULL && finalAccountHierarchyLst.size() > 0){
			
			lsDUIDSet = new Set<String>();
			domainSet = new Set<String>();
			companyNameSet = new Set<String>();
			countrySet = new Set<String>();
			websiteSet = new Set<String>();			
	    	map<String,string> companyCountyMap = new map<String,String>();
	    	
    		for(Account_Hierarchy__c accHieObj : finalAccountHierarchyLst){
    			if(string.isNotBlank(accHieObj.RUID_Primary_DU__c)){
		        	lsDUIDSet.add(accHieObj.RUID_Primary_DU__c.toUpperCase());
		        }
		        if(string.isNotBlank(accHieObj.Match_Key_Domain__c)){
		        	domainSet.add(accHieObj.Match_Key_Domain__c.toUpperCase());
		        }
		        if(string.isNotBlank(accHieObj.Name) && string.isNotBlank(accHieObj.Country__c)){ 
		        	companyNameSet.add(accHieObj.Name.toUpperCase());
		        	companyCountyMap.put(accHieObj.Name.toUpperCase(),accHieObj.Country__c.toUpperCase());
		        }
		        if(string.isNotBlank(accHieObj.AH_Website__c)){ 
		        	websiteSet.add(accHieObj.AH_Website__c.toUpperCase());
		        }
    		}
    		
    		for(Account_Hierarchy__c accHieObj : Trigger.New){
		        if(string.isNotBlank(accHieObj.RUID_Primary_DU__c) && lsDUIDSet.contains(accHieObj.RUID_Primary_DU__c.toUpperCase())){
		         	accHieObj.addError('Duplicate Account Hierarchy Record Found. Please search again.');
		        }
		        if(string.isNotBlank(accHieObj.Match_Key_Domain__c) && domainSet.contains(accHieObj.Match_Key_Domain__c.toUpperCase())){
		        	accHieObj.addError('Duplicate Account Hierarchy Record Found. Please search again.');
		        }
		        if(string.isNotBlank(accHieObj.Name) && companyNameSet.contains(accHieObj.Name.toUpperCase())){
		        	if(string.isNotBlank(accHieObj.Country__c) && companyCountyMap.get(accHieObj.Name.toUpperCase()) == accHieObj.Country__c.toUpperCase()){
		            	accHieObj.addError('Duplicate Account Hierarchy Record Found. Please search again.');
		          	}
		        }
		        if(string.isNotBlank(accHieObj.AH_Website__c) && websiteSet.contains(accHieObj.AH_Website__c.toUpperCase())){ 
		        	accHieObj.addError('Duplicate Account Hierarchy Record Found. Please search again.');
		        }
	        }
		}
	}
}
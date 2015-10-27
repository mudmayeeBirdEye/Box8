trigger AccountHierarchyTerritoryAssignmentTgr on Account_Hierarchy__c (before insert) {
	
	Map<string,Map<String,String>> segmentDataMap = PRAssignmentLogic.createSegmentDataMap();      
	Map<String,Map<String,List<Territory_Data__c>>> territoryDataMap = PRAssignmentLogic.createTerritoryDataMap();
	Set<string> employeeSizeSet = new Set<string>();
	List<string> employeeSizeList = new List<String>();   
	employeeSizeList = Label.Territory_Employee_Size.split(';');		
	for(String str : employeeSizeList){
		employeeSizeSet.add(str.trim());
	}
		
	for(Account_Hierarchy__c accHieObj : Trigger.new){
		if(Trigger.isInsert){
			if(string.isNotBlank(accHieObj.Effective_No_of_Employees_Range__c) &&
				string.isNotBlank(accHieObj.country__c) &&
				(string.isNotBlank(accHieObj.ZipCode__c) || string.isNotBlank(accHieObj.AH_Phone__c))){
					Boolean userFound = PRAssignmentLogic.runAHGeoTerritoryRouting(accHieObj,segmentDataMap,territoryDataMap,employeeSizeSet);
			}
		}
	}
}
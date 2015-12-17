global class AccountHierarchyTerritoryAssignmentBatch implements Database.Batchable<sObject>{
	
	public Map<string,Map<String,String>> segmentDataMap;
	public Map<String,Map<String,List<Territory_Data__c>>> territoryDataMap;
	public Set<string> employeeSizeSet;
	public List<Account_Hierarchy__c> accHieListUpdate;
	String query;
	//testing workflow
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		/*segmentDataMap = new Map<string,Map<String,String>>();
		territoryDataMap = new Map<String,Map<String,List<Territory_Data__c>>>();
		employeeSizeSet = new set<string>();
		accHieListUpdate = new List<Account_Hierarchy__c>(); */
		
		/**************Territory Data Maps*************************/
		//segmentDataMap = PRAssignmentLogic.createSegmentDataMap();                            
		//territoryDataMap = PRAssignmentLogic.createTerritoryDataMap();
		/**********************************************************/
		
		/***********Custom Label for Employee Size****************/
		/*List<string> employeeSizeList = new List<String>();   
		employeeSizeList = Label.Territory_Employee_Size.split(';');		
		for(String str : employeeSizeList){
			employeeSizeSet.add(str.trim());
		}*/
		/*******************************************************/
		
		query = 'SELECT Id,AH_Industry__c,AH_Phone__c,Country__c,Effective_No_of_Employees_Range__c,Industry__c,NAIC__c,ZipCode__c,Territory__c'+
				 ' FROM Account_Hierarchy__c WHERE Territory__c=NULL ';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Account_Hierarchy__c> accHieList = (List<Account_Hierarchy__c>)scope;
		
		segmentDataMap = new Map<string,Map<String,String>>();
		territoryDataMap = new Map<String,Map<String,List<Territory_Data__c>>>();
		employeeSizeSet = new set<string>();
		accHieListUpdate = new List<Account_Hierarchy__c>();
		/**************Territory Data Maps*************************/
		segmentDataMap = PRAssignmentLogic.createSegmentDataMap();                            
		territoryDataMap = PRAssignmentLogic.createTerritoryDataMap();
		/**********************************************************/
		
		/***********Custom Label for Employee Size****************/
		List<string> employeeSizeList = new List<String>();   
		employeeSizeList = Label.Territory_Employee_Size.split(';');		
		for(String str : employeeSizeList){
			employeeSizeSet.add(str.trim());
		}
		/*******************************************************/
		for(Account_Hierarchy__c accHieObj : accHieList){
			if(string.isNotBlank(accHieObj.Effective_No_of_Employees_Range__c) &&
				string.isNotBlank(accHieObj.country__c) &&
				(string.isNotBlank(accHieObj.ZipCode__c) || string.isNotBlank(accHieObj.AH_Phone__c))){
					Boolean userFound = PRAssignmentLogic.runAHGeoTerritoryRouting(accHieObj,segmentDataMap,territoryDataMap,employeeSizeSet);
					if(userFound){
						accHieListUpdate.add(accHieObj);
					}
				}
		}
		if(accHieListUpdate != null && accHieListUpdate.size() > 0){
			update accHieListUpdate;
		}
	}
	
	global void finish(Database.BatchableContext BC){
		
	}
}
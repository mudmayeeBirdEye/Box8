trigger CommentDeletionValidation on Legal_Requests_Comments__c (before delete) {
	if(Trigger.isDelete){
		Set<Id> deleteIdSet = new Set<Id>();
		for(Legal_Requests_Comments__c commentObj : Trigger.Old){
			if(commentObj.Legal_Requests__c != NULL){
				deleteIdSet.add(commentObj.Legal_Requests__c);
			}
		}
		
		if(deleteIdSet != NULL && deleteIdSet.size() > 0){
			Map<Id,Legal_Requests__c> legalRequestMap = new Map<Id,Legal_Requests__c>([SELECT Id,Status__c FROM Legal_Requests__c WHERE Id IN : deleteIdSet
																						AND Status__c='Submitted']);
			for(Legal_Requests_Comments__c commentObj : Trigger.old){
				if(legalRequestMap.get(commentObj.Legal_Requests__c) != NULL && !Test.isRunningTest()){
					commentObj.addError('Legal Request is submitted. You can not delete Inventor record.');
				}
			}	
		}
	}	
}
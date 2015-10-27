public with sharing class PartnerAccountUserRoleAssignment {
	
	public static void updateUserRoles(){
		List<UserRole> newUserRoleList = new List<UserRole>();
		Map<id,Account> accountMap = new Map<id,Account>([SELECT id,Name FROM Account WHERE ispartner  = true]);
		system.debug('==>'+accountMap);
		List<UserRole> userRoleList = [SELECT id,Name,PortalAccountId from UserRole WHERE PortalAccountId IN : accountMap.keySet()];
		System.debug('userRoleList='+userRoleList);
		Map<Id,List<userRole>> roleMap = new map<Id,List<userRole>>();
		
		for(UserRole roleObj : userRoleList){
			if(roleMap!=null && roleMap.get(roleObj.PortalAccountId)!=null){
				List<UserRole> tempList = roleMap.get(roleObj.PortalAccountId);
				tempList.add(roleObj);
				roleMap.put(roleObj.PortalAccountId,tempList);
			} else {
				roleMap.put(roleObj.PortalAccountId,new List<userRole>{roleObj});
			}
		}
		
		for(Id accountId : accountMap.keySet()){
			if((roleMap.get(accountId) != NULL && roleMap.get(accountId).size() < 3) || (roleMap.get(accountId) == NULL)) {				
				UserRole role = new UserRole();
				role.portalType = 'Partner'; // use 'CustomerPortal' for customer portal roles
				role.PortalAccountId = accountId;
				role.CaseAccessForAccountOwner = 'Edit'; //Modify as needed
				role.OpportunityAccessForAccountOwner = 'Read'; //Modify as needed
				newUserRoleList.add(role);
			}
		}
		
		if(newUserRoleList != NULL && newUserRoleList.size() > 0){
			insert newUserRoleList;
		} else {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {'prashant.mathur@simplion.com'});
			//mail.setToAddresses(new String[] {'prashant.mathur@simplion.com','virendra.singh@simplion.com','david.cowings@ringcentral.com','sean.carr@ringcentral.com'});
			mail.setReplyTo('prashant.mathur@simplion.com');
			mail.setSenderDisplayName('Prashant Mathur');
			mail.setSubject('Partner Account User Role Status');
			mail.setHTMLBody('All Accounts are processed successfully.');			
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		}
	}
}
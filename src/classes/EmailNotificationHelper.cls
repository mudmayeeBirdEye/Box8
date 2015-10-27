public class EmailNotificationHelper {
    
    public static void sendEmailNotification(Set<Id> legalRequestIdSet, Map<Id,Legal_Requests__c> oldMap){      
        List<Legal_Requests__c> updatedLegalRequestList = [SELECT id,OwnerId,Owner.Email,Owner.Name,Status__c,recordType.Name,
                                                          (SELECT id,Advisor_Name__c,Advisor_Name__r.Name,Advisor_Name__r.Email FROM Legal_Requests_Watchers__r WHERE Advisor_Name__c != NULL),
                                                          (SELECT id FROM Attachments LIMIT 1)
                                                           FROM Legal_Requests__c WHERE ID In : legalRequestIdSet];
        Id updateNotificationTemplateID;
        //Id submitNotificationTemplateID;
        try{                                               
            updateNotificationTemplateID = [SELECT id FROM EmailTemplate where Name = 'Legal Request Update Notification'].Id;
            //submitNotificationTemplateID = [SELECT id FROM EmailTemplate where Name = 'Legal Request Submit Notification'].Id;
        }catch(exception e){
            if(!Test.isRunningTest()){
            	trigger.new[0].addError('Email Templates are missing.');
            }
        }
        
        Boolean fieldUpdated = false;
        Boolean requestSubmited = false;
                                                                    
        List<Messaging.SingleEmailMessage> singleEmailMessageList = new List<Messaging.SingleEmailMessage>(); 
        for(Legal_Requests__c requestObj : updatedLegalRequestList){            
            if(
                (requestObj.Status__c == oldMap.get(requestObj.Id).Status__c)||
                (requestObj.Status__c != oldMap.get(requestObj.Id).Status__c && requestObj.Status__c != 'Submitted')
              ){
                fieldUpdated = true;    
            }
            
            if(requestObj.Status__c != oldMap.get(requestObj.Id).Status__c && requestObj.Status__c == 'Submitted'){
                requestSubmited = true;
            }
            //if(!String.valueOf(requestObj.OwnerId).startsWith('00G')){
                if(fieldUpdated){  
                	if(!String.valueOf(requestObj.OwnerId).startsWith('00G')){               
                    	//SingleEmailMessageList.add(EmailNotificationHelper.createEmailMessage(requestObj.OwnerId,requestObj.Id,updateNotificationTemplateID));
                    	SingleEmailMessageList.add(EmailNotificationHelper.createEmailMessage(requestObj.Owner.Name,requestObj.recordType.Name,requestObj.Id,requestObj.owner.Email));
                	}
                    if(requestObj.Legal_Requests_Watchers__r != null && requestObj.Legal_Requests_Watchers__r.size() > 0){              
                        for(Legal_Requests_Watchers__c watcherObj : requestObj.Legal_Requests_Watchers__r){ 
                        	system.debug('name='+watcherObj.Advisor_Name__c);                
                            //SingleEmailMessageList.add(EmailNotificationHelper.createEmailMessage(watcherObj.Advisor_Name__c,requestObj.Id,updateNotificationTemplateID));
                            SingleEmailMessageList.add(EmailNotificationHelper.createEmailMessage(watcherObj.Advisor_Name__r.Name,requestObj.recordType.Name,requestObj.Id,watcherObj.Advisor_Name__r.Email));
                        }   
                    }   
                } else {
                    //SingleEmailMessageList.add(EmailNotificationHelper.createEmailMessage(requestObj.OwnerId,requestObj.Id,submitNotificationTemplateID));
                     boolean attachmentExsist = false;
                    
                    if(requestObj.Attachments != NULL && requestObj.Attachments.size() > 0){
                    	attachmentExsist = true;
                    }            
                    if(requestObj.Legal_Requests_Watchers__r != null && requestObj.Legal_Requests_Watchers__r.size() > 0){              
                        for(Legal_Requests_Watchers__c watcherObj : requestObj.Legal_Requests_Watchers__r){                 
                            //SingleEmailMessageList.add(EmailNotificationHelper.createEmailMessage(watcherObj.Advisor_Name__c,requestObj.Id,submitNotificationTemplateID));
                            SingleEmailMessageList.add(createSubmitrequestEmailMessage(requestObj.Id, watcherObj.Advisor_Name__r.Name, watcherObj.Advisor_Name__r.Email,requestObj.recordType.Name,attachmentExsist));              
                        }
                    }
                   
                    SingleEmailMessageList.add(EmailNotificationHelper.createSubmitrequestEmailMessage(requestObj.Id,'Team','patents@ringcentral.com',requestObj.recordType.Name,attachmentExsist));
                } 
            //}          
        }
        if(SingleEmailMessageList!=null && SingleEmailMessageList.size() > 0 && !Test.isRunningTest()){
        	Messaging.sendEmail(SingleEmailMessageList);
        }
    }   
    
    public static Messaging.SingleEmailMessage createEmailMessage(Id ownerId,Id whatId,Id templateId){
        Messaging.SingleEmailMessage mailObj = new Messaging.SingleEmailMessage();
        mailObj.setTemplateId(templateId);
        mailObj.setTargetObjectId(ownerId);
        mailObj.setWhatId(whatId);
        mailObj.setSaveAsActivity(false);
        return mailObj;
    }
    
    public static Messaging.SingleEmailMessage createEmailMessage(String name,String recordTypeName,String recordId,String email){
        Messaging.SingleEmailMessage mailObj = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>{email};      
      	mailObj.setToAddresses(sendTo);
      	mailObj.setSubject('Legal Request Update Notification');
      	String body = 'Hi '+name+',<br/><br/>';
		body += 'One Legal Request has been modified. Please have a look.<br/><br/>';
		if(recordTypeName == 'Invention'){
			//body += '<a href="https://box2-box2-ringcentral.cs3.force.com/helpdesk/inventionticket?id="+'\requestObj.Id\'+">Click Here to view Legal Request</a><br/><br/>"';
			body += '<a href="https://rc-portal.force.com/helpdesk/inventionticket?id='+recordId+'">Click Here to view Legal Request</a><br/><br/>';
		}else{
			//body += '<a href="https://box2-box2-ringcentral.cs3.force.com/helpdesk/fossticket?id="'+requestObj.Id+'>Click Here to view Legal Request</a><br/><br/>';
			body += '<a href="https://rc-portal.force.com/helpdesk/fossticket?id='+recordId+'">Click Here to view Legal Request</a><br/><br/>';
		}
		mailObj.setHtmlBody(body);
        return mailObj;
    }
    
    public static Messaging.SingleEmailMessage createSubmitrequestEmailMessage(String recordId, String name, String email, String recordTypeName, Boolean attachmentExsist){        
        Messaging.SingleEmailMessage mailObj = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>{email};      
      	mailObj.setToAddresses(sendTo);
      	mailObj.setSubject('Legal Request Submit Notification');
      	String body = 'Hi '+name+',<br/><br/>';
		body += 'One Legal Request has been Submitted. Please have a look.<br/><br/>';
		if(recordTypeName == 'Invention'){
			//body += '<a href="https://box2-box2-ringcentral.cs3.force.com/helpdesk/inventionticket?id="+'\requestObj.Id\'+">Click Here to view Legal Request</a><br/><br/>"';
			body += '<a href="https://rc-portal.force.com/helpdesk/inventionticket?id='+recordId+'">Click Here to view Legal Request</a><br/><br/>';	
		}else{
			//body += '<a href="https://box2-box2-ringcentral.cs3.force.com/helpdesk/fossticket?id="'+requestObj.Id+'>Click Here to view Legal Request</a><br/><br/>';
			body += '<a href="https://rc-portal.force.com/helpdesk/fossticket?id='+recordId+'">Click Here to view Legal Request</a><br/><br/>';
		}		
		if(attachmentExsist){
			body += 'Note : This Legal Request has Attachments with it.<br/><br/> Thanks';
		}
		mailObj.setHtmlBody(body);
        return mailObj;
    }
}
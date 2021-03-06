/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */@isTest
private class RCSupportControllerHandlerTest {

	public static testmethod void TestRCSupportControllerHandle() {

		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;

		Folder fd = [SELECT Id FROM Folder WHERE Name LIKE '%Public%' LIMIT 1];
		Blob blbObj1 = Blob.valueOf('Site,*-*,Article Text,*-*,Article URL,*-*,#EOL#US/CA,*-*,Partially Received Faxes,*-*,http://success.ringcentral.com/articles/RC_Knowledge_Article/Partially-Received-Faxes?retURL,*-*,#EOL#UK,*-*,Call Handling,*-*,http://success.ringcentral.co.uk/articles/RC_Knowledge_Article/4979?retURL,*-*,#EOL#');
		Document doc1 = new Document(Name = 'ArticleNaviagationListForUSCAandUK', Body = blbObj1, folderId = fd.Id, isPublic = true, type = 'csv');
		insert doc1;
        Test.startTest();
        apexpages.currentPage().getParameters().put('ln',' ');
		RCSupportControllerHandler objHandler = new RCSupportControllerHandler();
		
		apexpages.currentPage().getParameters().put('ln','Test');
		objHandler = new RCSupportControllerHandler();
		Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RCSupport%'
		limit 1];

		User objUserGuest = new User(alias = 'ksTest',
		email = 'kanishk.singhTest@simplion.com',
		emailencodingkey = 'UTF-8',
		lastname = 'Testing',
		languagelocalekey = 'en_US',
		localesidkey = 'en_US',
		profileid = pp.id,
		timezonesidkey = 'America/Los_Angeles',
		username = 'kanishk.singhTest@simplion.com');
		insert objUserGuest;
		system.runAs(objUserGuest) {

			objHandler = new RCSupportControllerHandler();
			objHandler.showTabsDetail();
			objHandler.updateUserProfile();
			objHandler.validateLoginDetail();
			objHandler.login();
			objHandler.PageAuthorization();
			objHandler.openCase();
			objHandler.openMyCase();
			objHandler.getPageDetail();
			objHandler.getIsArticleDetailsPage();
			objHandler.getURLProtocol();
			objHandler.getNextPageName();
			objHandler.getCommunityId();
			objHandler.redirectToPage();
			objHandler.getPageAuthorization();
		}

		Account objAccount = (Account) SmartFactory.createSObject('Account', true);
		upsert objAccount;

		Contact objContact = (Contact) SmartFactory.createSObject('Contact', true);
		objContact.AccountId = objAccount.id;
		objContact.Email = 'kanishkTest@test.com';
		objContact.FirstName = 'Kanishk';
		upsert objContact;

		User objUser = new User(alias = objContact.FirstName,
		email = objContact.Email,
		emailencodingkey = 'UTF-8',
		lastname = objContact.LastName,
		languagelocalekey = 'en_US',
		localesidkey = 'en_US',
		profileid = '00e80000001OK6k', //On production 'Sandbox 5:00e80000001OK6k',Production:00e80000001OK6k
		contactId = objContact.id,
		timezonesidkey = 'America/Los_Angeles',
		username = objContact.Email + system.Now().getTime(),
		CommunityNickname = 'User Community Nick name' + system.Now().getTime());

		insert objUser;


		

		String strRandomPassword = 'RC' + String.valueOf(Math.random()); //'verity11'; //'RC'+String.valueOf(Math.random());
		system.setPassword(objUser.Id, strRandomPassword);
		String strToken = 'un=' + objUser.username + '&pw=' + strRandomPassword;
		Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
		Blob initVector = Blob.valueof('da4atrABufastacr');
		Blob data = Blob.valueOf(strToken);
		Blob encryptedData = Crypto.encrypt('AES256', cryptoKey, initVector, data);
		String strBase64Encoded = EncodingUtil.base64Encode(encryptedData);
		//vauthUserInputParam.Out_Token = EncodingUtil.urlEncode(strBase64Encoded, 'UTF-8') + '#' + strBase64Encoded;
		String strTokenTest = strBase64Encoded;
		String strNextPage = 'RCSupportPortalHomePage';
		ApexPages.currentPage().getParameters().put('token', strTokenTest);
		ApexPages.currentPage().getParameters().put('NEXTPAGE', strNextPage);
		objHandler = new RCSupportControllerHandler();
		objHandler.showTabsDetail();
		objHandler.updateUserProfile();
		objHandler.validateLoginDetail();
		objHandler.login();
		objHandler.PageAuthorization();
		objHandler.openCase();
		objHandler.openMyCase();
		objHandler.getPageDetail();
		objHandler.getIsArticleDetailsPage();
		objHandler.getURLProtocol();
		objHandler.getCommunityId();
		objHandler.redirectToPage();
		ApexPages.currentPage().getParameters().put('startURL', '/RCSupportPortalHome');
		objHandler = new RCSupportControllerHandler();
		objHandler.getNextPageName();
		system.runAs(objUserGuest) {
			ApexPages.currentPage().getParameters().put('token', strTokenTest);
			ApexPages.currentPage().getParameters().put('NEXTPAGE', strNextPage);
			ApexPages.currentPage().getParameters().put('LCtabId', 'getting_a');
			objHandler = new RCSupportControllerHandler();
			objHandler.validateLoginDetail();
		}
		Test.stopTest();
		PageReference objPageRef = new PageReference('http://success.ringcentral.com/knowledge/TOCArticleRendererPkb.apexp?id=kA2V00000008TK9');
		objPageRef.setRedirect(true);
		objHandler = new RCSupportControllerHandler();
		objHandler.getIsArticleDetailsPage();


	}
}


//*****************************************************************************************************************
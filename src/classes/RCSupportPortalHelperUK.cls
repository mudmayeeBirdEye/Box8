public class RCSupportPortalHelperUK{

public String str{get;set;}
public Boolean isGuestUser{get;set;}
public String strSeesionId{get;set;}
public Boolean isTokenFound{get;set;}
public String strPageUrl{get;set;}
//public  String strPostFix='_rccustomer';
public  String strPostFix='';
public User objUser{get;set;}
public String strLCClassName{get;set;}
public String ln{get;set;}
public Map<String, String> titleLastModMap {get;set;}

public RCSupportPortalHelperUK(){
	titleLastModMap = new Map<String, String>();
	getArticleLastModDate();
		
	if(UserInfo.getUserType()=='Guest'){
        isGuestUser=true;
	} else {
        isGuestUser=false;
    }
    
    isTokenFound=isValidTokenFound();
    
    if (apexpages.currentPage().getParameters().get('ln')!=null && apexpages.currentPage().getParameters().get('ln')!= '')
		ln = apexpages.currentPage().getParameters().get('ln');
	else
		ln = '';
}

private void getArticleLastModDate() {
	List<RC_Knowledge_Article__kav> objList = new List<RC_Knowledge_Article__kav>();
	try {
		Set<String> setArticleId=new Set<String>();
    	Boolean isUKPortal=getUKPortal();
        for(RC_Knowledge_Article__DataCategorySelection objdata:[Select r.Parent.ArticleNumber,r.Parent.KnowledgeArticleId, r.ParentId,
                                   r.DataCategoryGroupName,r.DataCategoryName  From RC_Knowledge_Article__DataCategorySelection r where r.Parent.PublishStatus='Online']){
        
			if(isUKPortal && objdata.DataCategoryGroupName=='RCProductVesion' && (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName=='RCUK2013')){
	        	  setArticleId.add(objdata.ParentId);
			} else if(!isUKPortal && objdata.DataCategoryGroupName=='RCProductVesion' && (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName=='RC2013') ){
	              setArticleId.add(objdata.ParentId);
			} 
		}
      	for(RC_Knowledge_Article__kav articleObj : [Select r.UrlName, r.Title,r.KnowledgeArticleId,r.LastPublishedDate,Ranking__c, r.LastModifiedDate From RC_Knowledge_Article__kav r  where PublishStatus='Online'
                                              AND id IN:setArticleId AND IsVisibleInPkb = true ORDER BY Ranking__c,LastPublishedDate DESC]) {
             titleLastModMap.put(articleObj.Title, articleObj.LastPublishedDate.format('MMMM d,  yyyy'));
      	}
      } catch(Exception e) {}
}

public Pagereference validateLoginDetail(){
      try{
       if(isTokenFound==true ){
          /*if(!(getURLProtocol().equalsIgnoreCase('https'))){
              String strUrl=URL.getCurrentRequestUrl().toExternalForm();
              strUrl=strUrl.replaceFirst('http','https');
              strUrl=strUrl+'?'+URL.getCurrentRequestUrl().getQuery();
              Pagereference objPage=new Pagereference(strUrl);
              objPage.setRedirect(true);
              return objPage;
          }*/
        
         String tokenVal=getValidToken();   
          if(tokenVal!=null && tokenVal!=''){
            String loginToken=tokenVal;
            string username;
            string password;
            
            if(loginToken != null) {
                String[] strSplitToken = loginToken.split('&');
                username =  strSplitToken[0].split('=')[1];
                password =  strSplitToken[1].split('=')[1];
                str=username+password;
            }
            String strPage = ApexPages.CurrentPage().getParameters().get('NEXTPAGE');
            System.Debug('>>>111>>>'+strPage);
            if(strPage!=null && strPage!='' && strPage.indexOf(strPostFix)>=0){
                strPage='/'+strPage.removeEndIgnoreCase(strPostFix);
                System.Debug('>>>112>>>'+strPage);
            }else if(ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=null && ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=''){
                 strPage='';
                 strPage='/articles/RC_Knowledge_Article/'+ApexPages.CurrentPage().getParameters().get('ARTICLENAME');
            }
            
            System.Debug('>>>113>>>'+strPage);
            //Pagereference pageRef= Site.login(username,password, ''+getRetPageName());
            Pagereference pageRef= Site.login(username,password, ''+strPage);
            //Pagereference pageRef= Site.login(username,password, '/RCSupportPortalSearch');
            pageRef.setRedirect(true);
            return pageRef;
     }
       } 
      //} 
      }catch(Exception e){} 
    return null;
}


public Pagereference login(){
    if(isTokenFound==true){
        return validateLoginDetail();
    }else{
            //PageReference objPage=new PageReference('http://sp2.ringcentral.com/login/login.php');
            PageReference objPage=new PageReference('https://service.ringcentral.co.uk/login.asp');
            objPage.getParameters().put('p_next_page',getNextPageName());
            objPage.setRedirect(true);
            return objPage;
     }
    return null;
}
public String getNextPageName(){
       String strPage=null;
      
       if(ApexPages.currentPage().getParameters().get('startURL')!=null && ApexPages.currentPage().getParameters().get('startURL')!=''){
        strPage=ApexPages.currentPage().getParameters().get('startURL');
        if(strPage!=null && strPage!='' && strPage.indexOf('/')>=0){
            strPage=strPage.substringAfterLast('/');
            return strPage+strPostFix;
        }
        
    }
    return 'RCSupportPortalHome'+strPostFix;
}

	public Boolean getUKPortal(){
		if(Site.getName() != null && Site.getName()!='' && (Site.getName()).lastIndexOfIgnoreCase('RCSupportPortalUK')>-1){
			return true;
		}
		return false;
	}



public String strUserType{get;set;}

public Pagereference PageAuthorization(){
    if(UserInfo.getUserType()=='Guest'){
        isGuestUser=true;
    }else{
        isGuestUser=false;
        return null;
    }//strPageUrl=ApexPages.currentPage().getUrl();
    //return null;
    return login();
} 

public Pagereference getPageAuthorization(){
    if(UserInfo.getUserType()=='Guest'){
        isGuestUser=true;
    }else{
        isGuestUser=false;
        return null;
    }//strPageUrl=ApexPages.currentPage().getUrl();
    //return null;
    return login();
}

public Boolean isValidTokenFound(){
     String strToken =getValidToken();
     if(strToken!=null && strToken!=''){
        return true;
     }
    return false;
}
public String getValidToken(){
      //try{
      String strToken = ApexPages.CurrentPage().getParameters().get('token');
       if(strToken!=null && strToken!=''){
            String tokenUrlDecoded = EncodingUtil.urlDecode(strToken, 'UTF-8');
            tokenUrlDecoded = tokenUrlDecoded.replaceAll(' ', '+');
            Blob tokenDecodedBases64 = Encodingutil.base64Decode(tokenUrlDecoded);          
            Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
            Blob initVector = Blob.valueof('da4atrABufastacr');
            // Decrypt the data
            Blob decryptedData = Crypto.decrypt('AES256', cryptoKey, initVector, tokenDecodedBases64);
            String tokenVal = decryptedData.toString();    
                // it is fixed for mul
           return tokenVal;
       }
      //}catch(Exception e){}
       return null;  
    
}


}
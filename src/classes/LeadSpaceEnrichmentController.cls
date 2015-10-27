public class LeadSpaceEnrichmentController {
    
    // LeadSpace API Enrichment Variable
    static String apiKey = '046170802f344a0ccd98621d947cb9cfad04a531e1b6fc3f7de6c707bbd7ebb2';
    static String endPointUrl = 'https://api.leadspace.com/v1/enrichments/';
    static String API_Method = 'POST';
    static Integer reqTimeMs = 120000;
    static LeadSpaceWrapperCls responseData {get;set;}
    static List<Account_Hierarchy__c> accountHierarchyList;
    static String strEnrich {get;set;}
    static boolean isEnriched{get;set;}
    
    /**************************************LeadSpace Enrichment Code**************************************************************/
    public static boolean enrichLeadData(Lead newLead, set<String> validEmailDomainSet){
        
        isEnriched = false;
        //LeadSpace API Request
        responseData = leadSpaceApiCall(newLead);
        
        //system.debug('=Name='+responseData.person.first_name+' '+responseData.person.last_name);
        
        if(responseData != NULL){
            
            //Enrich LEAD Basic Data
            newlead.LS_Status__c = responseData.enrichment_status;
            newLead.LS_Verified__c = responseData.person.verification_status;
            newLead.LS_Original_Email_Verification__c = responseData.person.original_email_verification_status;
            newLead.LS_Title__c = responseData.person.title;
            newLead.LS_Lead_Department__c = responseData.person.department;
            newLead.LS_Lead_Level__c = responseData.person.level;
            newLead.LS_Lead_Linkedin_Profile__c = responseData.person.linkedin_profile;
            newLead.LS_Lead_Phone__c = responseData.person.phone;
            newLead.LS_name__c = (responseData.person.first_name!=null ? responseData.person.first_name : '') + ' ' + (responseData.person.last_name!=null ? responseData.person.last_name : '');
            if(responseData.person.analytics.job_functions != NULL && responseData.person.analytics.job_functions.size() > 0){
                for(String str : responseData.person.analytics.job_functions){
                    newLead.LS_Lead_Job_Functions__c+= str +';';
                }
            } 
            newLead.LS_Lead_Score__c = string.valueOF(responseData.person.analytics.scores[0].score.value);
            newLead.LS_Site__c = responseData.company.name;
            newLead.LS_Site_ID__c = responseData.company.ls_id;
            newLead.LS_Site_State__c = responseData.company.address.state;
            newLead.LS_Site_Zipcode__c = responseData.company.address.zipcode;
            newLead.LS_Site_Phone__c = responseData.company.phone;
            newLead.LS_Site_Website__c = responseData.company.website;
            if( responseData.company.analytics.scores != NULL && responseData.company.analytics.scores.size() > 0 ){
                newLead.LS_Company_Score__c = string.valueOf(responseData.company.analytics.scores[0].score.value);
            }               
            if( responseData.total_scores != NULL && responseData.total_scores.size() > 0 ){
                newLead.LS_Total_Score__c = string.valueOf(responseData.total_scores[0].score.value);
            }
            newLead.LS_Enrichment_Date__c = (responseData.request_timestamp!=null ? responseData.request_timestamp.date(): null);
            
            //Enrich LEAD Company Data
            if( responseData.company.family_tree != NULL && responseData.company.family_tree.size() > 0 ){  
                                
                for(LeadSpaceWrapperCls.Family_tree familyTree : responseData.company.family_tree){
                    
                    if(familyTree.type == 'DU'){
                                                    
                        boolean accountHierarchieExsist = checkAccountHierarchyObject(responseData.company.industry,responseData.company.sub_industry,
                                                                                         familyTree,newLead,validEmailDomainSet);
                        
                        //accountHierarchieExsist = false;
                        if(accountHierarchieExsist == false){
                            newLead.LS_Company_Industry__c = responseData.company.industry;
                            newLead.LS_Company_Sub_Industry__c = responseData.company.sub_industry;
                            newLead.LS_Company__c = familyTree.name;
                            newLead.LS_DU_ID__c = familyTree.ls_id;
                            newLead.LS_Company_Country__c = familyTree.address.country;
                            newLead.LS_Company_State__c = familyTree.address.state;
                            newLead.LS_Company_City__c = familyTree.address.city;
                            newLead.LS_Company_Street__c = familyTree.address.street;
                            newLead.LS_Company_Zipcode__c = familyTree.address.zipcode;
                            newLead.LS_Company_Website__c = familyTree.website;
                            newLead.LS_Primary_SIC__c = familyTree.sic;
                            newLead.LS_Primary_NAIC__c = familyTree.naics;
                            newLead.LS_Company_Size_Range__c = familyTree.size.range;
                            newLead.LS_Company_Revenue__c = string.valueOf(familyTree.revenue.exact);
                            
                            newLead.LS_Company_Size__c = familyTree.size.exact;
                            newLead.LS_Company_Revenue_Range__c = familyTree.revenue.range;
                            newLead.AH_Link_Source__c = '';
                        }
                        newLead.LS_Company_Size__c = familyTree.size.exact;
                    } else if(familyTree.type == 'GU' && accountHierarchyList != NULL && accountHierarchyList.size() > 0){
                        accountHierarchyList[0].Company_Name_GU__c = familyTree.name;
                        accountHierarchyList[0].RUID_Reference_GU__c = familyTree.ls_id;
                    }
                }
            }
        }
        
        if(accountHierarchyList != NULL && accountHierarchyList.size() > 0){
            try{
                insert accountHierarchyList;
                newLead.AH_Name__c = accountHierarchyList[0].id;
                isEnriched = true;
            }catch(Exception e){
                isEnriched = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Account Hierarchy Record Found. Please search again.'));
                System.debug('Duplicate AH record found.');
            }
        }
        
        return isEnriched;
    }
    
    //LeadSpace API Request and Response
    public static LeadSpaceWrapperCls leadSpaceApiCall(Lead newLead){
        String authString = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':'));
        String API_BODY = '{"person": {"first_name": "' + newLead.FirstName + '","last_name": "' + newLead.LastName + '",'
                            + '"email": "' + newLead.Email + '"},'
                            + '"company": { "name": "' + newLead.Company + '"},"timeout_ms": ' + reqTimeMs + ',"external_id": "abcd"}';
        system.debug('API_BODY == ' + API_BODY);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setTimeout(reqTimeMs);
        req.setEndpoint(endPointUrl);
        req.setMethod(API_Method);
        req.setBody(API_BODY);
        req.setHeader('Authorization', authString);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json; charset=utf8');
        
        if(!Test.isRunningTest()){
            try {               
                res = http.send(req); 
                if(res.getStatusCode() == 200 && string.isNotBlank(res.getBody())){                 
                    strEnrich = res.getBody();                  
                    newLead.LS_response__c = strEnrich;
                } else {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, res.getBody()));
                    return null;
                }
            } catch(System.CalloutException e) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
                return null; 
            }
        }
        
        if(Test.isRunningTest()){
            strEnrich = dummyResponse();
        }
        
        System.debug('strEnrich == ' + strEnrich);
        system.debug('Response='+responseData);
        return (LeadSpaceWrapperCls) System.JSON.deserialize(strEnrich, LeadSpaceWrapperCls.class);           
    }
    
    //Check Account Hierarchy Object against DU ID of Leadspace Response
    public static boolean checkAccountHierarchyObject(String industry,String subIndustry,LeadSpaceWrapperCls.Family_tree familyTree,Lead newLead,
                                                      Set<String> validEmailDomainSet){
        
        map<decimal,Account_Hierarchy__c> accHierarchyMap = new map<decimal,Account_Hierarchy__c>{1=>null,2=>null,3=>null,4=>null,5=>null};
        /*List<Account_Hierarchy__c> accountHierarchyLst = [SELECT id,Name,Industry__c,Sub_Industry__c,Company_Name_DU__c,Company_Name_GU__c,
                                                                RUID_Primary_DU__c,RUID_Reference_GU__c,Country__c,State__c,Street__c,
                                                                City__c,ZipCode__c,AH_Website__c,SIC__c,NAIC__c,Tech_Stack_Details__c,
                                                                Effective_No_of_Employees_Range__c,AH_Revenue__c,AH_Industry__c,Tech_Stack_Categories__c,
                                                                Match_Key_Domain__c FROM Account_Hierarchy__c];*/
        
        String queryString = 'SELECT id,Name,Industry__c,Sub_Industry__c,Company_Name_DU__c,Company_Name_GU__c, '
                     +' RUID_Primary_DU__c,RUID_Reference_GU__c,Country__c,State__c,Street__c,CompanyCountryCombination__c,'
                     +' City__c,ZipCode__c,AH_Website__c,SIC__c,NAIC__c,Tech_Stack_Details__c,'
                     +' Effective_No_of_Employees_Range__c,AH_Revenue__c,AH_Industry__c,Tech_Stack_Categories__c,'
                     +' Match_Key_Domain__c FROM Account_Hierarchy__c WHERE ';
                     
        String conditionStr = '';
                             
        if(string.isNotBlank(familyTree.ls_id)){
            conditionStr += ' RUID_Primary_DU__c = \''+String.escapeSingleQuotes(familyTree.ls_id)+'\' ';
        }
        
        if(string.isNotBlank(familyTree.website)){
            String websiteDomain = familyTree.website.subString(familyTree.website.indexof('www')+4);
            if(websiteDomain.contains('/')){
                websiteDomain = websiteDomain.subString(0,websiteDomain.indexof('/'));
            }
            if(string.isNotBlank(conditionStr)){
                conditionStr += ' OR Match_Key_Domain__c = \''+String.escapeSingleQuotes(websiteDomain)+'\' ';
            } else {
                conditionStr += ' Match_Key_Domain__c = \''+String.escapeSingleQuotes(websiteDomain)+'\' ';
            }
        }
        
        //if(string.isNotBlank(familyTree.name) && string.isNotBlank(familyTree.address.country)){
        if(string.isNotBlank(familyTree.name)){
            String CompanyCountryStr = familyTree.name + (string.isNotBlank(familyTree.address.country) ? familyTree.address.country : '');
            /*if(string.isNotBlank(conditionStr)){
                conditionStr += ' OR ( Company_Name_DU__c = \''+familyTree.name+'\' ' + ' AND Country__c = \''+countryStr+'\' )';
            } else {
                conditionStr += ' ( Company_Name_DU__c = \''+familyTree.name+'\' ' + ' AND Country__c = \''+countryStr+'\' )';
            }*/
            if(string.isNotBlank(conditionStr)){
                conditionStr += ' OR CompanyCountryCombination__c = \''+String.escapeSingleQuotes(CompanyCountryStr)+'\' ' ;
            } else {
                conditionStr += ' CompanyCountryCombination__c = \''+String.escapeSingleQuotes(CompanyCountryStr)+'\' ' ;
            }
        }
        
        if(string.isNotBlank(newLead.Email)){
            String emailDomain = newLead.Email.substring(newLead.Email.indexOf('@')+1);                 
            if(!validEmailDomainSet.contains(emailDomain.toLowerCase()) && !emailDomain.equalsIgnoreCase('ringcentral.com')){
                if(string.isNotBlank(conditionStr)){
                    conditionStr += ' OR Match_Key_Domain__c = \''+String.escapeSingleQuotes(emailDomain)+'\' ';
                } else {
                    conditionStr += ' Match_Key_Domain__c = \''+String.escapeSingleQuotes(emailDomain)+'\' ';
                }
            }
        }
        
        if(string.isNotBlank(familyTree.website)){
            if(string.isNotBlank(conditionStr)){
                conditionStr += ' OR AH_Website__c = \''+familyTree.website+'\' ';
            } else {
                conditionStr += ' AH_Website__c = \''+familyTree.website+'\' ';
            }
        }
        
        List<Account_Hierarchy__c> accountHierarchyLst = new List<Account_Hierarchy__c>();
        
        if(string.isNotBlank(conditionStr)){
            String finalQueryStr = queryString+conditionStr;
            system.debug('Query='+finalQueryStr);
            system.debug('Result='+database.query(finalQueryStr));
            accountHierarchyLst = database.query(finalQueryStr);
        }
        
        for(Account_Hierarchy__c accHieObj : accountHierarchyLst){
            if(accHieObj.RUID_Primary_DU__c == familyTree.ls_id){
                accHierarchyMap.put(1,accHieObj);
                break;
            }
            if(string.isNotBlank(familyTree.website) && accHierarchyMap.get(2) == NULL){
                String websiteDomain = familyTree.website.subString(familyTree.website.indexof('www')+4);
                if(websiteDomain.contains('/')){
                    websiteDomain = websiteDomain.subString(0,websiteDomain.indexof('/'));
                }
                if(!websiteDomain.equalsIgnoreCase('facebook.com')&&
                    !websiteDomain.equalsIgnoreCase('linkedin.com') && 
                    websiteDomain.equalsIgnoreCase(accHieObj.Match_Key_Domain__c)){
                    accHierarchyMap.put(2,accHieObj);
                }
            }
            /*if(string.isNotBlank(accHieObj.Company_Name_DU__c) && accHieObj.Company_Name_DU__c.equalsIgnoreCase(familyTree.name) && 
                string.isNotBlank(accHieObj.Country__c) && accHieObj.Country__c.equalsIgnoreCase(familyTree.address.country) 
                && accHierarchyMap.get(3) == NULL){
                accHierarchyMap.put(3,accHieObj);
            }*/
            if(string.isNotBlank(accHieObj.Company_Name_DU__c) && string.isNotBlank(familyTree.name) && accHierarchyMap.get(3) == NULL){
                String CompanyCountryStr = familyTree.name + (string.isNotBlank(familyTree.address.country) ? familyTree.address.country : '');
                if(CompanyCountryStr.equalsIgnoreCase(accHieObj.CompanyCountryCombination__c) ){
                    accHierarchyMap.put(3,accHieObj);
                }
            }
            if(string.isNotBlank(newLead.Email) && accHierarchyMap.get(4) == NULL && string.isNotBlank(accHieObj.Match_Key_Domain__c)){
                String emailDomain = newLead.Email.substring(newLead.Email.indexOf('@')+1);
                if(!validEmailDomainSet.contains(emailDomain.toLowerCase()) && !emailDomain.equalsIgnoreCase('ringcentral.com') && emailDomain.equalsIgnoreCase(accHieObj.Match_Key_Domain__c)){
                    accHierarchyMap.put(4,accHieObj);   
                }               
            }
            /*if(string.isNotBlank(newLead.Website) && string.isNotBlank(accHieObj.AH_Website__c) && newLead.Website.equalsIgnoreCase(accHieObj.AH_Website__c) && accHierarchyMap.get(5) == NULL){
                accHierarchyMap.put(5,accHieObj);
            }*/
            if(string.isNotBlank(familyTree.website) && string.isNotBlank(accHieObj.AH_Website__c) && familyTree.website.equalsIgnoreCase(accHieObj.AH_Website__c) && accHierarchyMap.get(5) == NULL){
                accHierarchyMap.put(5,accHieObj);
            }
        }
        
        Account_Hierarchy__c accHierarchyObj; 
        
        //now lets put those ranks in a list
        list<decimal> ranksList = new list<decimal>();
        ranksList.addAll(accHierarchyMap.keySet());
    
        //now sort them
        ranksList.sort();
        
        map<decimal,String> linkSourceMap = new map<decimal,String>{1=>'Vendor',2=>'DU-Website',3=>'DU-Name',4=>'Lead-Domain',5=>'Lead-Website'};
        
        for(decimal keyVal : ranksList){
            if(accHierarchyMap.get(keyVal) != NULL){
                accHierarchyObj = new Account_Hierarchy__c();
                accHierarchyObj = accHierarchyMap.get(keyVal);
                newLead.AH_Link_Source__c = linkSourceMap.get(keyVal);
                break;
            }
        }
        
        if(accHierarchyObj != NULL){
            newLead.LS_Company_Industry__c = accHierarchyObj.Industry__c;
            newLead.LS_Company_Sub_Industry__c = accHierarchyObj.Sub_Industry__c;
            newLead.LS_Company__c = accHierarchyObj.Company_Name_DU__c;
            newLead.LS_DU_ID__c = accHierarchyObj.RUID_Primary_DU__c;
            newLead.LS_Company_Country__c = accHierarchyObj.Country__c;
            newLead.LS_Company_State__c = accHierarchyObj.State__c;
            newLead.LS_Company_City__c = accHierarchyObj.City__c;
            newLead.LS_Company_Street__c = accHierarchyObj.Street__c;
            newLead.LS_Company_Zipcode__c = accHierarchyObj.ZipCode__c;
            newLead.LS_Company_Website__c = accHierarchyObj.AH_Website__c;        
            newLead.LS_Primary_SIC__c = accHierarchyObj.SIC__c;
            newLead.LS_Primary_NAIC__c = accHierarchyObj.NAIC__c;
            newLead.LS_Company_Size_Range__c = accHierarchyObj.Effective_No_of_Employees_Range__c;
            newLead.LS_Company_Revenue__c = accHierarchyObj.AH_Revenue__c;
            newLead.AH_Industry__c = accHierarchyObj.AH_Industry__c;
            newLead.Tech_Stack_Categories__c = accHierarchyObj.Tech_Stack_Categories__c;
            newLead.Tech_Stack_Details__c = accHierarchyObj.Tech_Stack_Details__c;
            newLead.AH_Name__c = accHierarchyObj.id;
            isEnriched = true;
            return true;
        } else {  
            accountHierarchyList = new List<Account_Hierarchy__c>();
            Account_Hierarchy__c accountHierarchyObj = new Account_Hierarchy__c();
            accountHierarchyObj.Industry__c = industry;
            accountHierarchyObj.Sub_Industry__c = subIndustry;
            accountHierarchyObj.Company_Name_DU__c = familyTree.name;
            accountHierarchyObj.RUID_Primary_DU__c = familyTree.ls_id;
            accountHierarchyObj.Name = familyTree.name;
            accountHierarchyObj.Country__c = familyTree.address.country;
            accountHierarchyObj.State__c = familyTree.address.state;
            accountHierarchyObj.City__c = familyTree.address.city;
            accountHierarchyObj.Street__c = familyTree.address.street;
            accountHierarchyObj.ZipCode__c = familyTree.address.zipcode;
            accountHierarchyObj.AH_Website__c = familyTree.website;
            accountHierarchyObj.SIC__c = familyTree.sic;
            accountHierarchyObj.NAIC__c = familyTree.naics;
            accountHierarchyObj.Effective_No_of_Employees_Range__c = familyTree.size.range;
            accountHierarchyObj.AH_Revenue__c = string.valueOf(familyTree.revenue.exact);
            accountHierarchyList.add(accountHierarchyObj);
            return false;
        }
    }
    
    public static string dummyResponse(){
        String jsonStr = '{'+
        '  \"person\": {'+
        '    \"first_name\": \"Prashant\",'+
        '    \"phone\": null,'+
        '    \"title\": \"Associate\",'+
        '    \"level\": \"Staff Level\",'+
        '    \"department\": null,'+
        '    \"original_email_verification_status\": \"Unknown\",'+
        '    \"last_name\": \"Mathur\",'+
        '    \"verification_status\": \"Verified\",'+
        '    \"linkedin_profile\": null,'+
        '    \"analytics\": {'+
        '      \"technologies\": [],'+
        '      \"scores\": ['+
        '        {'+
        '          \"profile_name\": \"RingCentral Enrichment\",'+
        '          \"score\": {'+
        '            \"value\": 0'+
        '          }'+
        '        }'+
        '      ],'+
        '      \"job_functions\": [\"test\"]'+
        '    },'+
        '    \"verification_source\": \"Social\"'+
        '  },'+
        '  \"total_scores\": ['+
        '    {'+
        '      \"profile_name\": \"RingCentral Enrichment\",'+
        '      \"score\": {'+
        '        \"value\": 1'+
        '      }'+
        '    }'+
        '  ],'+
        '  \"enrichment_status\": \"Person & Company Enriched\",'+
        '  \"company\": {'+
        '    \"sub_industry\": \"Software & Internet Other\",'+
        '    \"sic\": \"7379\",'+
        '    \"phone\": \"(408) 935-8686\",'+
        '    \"website\": \"http://www.simplion.com\",'+
        '    \"ls_id\": \"daDMX++kVAz4U2gwpfUEsM3HoVCKS1zH\",'+
        '    \"linkedin_profile\": \"www.linkedin.com/company/simplion-technologies\",'+
        '    \"ranking_lists\": [],'+
        '    \"analytics\": {'+
        '      \"technologies\": ['+
        '        {'+
        '          \"confidence_level\": \"Medium\",'+
        '          \"name\": \"RingCentral\"'+
        '        }'+
        '      ],'+
        '      \"expertise\": [],'+
        '      \"scores\": ['+
        '        {'+
        '          \"profile_name\": \"RingCentral Enrichment\",'+
        '          \"score\": {'+
        '            \"value\": 25.6'+
        '          }'+
        '        }'+
        '      ]'+
        '    },'+
        '    \"size\": {'+
        '      \"range\": \"100 - 250\",'+
        '      \"exact\": 175'+
        '    },'+
        '    \"family_tree\": ['+
        '      {'+
        '        \"sic\": \"7379\",'+
        '        \"phone\": \"(408) 935-8686\",'+
        '        \"naics\": \"541519\",'+
        '        \"website\": \"http://www.simplion.com\",'+
        '        \"address\": {'+
        '          \"zipcode\": \"95035\",'+
        '          \"street\": \"1525 McCarthy Blvd Suite 228\",'+
        '          \"state\": \"CA\",'+
        '          \"city\": \"Milpitas\",'+
        '          \"country\": \"United States\"'+
        '        },'+
        '        \"ls_id\": \"daDMX++kVAz4U2gwpfUEsM3HoVCKS1zH\",'+
        '        \"name\": \"Simplion Technologies\",'+
        '        \"type\": \"DU\",'+
        '        \"revenue\": {'+
        '          \"range\": \"$10-50 Million\",'+
        '          \"exact\": 35000000'+
        '        },'+
        '        \"size\": {'+
        '          \"range\": \"100 - 250\",'+
        '          \"exact\": 175'+
        '        }'+
        '      },'+
        '      {'+
        '        \"sic\": \"7379\",'+
        '        \"phone\": \"(408) 935-8686\",'+
        '        \"naics\": \"541519\",'+
        '        \"website\": \"http://www.simplion.com\",'+
        '        \"address\": {'+
        '          \"zipcode\": \"95035\",'+
        '          \"street\": \"1525 McCarthy Blvd Suite 228\",'+
        '          \"state\": \"CA\",'+
        '          \"city\": \"Milpitas\",'+
        '          \"country\": \"United States\"'+
        '        },'+
        '        \"ls_id\": \"daDMX++kVAz4U2gwpfUEsM3HoVCKS1zH\",'+
        '        \"name\": \"Simplion Technologies\",'+
        '        \"type\": \"GU\",'+
        '        \"revenue\": {'+
        '          \"range\": \"$10-50 Million\",'+
        '          \"exact\": 35000000'+
        '        },'+
        '        \"size\": {'+
        '          \"range\": \"100 - 250\",'+
        '          \"exact\": 175'+
        '        }'+
        '      },'+
        '      {'+
        '        \"sic\": \"7379\",'+
        '        \"phone\": \"(408) 935-8686\",'+
        '        \"naics\": \"541519\",'+
        '        \"website\": \"http://www.simplion.com\",'+
        '        \"address\": {'+
        '          \"zipcode\": \"95035\",'+
        '          \"street\": \"1525 McCarthy Blvd Suite 228\",'+
        '          \"state\": \"CA\",'+
        '          \"city\": \"Milpitas\",'+
        '          \"country\": \"United States\"'+
        '        },'+
        '        \"ls_id\": \"daDMX++kVAz4U2gwpfUEsM3HoVCKS1zH\",'+
        '        \"name\": \"Simplion Technologies\",'+
        '        \"type\": \"HQ\",'+
        '        \"revenue\": {'+
        '          \"range\": \"$10-50 Million\",'+
        '          \"exact\": 35000000'+
        '        },'+
        '        \"size\": {'+
        '          \"range\": \"100 - 250\",'+
        '          \"exact\": 175'+
        '        }'+
        '      }'+
        '    ],'+
        '    \"naics\": \"541519\",'+
        '    \"address\": {'+
        '      \"zipcode\": \"95035\",'+
        '      \"street\": \"1525 McCarthy Blvd Suite 228\",'+
        '      \"state\": \"CA\",'+
        '      \"city\": \"Milpitas\",'+
        '      \"country\": \"United States\"'+
        '    },'+
        '    \"description\": \"Simplion [simply-on] help organizations transform their ideas into compelling business value through high-value, cost-efficient technology consulting and outsourcing solutions. Established in 2004, we evolved on the foundation of customer delight, delivery excellence and service quality. Our client roster today features early stage start-ups to established industry leaders. Our customer engagements are driven by the nimbleness and entrepreneurial zeal of an emerging company serving customers globally.   Over the years, we helped organizations unravel and explore opportunities beyond the obvious requirements, thus reinforcing our belief in customer-centricity and long-term relationships. This has enabled us to raise the bar continuously throughout the engagement. Precisely why, our customers retain us year after year.   Simplion\'s portfolio of services are conceptualized around delivering compelling business value by way of customizable solutions and flexible engagement models across the business ecosystems:   Product Engineering   For software vendors and high-tech companies, Simplion collaborates with engineering teams to build and rollout solutions across the breadth and depth of technology spectrum. Our services help organizations achieve faster time to market, greater control on budgets and efficient change management.\",'+
        '    \"name\": \"Simplion Technologies\",'+
        '    \"industry\": \"Software & Internet\",'+
        '    \"stock_tickers\": [],'+
        '    \"revenue\": {'+
        '      \"range\": \"$10-50 Million\",'+
        '      \"exact\": 35000000'+
        '    }'+
        '  }'+
        '}';
        return jsonStr;
    }
}
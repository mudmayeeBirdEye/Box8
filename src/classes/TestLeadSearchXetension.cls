@isTest
private class TestLeadSearchXetension{

static testMethod void testLeadSearchExtension1() {
        try {
            System.Test.startTest();
            ApexPages.currentPage().getParameters().put('dnis','8775843307');   
            Lead leadObj = new Lead();
            ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
            LeadSearchExtension ui = new LeadSearchExtension(sc);
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra';
            leadObj.LastName='Singh';
            leadObj.Company='Simplion';
            leadObj.Email='vps@sss.ss221.com';
            leadObj.Phone='9910106804';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj);
            ui.search();
            //ui.errorMsg = 'CompanyInfo';
            leadObj.Notes__c = 'Test Note';         
            ui.createNew(); 
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhsimplion.com';
            leadObj.Phone='9910106804';
            ui.setNewLead(leadObj); 
            ui.search();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhsimplion.com';
            leadObj.Phone='9910106804';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj); 
            ui.createNew();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910';
            ui.setNewLead(leadObj); 
            ui.search();
            
            //leadObj = new Lead();
            //leadObj.Email='virendra.singh1@simplion.com'; 
            //ui.setNewLead(leadObj); 
            //ui.search();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj);
            ui.createNew();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910323232';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj); 
            ui.createNew();
            
            Account acc = new Account();
             acc.name = 'lokesh';
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910323232';
            leadObj.LeadSource = 'Inbound Call';
            leadObj.Agent_Email_Address__c  = 'test@test.com';
            leadObj.Employees_Override__c = '10-49';
            leadObj.Notes__c = 'testNote';
            
            Lead_Qualification__c leadObj1 = new Lead_Qualification__c();
            leadObj1.CompanyInfo__c = 'CompanyInfo';
            leadObj1.Pain__c = 'pain';
            leadObj1.Pain_Impact__c = 'pain impact';
            leadObj1.Gain__c = 'gain';
            leadObj1.Gain_Impact__c = 'gain impact';
            leadObj1.Ideal_Solution__c = 'idea solution';
            leadObj1.Benefits__c = 'benefit';
            leadObj1.Next_Steps_questions__c = 'next step question';
            leadObj1.Need__c = 'need';
            leadObj1.Other_Explanation__c = 'other explanation';
            leadObj1.of_employees_in_org__c = 'no of employee';
            leadObj1.Other_Notes__c = 'other notes';
            leadObj1.Decision_on_Large_Projects__c = 'decision on large'; 
            leadObj1.More_Info_on_Budgeted__c = 'more info';
            leadObj1.ContractAdditionalInfo__c = 'contract info';
            leadObj1.CurrentSystemAdditionalInfo__c = 'Current SAInfo';
            leadObj1.TimeframeAdditionalInfo__c = 'time FAInfo';
            leadObj1.Decision_makers_Additional_Information__c = 'decision MAInfo';
            ui.setNewLead(leadObj);            
            ui.search(); 
            ui.createNew();
            leadObj.Email = 'virendra@singhs@implion.com';
            ui.createNew();
            leadObj.Email = 'virendrasinghs1@implion.com';
            ui.searchedem = 'sdfsdf';
            ui.createNew();          
              
            ui.selectclick();
            ui.unselectclick();
            ui.getunSelectedValues();
            ui.getSelectedValues();
            ui.dependentReasons();
            ui.leadQualificationObj = leadObj1;
            //ui.leadQualificationObj = new Lead_Qualification__c(CompanyInfo__c='testcompany');
            ui.checkInputFieldLength();
            ui.claimLeadOwnership();
            ui.redirectPartnerUser();
            ui.getShowCreateLeadButton();
            ui.getShowUnprotectedLeadsList(); 
            ui.checkInputFieldLength();
            ui.getDependencyList.trim();
            ApexPages.currentPage().getParameters().put('modelValue','ModelValue');
            LeadSearchExtension.Model_Usage_featureDependencyClass ModUsFe = new LeadSearchExtension.Model_Usage_featureDependencyClass();
            ModUsFe.isUsageLevel = false;
            List<String> lstStrg = ModUsFe.childList;
            ModUsFe.ParentName = 'ParentName';
            
            List<SelectOption> listoption = ui.getBusinessAgilityResons;
            List<SelectOption> listoption1 = ui.getBusinessresponsivenessResons;
            List<SelectOption> listoption2 = ui.getBusinessVendorResons;
            Map<Integer,String> map1 = ui.getCallFlowModelValues2;
            List<SelectOption> listoption3 = ui.getAllCurrentSystemInfoValues;
            List<SelectOption> listoption5 = ui.getFeaturesRequestdByCustomerValues;
            List<SelectOption> listoption6 = ui.getUsagesLevelValues;
            ui.SaveDriverResons(leadObj1);
            ui.saveCurrentSystemInfovalues(leadObj1);
            ui.saveCallFlowModelValues(leadObj1);
            ui.saveFeaturesRequestdByCustomerValues(leadObj1);
            ui.saveUsagesLevelvalues(leadObj1);
            ui.getDecisionMaker();
            ui.showMoreInfoBudget();
            ui.getShowClaimOnwernship();
            //insert leadObj;
            ApexPages.currentPage().getParameters().put('claimedLeadId',leadObj.Id);           
            ui.claimLeadOwnership(); 
            
            ui.searchedem = 'virendrasinghs1@implion.com';
            ui.dnis = '8775843307';
            leadObj.Agent_Email_Address__c = ''; 
            ui.createNew(); 
            
            ui.dnis = '';
             String conditionalStr =''; //' (Opportunity.Account.Name= \''+String.escapeSingleQuotes(newLead.Company.trim())+'\' OR Name=\''+String.escapeSingleQuotes() ' 
                               // + ' AND ((Opportunity.RecordType.Name = \'Sales Opportunity\' OR Opportunity.RecordType.Name = \'Sales Opportunity zQuote\') ' 
                               // + ' OR RecordTypeId = NULL) ';
            leadObj.Agent_Email_Address__c = 'test@test.com'; 
            ui.leadQualificationObj = new Lead_Qualification__c(CompanyInfo__c='testcompany');
            ui.createNew();
            ui.leadQualificationObj = new Lead_Qualification__c(Pain__c='testpain');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Pain_Impact__c='testpainImpact');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Gain__c='testGain');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Gain_Impact__c='testGainImpact');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Ideal_Solution__c='testIdealSolution');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Benefits__c='testBenefits');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Next_Steps_questions__c='testNextStepsquestions');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Other_Explanation__c='testOtherExplanation');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Need__c='testNeed');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(of_employees_in_org__c='testofemployeesinorg');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(How_many_phones_to_start__c='testHowmanyphonestostart');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Other_Notes__c='testOther_Notes');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Decision_on_Large_Projects__c='testDecision_on_Large_Projects');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(More_Info_on_Budgeted__c='testMore_Info_on_Budgeted');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(ContractAdditionalInfo__c='testContractAdditionalInfo');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(CurrentSystemAdditionalInfo__c='testCurrentSystemAdditionalInfo');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(TimeframeAdditionalInfo__c='testTimeframeAdditionalInfo');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Decision_makers_Additional_Information__c='testDecision_makers_Additional_Information');
            ui.checkInputFieldLength();
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Prospect_Need__c='testProspect_Need');
            ui.checkInputFieldLength();
            ui.getsaleGeneratedSource();
            ui.findContactList('conditionalStr' );
            //ui.findOpportunitiesPerAccounts('conditionalStr',acc.id );
         //  ui.findContactPerOppRoles();
            ui.oppPerContactRoles();
           // ui.getCurrentUser();
           // ui.oppPerContacts();
           // ui.findOppPerAccountId();
          //  ui.prepareLeadList();
            ui.cancel();
            
            System.Test.stopTest();               
        } catch(Exception ex) { }  
    }
    }
@isTest
private class TestVerifyQuoteApproval  {    
    static testMethod void myUnitTest() {

        Test.startTest();

        //Test_Utils utilObj = new Test_Utils();
        //utilObj.initialiseTriggerBypass();
        //TriggerHandler.BY_PASS_Approver_Trigger = true;

        //Create an Account
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        acctest.Partner_ID__c ='123';           
        acctest.Current_Owner__c = Userinfo.getUserId();
        acctest.RC_User_ID__c = 'test123';   
        insert acctest; 
        
        //Create a Contact
        Contact conObj = new Contact();
        conObj.LastName = 'contactLast1';
        conObj.AccountId = acctest.Id;  
        conObj.email='test11@rc.com';
        conObj.Phone='1234567890';
        insert conObj;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        //Create an Opportunity
        Opportunity Oppval = new Opportunity();
        Oppval.Name = 'Test Opp';
        Oppval.AccountId = acctest.Id;
        Oppval.Type = 'Existing Business';
        Oppval.StageName = '3. ActivePipe';
        Oppval.Sales_Model__c = 'Direct';
        Oppval.CloseDate = System.Today() + 10;
        Oppval.CurrencyIsoCode = 'USD';
        Oppval.Brand_Name__c= 'RingCentral';            
        Oppval.Agent_Email_Address__c='test@test.com';
        Oppval.RC_User_ID__c = Userinfo.getUserId();
        oppval.OwnerId = Userinfo.getUserId();
        oppval.RecordTypeId = opportunityRecordTypeInfo.get('Sales Opportunity').getRecordTypeId();
        oppval.Probability = 50;
        oppval.X12_Month_Booking__c = 100;
        insert Oppval;          
        
        List<RC_Product__c> rcProductList = new List<RC_Product__c>();
        List<RC_Product_Line_Item__c> rcProductLineItemList = new List<RC_Product_Line_Item__c>();
                        
        //Create a Products
        RC_Product__c objProduct1 = new RC_Product__c(); //------------------------------------------ SALES REP
        objProduct1.Name ='Service1';
        objProduct1.Category__c = 'Service';
        objProduct1.Charge_Term__c = 'Monthly';
        objProduct1.Service_Type__c = 'Office';
        objProduct1.SKU__c  = 'SKU1';     
        objProduct1.Group__c = 'OFFICE_BAU_MONTHLY';
        rcProductList.add(objProduct1);
        
        RC_Product__c objProduct2 = new RC_Product__c(); //------------------------------------------ SALES MANAGER
        objProduct2.Name ='Service2';
        objProduct2.Category__c = 'Service';
        objProduct2.Charge_Term__c = 'Monthly';
        objProduct2.Service_Type__c = 'Office';
        objProduct2.Product_Type__c = 'DL';
        objProduct2.SKU__c  = 'SKU2'; 
        objProduct2.Group__c = 'RC_OFFICE_STARNDARD_CNTRC_AN';
        rcProductList.add(objProduct2);
        
        RC_Product__c objProduct3 = new RC_Product__c(); //------------------------------------------ SALES OFFICE LEADER
        objProduct3.Name ='Service3';
        objProduct3.Category__c = 'Service';
        objProduct3.Charge_Term__c = 'Monthly';
        objProduct3.Service_Type__c = 'Office';
        objProduct3.SKU__c  = 'SKU3'; 
        objProduct3.Group__c = 'RC_OFFICE_SPE_MONTHLY';     
        rcProductList.add(objProduct3);
        
        RC_Product__c objProduct4 = new RC_Product__c(); //------------------------------------------ SALESVP
        objProduct4.Name ='Service4';
        objProduct4.Category__c = 'AddOn';
        objProduct4.Charge_Term__c = 'Monthly';
        objProduct4.Service_Type__c = 'Office';
        objProduct4.Product_Type__c = 'DL';
        objProduct4.SKU__c  = 'SKU4';
        objProduct4.Group__c = 'RC_OFFICE_PREMIUM_CNTRC_AN';
        rcProductList.add(objProduct4);

        RC_Product__c objProduct5 = new RC_Product__c(); //------------------------------------------ FINANCE
        objProduct5.Name ='Service5';
        objProduct5.Category__c = 'AddOn';
        objProduct5.Charge_Term__c = 'Monthly';
        objProduct5.Service_Type__c = 'Office';
        objProduct5.Product_Type__c = 'DL';
        objProduct5.SKU__c  = 'SKU5';
        objProduct5.Group__c = 'OFFICE_ADVANCED_CNTRC_AN';
        rcProductList.add(objProduct5);

        RC_Product__c objProduct6 = new RC_Product__c(); //------------------------------------------ DEVICE CONTRACT
        objProduct6.Name ='Service6';
        objProduct6.Category__c = 'AddOn';
        objProduct6.Charge_Term__c = 'Monthly';
        objProduct6.Service_Type__c = 'Office';
        objProduct6.Product_Type__c = 'DL';
        objProduct6.SKU__c  = 'SKU6';
        objProduct6.Group__c = 'DEVICE_CNTRC';
        rcProductList.add(objProduct6);
        
        insert rcProductList;
        

        RC_Product_Line_Item__c objProductLinItm1 = new RC_Product_Line_Item__c(); //------------------------------------------ SALES REP
        objProductLinItm1.Name = 'test1';
        objProductLinItm1.RC_Product__c= objProduct1.id;
        objProductLinItm1.Lower_Limit__c = 0;
        objProductLinItm1.Upper_Limit__c = 9999999;
        objProductLinItm1.Price__c = 10;
        objProductLinItm1.RC_Currency__c = 'USD';
        objProductLinItm1.isActive__c = true;
        objProductLinItm1.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm1.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm1);
        
        RC_Product_Line_Item__c objProductLinItm2 = new RC_Product_Line_Item__c(); //------------------------------------------ SALES MANAGER
        objProductLinItm2.Name = 'test2';
        objProductLinItm2.RC_Product__c= objProduct2.id;
        objProductLinItm2.Lower_Limit__c = 0;
        objProductLinItm2.Upper_Limit__c = 9999999;
        objProductLinItm2.Price__c = 10;
        objProductLinItm2.RC_Currency__c = 'USD';
        objProductLinItm2.isActive__c = true;
        objProductLinItm2.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm2.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm2);
        
        RC_Product_Line_Item__c objProductLinItm3 = new RC_Product_Line_Item__c(); //------------------------------------------ OFFICE LEADER
        objProductLinItm3.Name = 'test3';
        objProductLinItm3.RC_Product__c= objProduct3.id;
        objProductLinItm3.Lower_Limit__c = 0;
        objProductLinItm3.Upper_Limit__c = 9999999;
        objProductLinItm3.Price__c = 10;
        objProductLinItm3.RC_Currency__c = 'USD';
        objProductLinItm3.isActive__c = true;
        objProductLinItm3.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm3.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm3);
        
        RC_Product_Line_Item__c objProductLinItm4 = new RC_Product_Line_Item__c(); //------------------------------------------ SALES VP
        objProductLinItm4.Name = 'test4';
        objProductLinItm4.RC_Product__c= objProduct4.id;
        objProductLinItm4.Lower_Limit__c = 0;
        objProductLinItm4.Upper_Limit__c = 9999999;
        objProductLinItm4.Price__c = 10;
        objProductLinItm4.RC_Currency__c = 'USD';
        objProductLinItm4.isActive__c = true;
        objProductLinItm4.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm4.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm4);

        RC_Product_Line_Item__c objProductLinItm5 = new RC_Product_Line_Item__c(); //------------------------------------------ FINANACE
        objProductLinItm5.Name = 'test4';
        objProductLinItm5.RC_Product__c= objProduct5.id;
        objProductLinItm5.Lower_Limit__c = 0;
        objProductLinItm5.Upper_Limit__c = 9999999;
        objProductLinItm5.Price__c = 10;
        objProductLinItm5.RC_Currency__c = 'USD';
        objProductLinItm5.isActive__c = true;
        objProductLinItm5.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm5.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm5);

        RC_Product_Line_Item__c objProductLinItm6 = new RC_Product_Line_Item__c(); //------------------------------------------ DEVICE CONTRACT
        objProductLinItm6.Name = 'test4';
        objProductLinItm6.RC_Product__c= objProduct6.id;
        objProductLinItm6.Lower_Limit__c = 0;
        objProductLinItm6.Upper_Limit__c = 9999999;
        objProductLinItm6.Price__c = 10;
        objProductLinItm6.RC_Currency__c = 'USD';
        objProductLinItm6.isActive__c = true;
        objProductLinItm6.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm6.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm6);

        insert rcProductLineItemList;     

        
        // ------------------------------------------------------------------   CREATE CUSTOM SETTINGS   ------------------------------------------------------------------
        list<Grant_Of_Authority__c> lGoa = new list<Grant_Of_Authority__c>();

        Grant_Of_Authority__c Goa1 = new Grant_Of_Authority__c();
        Goa1.Name = 'GOA1';
        Goa1.Range__c = '1-99';
        Goa1.SalesRep__c = '1-1';
        Goa1.SalesManager__c = '0-0';
        Goa1.OfficeLeader__c = '0-0';
        Goa1.SalesVP__c = 'ALL';
        Goa1.Finance__c = 'ALL';
        Goa1.Group__c = 'OFFICE_BAU_MONTHLY';
        lGoa.add(Goa1);

        Grant_Of_Authority__c Goa2 = new Grant_Of_Authority__c();
        Goa2.Name = 'GOA2';
        Goa2.Range__c = '1-99';
        Goa2.SalesRep__c = '0-0';
        Goa2.SalesManager__c = '1-1';
        Goa2.OfficeLeader__c = '0-0';
        Goa2.SalesVP__c = 'ALL';
        Goa2.Finance__c = 'ALL';
        Goa2.Group__c = 'RC_OFFICE_STARNDARD_CNTRC_AN';
        lGoa.add(Goa2);

        Grant_Of_Authority__c Goa3 = new Grant_Of_Authority__c();
        Goa3.Name = 'GOA3';
        Goa3.Range__c = '1-99';
        Goa3.SalesRep__c = '0-0';
        Goa3.SalesManager__c = '0-0';
        Goa3.OfficeLeader__c = '1-1';
        Goa3.SalesVP__c = 'ALL';
        Goa3.Finance__c = 'ALL';
        Goa3.Group__c = 'RC_OFFICE_SPE_MONTHLY';
        lGoa.add(Goa3);

        
        Grant_Of_Authority__c Goa4 = new Grant_Of_Authority__c();
        Goa4.Name = 'Goa4';
        Goa4.Range__c = '1-99';
        Goa4.SalesRep__c = '0-0';
        Goa4.SalesManager__c = '0-0';
        Goa4.OfficeLeader__c = '0-0';
        Goa4.SalesVP__c = '1-1';
        Goa4.Finance__c = '0-0';
        Goa4.Group__c = 'RC_OFFICE_PREMIUM_CNTRC_AN';
        lGoa.add(Goa4);

        Grant_Of_Authority__c Goa5 = new Grant_Of_Authority__c();
        Goa5.Name = 'Goa5';
        Goa5.Range__c = '1-99';
        Goa5.SalesRep__c = '0-0';
        Goa5.SalesManager__c = '0-0';
        Goa5.OfficeLeader__c = '0-0';
        Goa5.SalesVP__c = '0-0';
        Goa5.Finance__c = '1-1';
        Goa5.Group__c = 'OFFICE_ADVANCED_CNTRC_AN';
        lGoa.add(Goa5);

        Grant_Of_Authority__c Goa6 = new Grant_Of_Authority__c();
        Goa6.Name = 'Goa6';
        Goa6.Range__c = '1-99';
        Goa6.SalesRep__c = '0-0';
        Goa6.SalesManager__c = '0-0';
        Goa6.OfficeLeader__c = '0-0';
        Goa6.SalesVP__c = 'ALL';
        Goa6.Finance__c = 'ALL';
        Goa6.Group__c = 'DEVICE_NO_CONTRACT';
        lGoa.add(Goa6);

        insert lGoa;


        // ------------------------------------------------------------------   CREATE QUOTE   ------------------------------------------------------------------   

        list<RC_Quote__c> lQuoteObj = new list<RC_Quote__c>();
        RC_Quote__c qoute1 = new RC_Quote__c();
        qoute1.Name = 'RC Quote For RC 1';
        qoute1.Agreement_Status__c = 'Draft';
        qoute1.Approved_Status__c = '';
        qoute1.Auto_Renewal__c = True;
        qoute1.Contact__c = conObj.Id;
        qoute1.Opportunity__c = Oppval.Id;
        qoute1.Quote_Type__c = 'Quote';

        date myDate = date.newInstance(2015, 9, 16);
        date newDate = myDate.addMonths(24);

        qoute1.Start_Date__c = myDate;
        qoute1.End_Date__c = newDate;
        lQuoteObj.add(qoute1);

        insert lQuoteObj;

        // ------------------------------------------------------------------   CREATE NEW LINE ITEMS    ------------------------------------------------------------------


        List<Line_Item__c> llineItems = new List<Line_Item__c>();
        Line_Item__c li1 = new Line_Item__c(); //- SalesRep
        Line_Item__c li2 = new Line_Item__c(); //- SalesManager
        Line_Item__c li3 = new Line_Item__c(); //- OfficeLeader
        Line_Item__c li4 = new Line_Item__c(); //- SalesVp
        Line_Item__c li5 = new Line_Item__c(); //- SalesVP with Disc
        Line_Item__c li6 = new Line_Item__c();

        Double total12MonthsPrice = 0;
        Double totalInitialPrice = 0;
        Double totalMRRPrice = 0; 
        Double totalInitialDiscount = 0;
        Double total12MDiscount = 0; 


        //------------------------------------------------------------------------------------------------------------------------------------- LI 1 - SALES REP
        li1.Total_Price__c = 1;
        li1.Quantity__c = 1;
        li1.Discount__c = 1;
        li1.Effective_Discount__c = 1;        
        li1.RC_Quote__c = qoute1.Id;
        li1.Opportunity__c = Oppval.Id;
        li1.RC_Product_Line_Item__c =  objProductLinItm1.Id;

            // Calculating 12M price
            if(li1.Charge_Term__c == 'Monthly - Contract' || li1.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li1.Total_Price__c * 12;
                total12MDiscount = (li1.Quantity__c)*(li1.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li1.Total_Price__c;
                total12MDiscount = (li1.Quantity__c)*(li1.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice =li1.Total_Price__c;
            totalInitialDiscount = (li1.Quantity__c)*(li1.Effective_Discount__c);
            // Calculating MRR price

            if(li1.Category__c == 'Service'){
                if(li1.Charge_Term__c == 'Monthly - Contract' || li1.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li1.Total_Price__c;
                }else{
                    totalMRRPrice = li1.Total_Price__c/12;
                }   
            }

        li1.Total_12_Month_Price__c = total12MonthsPrice;
        li1.Total_Initial_Price__c = totalInitialPrice;
        li1.MRR__c = totalMRRPrice;
        li1.Total_12M_Discount__c = total12MDiscount;
        li1.Total_Initial_Discount__c = totalInitialDiscount;
                    
        llineItems.add(li1);

        //------------------------------------------------------------------------------------------------------------------------------------- LI 2 - SALES MANAGER
        li2.Total_Price__c = 101;
        li2.Quantity__c = 1;
        li2.Discount__c = 1;
        li2.Effective_Discount__c = 1;        
        li2.RC_Quote__c = qoute1.Id;
        li2.Opportunity__c = Oppval.Id;
        li2.RC_Product_Line_Item__c =  objProductLinItm2.Id;

            // Calculating 12M price
            if(li2.Charge_Term__c == 'Monthly - Contract' || li2.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li2.Total_Price__c * 12;
                total12MDiscount = (li2.Quantity__c)*(li2.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li2.Total_Price__c;
                total12MDiscount = (li2.Quantity__c)*(li2.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice = li2.Total_Price__c;
            totalInitialDiscount = (li2.Quantity__c)*(li2.Effective_Discount__c);
            // Calculating MRR price

            if(li2.Category__c == 'Service'){
                if(li2.Charge_Term__c == 'Monthly - Contract' || li2.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li2.Total_Price__c;
                }else{
                    totalMRRPrice = li2.Total_Price__c/12;
                }   
            }

        li2.Total_12_Month_Price__c = total12MonthsPrice;
        li2.Total_Initial_Price__c = totalInitialPrice;
        li2.MRR__c = totalMRRPrice;
        li2.Total_12M_Discount__c = total12MDiscount;
        li2.Total_Initial_Discount__c = totalInitialDiscount;

        llineItems.add(li2);
        //------------------------------------------------------------------------------------------------------------------------------------- LI 3 - OFFICE LEADER
        li3.Total_Price__c = 27;
        li3.Quantity__c = 1;
        li3.Discount__c = 1;
        li3.Effective_Discount__c = 1;        
        li3.RC_Quote__c = qoute1.Id;
        li3.Opportunity__c = Oppval.Id;
        li3.RC_Product_Line_Item__c =  objProductLinItm3.Id;

            // Calculating 12M price
            if(li3.Charge_Term__c == 'Monthly - Contract' || li3.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li3.Total_Price__c * 12;
                total12MDiscount = (li3.Quantity__c)*(li3.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li3.Total_Price__c;
                total12MDiscount = (li3.Quantity__c)*(li3.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice = li3.Total_Price__c;
            totalInitialDiscount = (li3.Quantity__c)*(li3.Effective_Discount__c);
            // Calculating MRR price

            if(li3.Category__c == 'Service'){
                if(li3.Charge_Term__c == 'Monthly - Contract' || li3.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li3.Total_Price__c;
                }else{
                    totalMRRPrice = li3.Total_Price__c/12;
                }   
            }

        li3.Total_12_Month_Price__c = total12MonthsPrice;
        li3.Total_Initial_Price__c = totalInitialPrice;
        li3.MRR__c = totalMRRPrice;
        li3.Total_12M_Discount__c = total12MDiscount;
        li3.Total_Initial_Discount__c = totalInitialDiscount;

        llineItems.add(li3);
        //------------------------------------------------------------------------------------------------------------------------------------- LI 4 - SALES VP
        li4.Total_Price__c = 27;
        li4.Quantity__c = 1;
        li4.Discount__c = 1;
        li4.Effective_Discount__c = 1;
        li4.RC_Quote__c = qoute1.Id;
        li4.Opportunity__c = Oppval.Id;
        li4.RC_Product_Line_Item__c =  objProductLinItm4.Id;

            // Calculating 12M price
            if(li4.Charge_Term__c == 'Monthly - Contract' || li4.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li4.Total_Price__c * 12;
                total12MDiscount = (li4.Quantity__c)*(li4.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li4.Total_Price__c;
                total12MDiscount = (li4.Quantity__c)*(li4.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice = li4.Total_Price__c;
            totalInitialDiscount = (li4.Quantity__c)*(li4.Effective_Discount__c);
            // Calculating MRR price

            if(li4.Category__c == 'Service'){
                if(li4.Charge_Term__c == 'Monthly - Contract' || li4.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li4.Total_Price__c;
                }else{
                    totalMRRPrice = li4.Total_Price__c/12;
                }   
            }

        li4.Total_12_Month_Price__c = total12MonthsPrice;
        li4.Total_Initial_Price__c = totalInitialPrice;
        li4.MRR__c = totalMRRPrice;
        li4.Total_12M_Discount__c = total12MDiscount;
        li4.Total_Initial_Discount__c = totalInitialDiscount;

        llineItems.add(li4);
        //------------------------------------------------------------------------------------------------------------------------------------- LI 5 - FINANCE
        li5.Total_Price__c = 27;
        li5.Quantity__c = 1;
        li5.Discount__c = 2;
        li5.Effective_Discount__c = 1;
        li5.RC_Quote__c = qoute1.Id;
        li5.Opportunity__c = Oppval.Id;
        li5.RC_Product_Line_Item__c =  objProductLinItm5.Id;

            // Calculating 12M price
            if(li5.Charge_Term__c == 'Monthly - Contract' || li5.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li5.Total_Price__c * 12;
                total12MDiscount = (li5.Quantity__c)*(li5.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li5.Total_Price__c;
                total12MDiscount = (li5.Quantity__c)*(li5.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice = li5.Total_Price__c;
            totalInitialDiscount = (li5.Quantity__c)*(li5.Effective_Discount__c);
            // Calculating MRR price

            if(li5.Category__c == 'Service'){
                if(li5.Charge_Term__c == 'Monthly - Contract' || li5.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li5.Total_Price__c;
                }else{
                    totalMRRPrice = li5.Total_Price__c/12;
                }   
            }

        li5.Total_12_Month_Price__c = total12MonthsPrice;
        li5.Total_Initial_Price__c = totalInitialPrice;
        li5.MRR__c = totalMRRPrice;
        li5.Total_12M_Discount__c = total12MDiscount;
        li5.Total_Initial_Discount__c = totalInitialDiscount;

        llineItems.add(li5);

        //------------------------------------------------------------------------------------------------------------------------------------- LI 6 - DEVICE CONTRACT
        li6.Total_Price__c = 27;
        li6.Quantity__c = 1;
        li6.Discount__c = 1;
        li6.Effective_Discount__c = 1;
        li6.RC_Quote__c = qoute1.Id;
        li6.Opportunity__c = Oppval.Id;
        li6.RC_Product_Line_Item__c =  objProductLinItm6.Id;

            // Calculating 12M price
            if(li6.Charge_Term__c == 'Monthly - Contract' || li6.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li6.Total_Price__c * 12;
                total12MDiscount = (li6.Quantity__c)*(li6.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li6.Total_Price__c;
                total12MDiscount = (li6.Quantity__c)*(li6.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice = li6.Total_Price__c;
            totalInitialDiscount = (li6.Quantity__c)*(li6.Effective_Discount__c);
            // Calculating MRR price

            if(li6.Category__c == 'Service'){
                if(li6.Charge_Term__c == 'Monthly - Contract' || li6.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li6.Total_Price__c;
                }else{
                    totalMRRPrice = li6.Total_Price__c/12;
                }   
            }

        li6.Total_12_Month_Price__c = total12MonthsPrice;
        li6.Total_Initial_Price__c = totalInitialPrice;
        li6.MRR__c = totalMRRPrice;
        li6.Total_12M_Discount__c = total12MDiscount;
        li6.Total_Initial_Discount__c = totalInitialDiscount;

        llineItems.add(li6);

        insert llineItems;

        Test.stopTest();        

    }

static testMethod void myUnitTest_No_Group() {

        Test.startTest();

        //Test_Utils utilObj = new Test_Utils();
        //utilObj.initialiseTriggerBypass();
        //TriggerHandler.BY_PASS_Approver_Trigger = true;

        //Create an Account
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        acctest.Partner_ID__c ='123';           
        acctest.Current_Owner__c = Userinfo.getUserId();
        acctest.RC_User_ID__c = 'test123';   
        insert acctest; 
        
        //Create a Contact
        Contact conObj = new Contact();
        conObj.LastName = 'contactLast1';
        conObj.AccountId = acctest.Id;  
        conObj.email='test11@rc.com';
        conObj.Phone='1234567890';
        insert conObj;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        //Create an Opportunity
        Opportunity Oppval = new Opportunity();
        Oppval.Name = 'Test Opp';
        Oppval.AccountId = acctest.Id;
        Oppval.Type = 'Existing Business';
        Oppval.StageName = '3. ActivePipe';
        Oppval.Sales_Model__c = 'Direct';
        Oppval.CloseDate = System.Today() + 10;
        Oppval.CurrencyIsoCode = 'USD';
        Oppval.Brand_Name__c= 'RingCentral';            
        Oppval.Agent_Email_Address__c='test@test.com';
        Oppval.RC_User_ID__c = Userinfo.getUserId();
        oppval.OwnerId = Userinfo.getUserId();
        oppval.RecordTypeId = opportunityRecordTypeInfo.get('Sales Opportunity').getRecordTypeId();
        oppval.Probability = 50;
        oppval.X12_Month_Booking__c = 100;
        insert Oppval;          
        
        List<RC_Product__c> rcProductList = new List<RC_Product__c>();
        List<RC_Product_Line_Item__c> rcProductLineItemList = new List<RC_Product_Line_Item__c>();
                        
        //Create a Products
        RC_Product__c objProduct0 = new RC_Product__c(); //------------------------------------------ NO GROUP
        objProduct0.Name ='Service0';
        objProduct0.Category__c = 'Service';
        objProduct0.Charge_Term__c = 'Monthly';
        objProduct0.Service_Type__c = 'Office';
        objProduct0.SKU__c  = 'SKU0';     
        objProduct0.Group__c = '';
        rcProductList.add(objProduct0);
        
        insert rcProductList;
        

        RC_Product_Line_Item__c objProductLinItm0 = new RC_Product_Line_Item__c(); //------------------------------------------ NO GROUP
        objProductLinItm0.Name = 'test1';
        objProductLinItm0.RC_Product__c= objProduct0.id;
        objProductLinItm0.Lower_Limit__c = 0;
        objProductLinItm0.Upper_Limit__c = 9999999;
        objProductLinItm0.Price__c = 10;
        objProductLinItm0.RC_Currency__c = 'USD';
        objProductLinItm0.isActive__c = true;
        objProductLinItm0.Allowed_Record_Type__c = 'Sales Opportunity';
        objProductLinItm0.Max_Discount__c = 1;          
        rcProductLineItemList.add(objProductLinItm0);
        
        insert rcProductLineItemList;     

        
        // ------------------------------------------------------------------   CREATE CUSTOM SETTINGS   ------------------------------------------------------------------
        list<Grant_Of_Authority__c> lGoa = new list<Grant_Of_Authority__c>();

        Grant_Of_Authority__c Goa1 = new Grant_Of_Authority__c();
        Goa1.Name = 'GOA1';
        Goa1.Range__c = '1-99';
        Goa1.SalesRep__c = '1-1';
        Goa1.SalesManager__c = '0-0';
        Goa1.OfficeLeader__c = '0-0';
        Goa1.SalesVP__c = 'ALL';
        Goa1.Finance__c = 'ALL';
        Goa1.Group__c = 'OFFICE_BAU_MONTHLY';
        lGoa.add(Goa1);      

        insert lGoa;


        // ------------------------------------------------------------------   CREATE QUOTE   ------------------------------------------------------------------   

        list<RC_Quote__c> lQuoteObj = new list<RC_Quote__c>();
        RC_Quote__c qoute1 = new RC_Quote__c();
        qoute1.Name = 'RC Quote For RC 1';
        qoute1.Agreement_Status__c = 'Draft';
        qoute1.Approved_Status__c = '';
        qoute1.Auto_Renewal__c = True;
        qoute1.Contact__c = conObj.Id;
        qoute1.Opportunity__c = Oppval.Id;
        qoute1.Quote_Type__c = 'Quote';

        date myDate = date.newInstance(2015, 9, 16);
        date newDate = myDate.addMonths(24);

        qoute1.Start_Date__c = myDate;
        qoute1.End_Date__c = newDate;
        lQuoteObj.add(qoute1);

        insert lQuoteObj;

        // ------------------------------------------------------------------   CREATE NEW LINE ITEMS    ------------------------------------------------------------------


        List<Line_Item__c> llineItems = new List<Line_Item__c>();
        Line_Item__c li0 = new Line_Item__c(); //- NoGroup

        Double total12MonthsPrice = 0;
        Double totalInitialPrice = 0;
        Double totalMRRPrice = 0; 
        Double totalInitialDiscount = 0;
        Double total12MDiscount = 0; 

        //------------------------------------------------------------------------------------------------------------------------------------- LI 0 - NO GROUP
        li0.Total_Price__c = 100;
        li0.Quantity__c = 1;
        li0.Discount__c = 1;
        li0.Effective_Discount__c = 1;
        li0.RC_Quote__c = qoute1.Id;
        li0.Opportunity__c = Oppval.Id;
        li0.RC_Product_Line_Item__c =  objProductLinItm0.Id;

            // Calculating 12M price
            if(li0.Charge_Term__c == 'Monthly - Contract' || li0.Charge_Term__c == 'Monthly'){
                total12MonthsPrice = li0.Total_Price__c * 12;
                total12MDiscount = (li0.Quantity__c)*(li0.Effective_Discount__c) * 12;
            }else{
                total12MonthsPrice = li0.Total_Price__c;
                total12MDiscount = (li0.Quantity__c)*(li0.Effective_Discount__c);
            }
            // Calculating Initial price
            totalInitialPrice = li0.Total_Price__c;
            totalInitialDiscount = (li0.Quantity__c)*(li0.Effective_Discount__c);
            // Calculating MRR price

            if(li0.Category__c == 'Service'){
                if(li0.Charge_Term__c == 'Monthly - Contract' || li0.Charge_Term__c == 'Monthly'){
                    totalMRRPrice = li0.Total_Price__c;
                }else{
                    totalMRRPrice = li0.Total_Price__c/12;
                }   
            }

        li0.Total_12_Month_Price__c = total12MonthsPrice;
        li0.Total_Initial_Price__c = totalInitialPrice;
        li0.MRR__c = totalMRRPrice;
        li0.Total_12M_Discount__c = total12MDiscount;
        li0.Total_Initial_Discount__c = totalInitialDiscount;

        llineItems.add(li0);

        

        insert llineItems;

        Test.stopTest();        

    }

}









/********************************************************************************************************************
* Project Name................: GOA                                                                                 *
* File........................: VerifyQuoteApproval.class                                                           *
* Version.....................: 1.0                                                                                 *
* Created by..................: eugenebasianomutya@gmail.com                                                        *
* Created Date................: 9/15/2015                                                                           *                                       
* Description.................: For case # 03931608 - This class retrieves Approvers for the quote.                 *
*                               It identifies whethere the quote being created will go through approval process.    *
*                               Once identified, it also provide who will be the approvers.                         *
*                                                                                                                   *   
********************************************************************************************************************/
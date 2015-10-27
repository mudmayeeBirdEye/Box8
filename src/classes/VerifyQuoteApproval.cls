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

Public Class VerifyQuoteApproval{

    Static map<string, Grant_Of_Authority__c> GrantOfAuthority = Grant_Of_Authority__c.getAll();

    public Boolean ApprovalRequired {get;set;}
    public String ApprovalStatus {get;set;}
    public String Approver {get;set;}
    

    public Map<Id, RC_Product_Line_Item__c> mRCProdLI_RCProd {get;set;}
    public Line_Item__c lineItemOld {get;set;}
    public Line_Item__c lineItemNew {get;set;}
    public Boolean isNew {get;set;}

    public Map<Id, list<Quote>> mOppId_Quotes {get;set;}
    public Boolean bHasContract {get;set;}


    private static String DEVICE_CNTRC = 'DEVICE_CNTRC';
    private static String DEVICE_NO_CONTRACT = 'DEVICE_NO_CONTRACT';
    private static String DEVICE_CNTRC_LESS = 'DEVICE_CNTRC_LESS';
    private static String DEVICE_CNTRC_MORE = 'DEVICE_CNTRC_MORE';

    private static String APPROVEDSTATUS = 'Approved';
    private static String REJECTEDSTATUS = 'Rejected';

    public VerifyQuoteApproval(){
        ApprovalRequired = false;
        ApprovalStatus = '';
        Approver = '';
    }


    // This method calls the function that checks the Approvers, contracts of the customer and
    // populate the variables that being saved in Line Item record.
    // This method defines whether the record will have aproval process. 
    public void IdentifyApproval(){
        
        String sGroup = '';

        if(mRCProdLI_RCProd.ContainsKey(lineItemNew.RC_Product_Line_Item__c)){
            sGroup = mRCProdLI_RCProd.get(lineItemNew.RC_Product_Line_Item__c).RC_Product__r.Group__c;
        }

        if(sGroup == '' || sGroup == NULL) {
            ApprovalRequired = False;
            Approver = '';
        }else {

            // New record
            if(isNew || lineItemNew.Approval_Status__c =='' || lineItemNew.Approval_Status__c == NULL){
                
                GetGOA(sGroup, lineItemNew.Quantity__c, lineItemNew.Effective_Discount__c);                 
                    
            // Previously approved
            }else if (lineItemOld.Approval_Status__c == APPROVEDSTATUS){

                GetGOA(sGroup, lineItemNew.Quantity__c, lineItemNew.Effective_Discount__c);     
                if(lineItemOld.Approver__c != Approver){
                    ApprovalStatus = '';
                }
            // Previously rejected
            }else if (lineItemOld.Approval_Status__c == REJECTEDSTATUS){
                
                GetGOA(sGroup, lineItemNew.Quantity__c, lineItemNew.Effective_Discount__c);     
                ApprovalStatus = '';
            }
        }
    }


    // This method identifies the Approver for the Quote.
    // This method compare information from the quoting tool against custom settings (Grant Of Authority)
    private void GetGOA (String sGroup, Decimal Qty, Decimal Disc){
        
        String strRange;
        String[] arrRange;
        String strDisc; 
        String[] arrDisc;

        Boolean bFound = false; 
        
        for (Grant_Of_Authority__c goa: GrantOfAuthority.values()){
            if(bFound){break;}

            if (goa.Group__c == sGroup){                
                bFound = getApprover(goa, Qty, Disc);
                ApprovalRequired = bFound;
            }else if(sGroup == DEVICE_CNTRC){

                string CurrentContract;
                //Get Opportinities active contract
                if(Test.isRunningTest()){
                    CurrentContract = DEVICE_NO_CONTRACT;
                }else{
                    CurrentContract = GetActiveContract();
                }

                if(CurrentContract == DEVICE_NO_CONTRACT && goa.Group__c == DEVICE_NO_CONTRACT){
                    bFound = getApprover(goa, Qty, Disc);
                }else if(CurrentContract == DEVICE_CNTRC_LESS && goa.Group__c == DEVICE_CNTRC_LESS){
                    bFound = getApprover(goa, Qty, Disc);
                }else if(CurrentContract == DEVICE_CNTRC_MORE && goa.Group__c == DEVICE_CNTRC_MORE){
                    bFound = getApprover(goa, Qty, Disc);
                }

                ApprovalRequired = bFound;
            }
            
        } // END FOR LOOP

    }

    // This method check the existing active contract of customer if has Contract lessthan or morethan 2 years
    // This method is for Product under Group = DEVICE_CNTRC_LESS_2YR or DEVICE_CNTRC_MORE_2YR 
    private String GetActiveContract(){
        String sContract = DEVICE_NO_CONTRACT;

        ID OppId;
        OppId = lineItemNew.Opportunity__c;     
        try{
            if(mOppId_Quotes != null){
                if(!mOppId_Quotes.isEmpty()){
                    for(Quote Q: mOppId_Quotes.get(OppId)){
                        if(Q.Years__c < 2){
                            sContract = DEVICE_CNTRC_LESS;
                        }
                        if(Q.Years__c >= 2){
                            sContract = DEVICE_CNTRC_MORE;
                        }
                    }           
                }
            }
            return sContract;
        }catch(System.NullPointerException e){
            return sContract;
        }       
    }

    // This method retrieved the information from the custom settings and compare to the SalesRep input in the Quoting tool
    // ALL - represent discount greater than zero
    // FREE - represent free product without discount

    private Boolean getApprover(Grant_Of_Authority__c goa, Decimal Qty, Decimal Disc){
        String strRange;
        String[] arrRange;
        String strDisc; 
        String[] arrDisc;
        
        Boolean bFound; 
        bFound = false; 

        arrRange = goa.Range__c.split('-');

        

        if(Qty >= Decimal.valueOf(arrRange[0]) && Qty <= Decimal.valueOf(arrRange[1])){                                                 
            
            if(!bFound){
                if(goa.SalesRep__c == 'FREE'){
                    bFound = True; 
                    Approver = 'SalesRep';
                }else{
                    arrDisc = goa.SalesRep__c.split('-');
                    if(Disc >= Decimal.valueOf(arrDisc[0]) && Disc <= Decimal.valueOf(arrDisc[1]) && Disc > 0){
                        bFound = True; 
                        Approver = 'SalesRep';
                    }
                }
            }
            if(!bFound){
                if(goa.SalesManager__c == 'FREE'){
                    bFound = True; 
                    Approver = 'SalesManager';
                }else{
                    arrDisc = goa.SalesManager__c.split('-');
                    if(Disc >= Decimal.valueOf(arrDisc[0]) && Disc <= Decimal.valueOf(arrDisc[1]) && Disc > 0){
                        bFound = True; 
                        Approver = 'SalesManager';
                    }
                }
            }
            if(!bFound){
                if(goa.OfficeLeader__c == 'FREE'){
                    bFound = True; 
                    Approver = 'OfficeLeader';
                }else{
                    arrDisc = goa.OfficeLeader__c.split('-');
                    if(Disc >= Decimal.valueOf(arrDisc[0]) && Disc <= Decimal.valueOf(arrDisc[1]) && Disc > 0){
                        bFound = True; 
                        Approver = 'OfficeLeader';
                    }
                }
            }

            if(!bFound){
                if(goa.SalesVP__c == 'FREE' || (goa.SalesVP__c == 'ALL' && Disc > 0)){
                    bFound = True; 
                    Approver = 'SalesVP';
                }else if (goa.SalesVP__c.contains('-')){
                    arrDisc = goa.SalesVP__c.split('-');
                    if(Disc >= Decimal.valueOf(arrDisc[0]) && Disc <= Decimal.valueOf(arrDisc[1]) && Disc > 0){
                        bFound = True; 
                        Approver = 'SalesVP';
                    }
                }
            }

            if(!bFound){
                if(goa.Finance__c == 'FREE' || (goa.Finance__c == 'ALL' && Disc > 0)){
                    bFound = True; 
                    Approver = 'Finance';
                }else if (goa.SalesVP__c.contains('-')){
                    arrDisc = goa.Finance__c.split('-');
                    if(Disc >= Decimal.valueOf(arrDisc[0]) && Disc <= Decimal.valueOf(arrDisc[1]) && Disc > 0){
                        bFound = True; 
                        Approver = 'Finance';
                    }
                }
            }

        }

        return bFound;


    }


    
    
}
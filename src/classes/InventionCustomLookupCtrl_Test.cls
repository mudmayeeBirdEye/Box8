@isTest
private class InventionCustomLookupCtrl_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        searchTest('rajeev');
        searchTest('');
    }
    
    public static void searchTest(String str){
    	ApexPages.currentPage().getParameters().put('strSearch',str);
        InventionCustomLookupCtrl ctrlObj = new InventionCustomLookupCtrl();
        ctrlObj.searchUser();
        ctrlObj.getisUserFound();
    }
}
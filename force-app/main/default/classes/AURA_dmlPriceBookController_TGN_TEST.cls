/* Generated by TestGen on Wed Aug 17 2022 at 1:26 PM (GMT) */
@isTest
private class AURA_dmlPriceBookController_TGN_TEST implements HttpCalloutMock{
    @TestSetup
    private static void setupTestData() {
        Pricebook2 standartPricebook = new Pricebook2(
                Id=Test.getStandardPricebookId(),
                IsActive=true);
        update  standartPricebook;
        Pricebook2 pricebookins = new Pricebook2(
                Name='a',
                IsActive=true,
                End_date__c=Date.today(),
                Start_Date__c=Date.today()
        );
        insert pricebookins;
        Product2 prod1 = new Product2(Name='a');
        insert prod1;
        PricebookEntry entry = new PricebookEntry(
                UnitPrice=500,
                Product2Id=prod1.Id,
                Pricebook2Id=standartPricebook.Id,
                IsActive=true
        );
        insert entry;
    }
    @isTest
    private static void getAllPricebook_TGN_TEST(){
        Test.startTest();
        AURA_dmlPriceBookController.getAllPricebook('a');
        AURA_dmlPriceBookController.getAllPricebook('');
        Test.stopTest();
    }
    @isTest
    private static void getSpecificPricebook_TGN_TEST(){
        Test.startTest();
        Strategy__c item = new Strategy__c();
        insert item;
        AURA_dmlPriceBookController.getSpecificPricebook([SELECT Id FROM Pricebook2 WHERE Name= 'a'].Id);
//        AURA_dmlPriceBookController.getSpecificPricebook('');
        Test.stopTest();
    }
    @isTest
    private static void getAllStandardProduct_TGN_TEST(){
        Pricebook2 standartPricebook = new Pricebook2(
                Id=Test.getStandardPricebookId(),
                IsActive=true);
        update  standartPricebook;
        Product2 drProduct2;
        drProduct2=new Product2();
        drProduct2.Name = 'test';

        insert drProduct2;
        PricebookEntry standardPrice = new PricebookEntry(
                UnitPrice=500,
                Product2Id=drProduct2.Id,
                Pricebook2Id=standartPricebook.Id,
                IsActive=true
        );
        insert standardPrice;
        Database.SaveResult dsr;
        Pricebook2 drPricebook2;


        drPricebook2=new Pricebook2();
        drPricebook2.Name= 'test';

        insert drPricebook2 ;
        Strategy__c item = new Strategy__c();
        item.Strategy_price__c = 123;
        item.Strategy_Name__c = '123';
        item.Product2id__c = drProduct2.Id;
        insert item;
        PricebookEntry drPricebookEntry = new PricebookEntry();
        drPricebookEntry.UnitPrice=123;
        drPricebookEntry.UseStandardPrice = false;
        drPricebookEntry.Pricebook2Id = drPricebook2.Id;
        drPricebookEntry.Product2Id =drProduct2.Id;

        insert drPricebookEntry;

        Test.startTest();
        AURA_dmlPriceBookController.getAllStandardProduct('te');
        Test.stopTest();
    }
    @isTest
    private static void createNewPricebook_TGN_TEST(){
        Test.startTest();
        Map<String,Object> mapobj = new Map<String, Object>();
        mapobj.put('pricebookName','value');
        mapobj.put('Name','value');
        mapobj.put('Id','value');
        mapobj.put('isActive',true);
        Object a='2';
        List<Object>  objList = new List<Object>{ a };
        mapobj.put('listOfProducts',objList);
        mapobj.put('productList',objList);
        mapobj.put('pricebookDescription','value');
        mapobj.put('endDate',String.valueOf( Date.today()));
        mapobj.put('startDate',String.valueOf( Date.today()));
        AURA_dmlPriceBookController.createNewPricebook(mapobj);
        Test.stopTest();
    }
    @isTest
    private static void updatePricebook_TGN_TEST(){
        Map<String,Object> mapobj = new Map<String, Object>();
        mapobj.put('pricebookName','value');
        mapobj.put('Name','value');
        mapobj.put('Id',[
                SELECT
                        CreatedById,
                        CreatedDate,
                        Description,
                        End_date__c,
                        Id,
                        IsActive,
                        IsArchived,
                        IsDeleted,
                        IsStandard,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        Start_Date__c,
                        SystemModstamp
                FROM Pricebook2 WHERE Name='a'].Id);
        mapobj.put('isActive',true);
        Object a='{"a":"aasd"}';
        List<Object>  objList = new List<Object>{ a };
        mapobj.put('listOfProducts',objList);
        mapobj.put('productList',objList);
        mapobj.put('toInsert',false);
        mapobj.put('pricebookDescription','value');
        mapobj.put('endDate',String.valueOf( Date.today()));
        mapobj.put('startDate',String.valueOf( Date.today()));
        Test.startTest();
        AURA_dmlPriceBookController.updatePricebook(mapobj);
//        AURA_dmlPriceBookController.updatePricebook(null);
        Test.stopTest();
    }
    @isTest
    private static void deletePricebookEntryItems_TGN_TEST(){
        Object a = '6';
        Test.startTest();
        AURA_dmlPriceBookController.deletePricebookEntryItems(new List<Object>{a});
        Test.stopTest();
    }
    @isTest
    private static void deletePricebook_TGN_TEST(){
        Database.SaveResult dsr;
        Pricebook2 drPricebook2;
        drPricebook2=new Pricebook2();
        drPricebook2.Name = 'test';
        insert drPricebook2;
        Test.startTest();
        AURA_dmlPriceBookController.deletePricebook(drPricebook2.Id);
        Test.stopTest();
    }
    @isTest
    private static void AURA_dmlPriceBookController_TGN_TEST(){
        AURA_dmlPriceBookController obj = new AURA_dmlPriceBookController();
    }
    @isTest
    private static void PricebookWrapper_TGN_TEST(){
        AURA_dmlPriceBookController.PricebookWrapper obj = new AURA_dmlPriceBookController.PricebookWrapper(new Pricebook2());
    }
    @isTest
    private static void ProductWrapper_TGN_TEST(){
        AURA_dmlPriceBookController.ProductWrapper obj = new AURA_dmlPriceBookController.ProductWrapper(new Product2(),new PricebookEntry(),new Strategy__c());
    }
    @isTest
    private static void SinglePricebookWrapper_TGN_TEST(){
        AURA_dmlPriceBookController.SinglePricebookWrapper obj = new AURA_dmlPriceBookController.SinglePricebookWrapper(new Pricebook2(),new List<PricebookEntry>{new PricebookEntry()});
    }
    @isTest
    private static void NewPricebookWrapper_TGN_TEST(){
        AURA_dmlPriceBookController.NewPricebookWrapper obj = new AURA_dmlPriceBookController.NewPricebookWrapper(new Map<String,Object>{'a'=>new Map<Type,Object>()});
        obj = new AURA_dmlPriceBookController.NewPricebookWrapper(new Map<String,Object>{'a'=>new Map<Type,Object>()},true);
    }

    public HttpResponse respond(HttpRequest param1) {
        return null;
    }
}
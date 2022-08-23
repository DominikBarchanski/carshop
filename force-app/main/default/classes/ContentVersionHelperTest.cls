/**
 * Created by dominikbarchanski on 18/08/2022.
 */

@IsTest
private class ContentVersionHelperTest {
    @TestSetup
    private static void setupTestData() {
        Product2 prod1 = new Product2(Name = 'a', Fuel_Consumption_In_The_City__c = 1,
                Average_Fuel_Consumption__c = 1,
                Number_of_Doors__c = 1,
                Cylinder_Capacity__c = 1,
                Number_of_Places__c = 1,
                Top_Speed__c = 1
        );
        Product2 prod2 = new Product2(Name = 'a', Fuel_Consumption_In_The_City__c = 1,
                Average_Fuel_Consumption__c = 1,
                Number_of_Doors__c = 1,
                Cylinder_Capacity__c = 1,
                Number_of_Places__c = 1,
                Top_Speed__c = 1);
        insert prod1;
        insert prod2;
        ContentVersion content = new ContentVersion();
        content.Title = 'Title_Picture';
        content.FirstPublishLocationId = prod1.Id;
        content.PathOnClient = '/' + content.Title + '.jpg';
        Blob bodyBlob = Blob.valueOf('Test ContentVersion Body');
        content.VersionData = bodyBlob;
        insert content;
    }
    @IsTest
    static void testBehavior() {
        Product2 prod = new Product2(name='test');
        insert prod;
        Blob bodyBlob = Blob.valueOf('Test ContentVersion Body');
        ContentVersion item= new ContentVersion(Product__c=prod.Id,VersionData=bodyBlob,Title='test',PathOnClient='/src');
        insert item;
        ContentVersionHelper.insertContentDistribution(new List<ContentVersion>{item});
    }
    @IsTest
    static void testBehaviorOvverriade() {
        Product2 items = new Product2(Name='test');
        insert items;
        ContentVersion item = [
                SELECT
                        Checksum,
                        ContentBodyId,
                        ContentDocumentId,
                        ContentLocation,
                        ContentModifiedById,
                        ContentModifiedDate,
                        ContentSize,
                        ContentUrl,
                        CreatedById,
                        CreatedDate,
                        Description,
                        ExternalDataSourceId,
                        ExternalDocumentInfo1,
                        ExternalDocumentInfo2,
                        FeaturedContentBoost,
                        FeaturedContentDate,
                        FileExtension,
                        FileType,
                        FirstPublishLocationId,
                        Id,
                        IsAssetEnabled,
                        IsDeleted,
                        IsLatest,
                        IsMajorVersion,
                        LastModifiedById,
                        LastModifiedDate,
                        NegativeRatingCount,
                        NetworkId,
                        Origin,
                        OwnerId,
                        PathOnClient,
                        PositiveRatingCount,
                        Product__c,
                        PublishStatus,
                        RatingCount,
                        ReasonForChange,
                        SharingOption,
                        SharingPrivacy,
                        SystemModstamp,
                        TagCsv,
                        TextPreview,
                        Title,
                        VersionData,
                        VersionNumber
                FROM ContentVersion LIMIT 1];
        item.Title ='test';
        item.Product__c = items.Id;
        update item;

    }
    private static final String TRIGGERCONTEXTERROR = 'Trigger handler called outside of Trigger execution';

    private static String LastMethodCalled;

    private static ContentVersionHelperTest.TestHandler Handler;

    static {
        handler = new ContentVersionHelperTest.TestHandler();
        // override its internal trigger detection
        handler.isTriggerExecuting = true;
    }

    /***************************************
     * unit tests
     ***************************************/

    // contexts tests

    @isTest
    static void testBeforeInsert() {
        beforeInsertMode();
        handler.run();
        System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    }

    @isTest
    static void testBeforeUpdate() {
        beforeUpdateMode();
        handler.run();
        System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
    }

    @isTest
    static void testBeforeDelete() {
        beforeDeleteMode();
        handler.run();
        System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
    }

    @isTest
    static void testAfterInsert() {
        afterInsertMode();
        handler.run();
        System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
    }

    @isTest
    static void testAfterUpdate() {
        afterUpdateMode();
        handler.run();
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
    }

    @isTest
    static void testAfterDelete() {
        afterDeleteMode();
        handler.run();
        System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
    }

    @isTest
    static void testAfterUndelete() {
        afterUndeleteMode();
        handler.run();
        System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
    }

    @isTest
    static void testNonTriggerContext() {
        try {
            handler.run();
            System.assert(false, 'the handler ran but should have thrown');
        } catch (TriggerHandler.TriggerHandlerException te) {
            System.assertEquals(TRIGGERCONTEXTERROR, te.getMessage(), 'the exception message should match');
        } catch (Exception e) {
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }
    }

    // test bypass api

    @isTest
    static void testBypassAPI() {
        afterUpdateMode();

        // test a bypass and run handler
        TriggerHandler.bypass('TestHandler');
        handler.run();
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();

        // clear that bypass and run handler
        TriggerHandler.clearBypass('TestHandler');
        handler.run();
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();

        // test a re-bypass and run handler
        TriggerHandler.bypass('TestHandler');
        handler.run();
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();

        // clear all bypasses and run handler
        TriggerHandler.clearAllBypasses();
        handler.run();
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();
    }

    // instance method tests

    @isTest
    static void testLoopCount() {
        beforeInsertMode();

        // set the max loops to 2
        handler.setMaxLoopCount(2);

        // run the handler twice
        handler.run();
        handler.run();

        // clear the tests
        resetTest();

        try {
            // try running it. This should exceed the limit.
            handler.run();
            System.assert(false, 'the handler should throw on the 3rd run when maxloopcount is 3');
        } catch (TriggerHandler.TriggerHandlerException te) {
            // we're expecting to get here
            System.assertEquals(null, lastMethodCalled, 'last method should be null');
        } catch (Exception e) {
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }

        // clear the tests
        resetTest();

        // now clear the loop count
        handler.clearMaxLoopCount();

        try {
            // re-run the handler. We shouldn't throw now.
            handler.run();
            System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
        } catch (TriggerHandler.TriggerHandlerException te) {
            System.assert(false, 'running the handler after clearing the loop count should not throw');
        } catch (Exception e) {
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }
    }

    @isTest
    static void testLoopCountClass() {
        TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount();
        System.assertEquals(5, lc.getMax(), 'max should be five on init');
        System.assertEquals(0, lc.getCount(), 'count should be zero on init');

        lc.increment();
        System.assertEquals(1, lc.getCount(), 'count should be 1');
        System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 1');

        lc.increment();
        lc.increment();
        lc.increment();
        lc.increment();
        System.assertEquals(5, lc.getCount(), 'count should be 5');
        System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 5');

        lc.increment();
        System.assertEquals(6, lc.getCount(), 'count should be 6');
        System.assertEquals(true, lc.exceeded(), 'should not be exceeded with count of 6');
    }

    // private method tests

    @isTest
    static void testGetHandlerName() {
        System.assertEquals('TestHandler', handler.getHandlerName(), 'handler name should match class name');
    }

    // test virtual methods

    private static void testVirtualMethods() {
        TriggerHandler h = new TriggerHandler();
        h.beforeInsert();
        h.beforeUpdate();
        h.beforeDelete();
        h.afterInsert();
        h.afterUpdate();
        h.afterDelete();
        h.afterUndelete();
    }

    /***************************************
     * testing utilities
     ***************************************/

    private static void resetTest() {
        lastMethodCalled = null;
    }

    // modes for testing

    private static void beforeInsertMode() {
        handler.setTriggerContext('before insert', true);
    }

    private static void beforeUpdateMode() {
        handler.setTriggerContext('before update', true);
    }

    private static void beforeDeleteMode() {
        handler.setTriggerContext('before delete', true);
    }

    private static void afterInsertMode() {
        handler.setTriggerContext('after insert', true);
    }

    private static void afterUpdateMode() {
        handler.setTriggerContext('after update', true);
    }

    private static void afterDeleteMode() {
        handler.setTriggerContext('after delete', true);
    }

    private static void afterUndeleteMode() {
        handler.setTriggerContext('after undelete', true);
    }

    // test implementation of the TriggerHandler

    private class TestHandler extends TriggerHandler {
        public override void beforeInsert() {
            ContentVersionHelperTest.lastMethodCalled = 'beforeInsert';
        }

        public override void beforeUpdate() {
            ContentVersionHelperTest.lastMethodCalled = 'beforeUpdate';
        }

        public override void beforeDelete() {
            ContentVersionHelperTest.lastMethodCalled = 'beforeDelete';
        }

        public override void afterInsert() {
            ContentVersionHelperTest.lastMethodCalled = 'afterInsert';
        }

        public override void afterUpdate() {
            ContentVersionHelperTest.lastMethodCalled = 'afterUpdate';
        }

        public override void afterDelete() {
            ContentVersionHelperTest.lastMethodCalled = 'afterDelete';
        }

        public override void afterUndelete() {
            ContentVersionHelperTest.lastMethodCalled = 'afterUndelete';
        }
    }
}
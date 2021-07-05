@IsTest
private class WarehouseCalloutServiceTest {
    @IsTest
    static void testEquipmentSync(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());        
        ID jobID = System.enqueueJob(new WarehouseCalloutService());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> items = [SELECT Id, Name FROM Product2];

        System.assert(items.size() == 22);
    }
}
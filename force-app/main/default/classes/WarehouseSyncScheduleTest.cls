@isTest
public with sharing class WarehouseSyncScheduleTest {
    @IsTest
    static void testWarehouseSyncSchedule(){
        Test.startTest();
        Id jobId = System.schedule('testWarehouseCallout', '0 0 0 10 10 ? 2021', new WarehouseSyncSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                        FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2021-10-10 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();        
        
    }

}
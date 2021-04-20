public with sharing class MaintenanceRequestHelperTest {
    @IsTest
    static void testCreationOfMaintenanceRequest(){
        Equipment__c eq = new Equipment__c(Name = 'Steering Wheel', Maintenance_Cycle__c = 37);
        Maintenance_Request__c mR = new Maintenance_Request__c()
        Equipment_Maintenance_Item__c eqMI = 
        
    }
}
@isTest
public with sharing class MaintenanceRequestHelperTest {
    @testSetup static void setup(){
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Product2>  equipmentList = new List<Product2>();
        List<Case> maintenanceRequestList = new List<Case>();
        List<Equipment_Maintenance_Item__c> equipmentItemList = new List<Equipment_Maintenance_Item__c>();        
        
        for(Integer i = 0; i < 6; i++){
            Vehicle__c v = new Vehicle__c(Name = 'Vehicle' + i);
            Product2 p =  new Product2(Name = 'Equipment' + i,
                                       Maintenance_Cycle__c = 10 + i*10,
                                       Cost__c = 100 + i*50);
            Case m = new Case(Origin = 'Web',
                              Description = 'Case' + i,
                              Type = 'Repair',
                              Status = 'New',
                              Subject = 'Subject' + i,
                              Vehicle__c = v.Id);
            /*                              
            if(i < 2){
                m.Type = 'Mechanical';
            }else if(i < 4){
                m.Type = 'Repair';
            }else{
                m.Type = 'Routine Maintenance';
            }
            */
            Equipment_Maintenance_Item__c eq = new Equipment_Maintenance_Item__c(
                                       Equipment__c = p.Id,
                                       Maintenance_Request__c = m.Id);
            vehicleList.add(v);
            equipmentList.add(p);
            maintenanceRequestList.add(m);
            equipmentItemList.add(eq);
        }
        insert vehicleList;
        insert equipmentList;
        insert maintenanceRequestList;
        insert equipmentItemList;
    } 
    @IsTest
    static void testPositiveCase(){
        //TODO Write Unit tests for the first task.
        List<Case> repairCases = [SELECT Id,
                         Case.Vehicle__c, 
                         (SELECT Id, 
                                 Name, 
                                 Equipment__r.Maintenance_Cycle__c 
                          FROM Equipment_Maintenance_Items__r),
                         Status,
                         Subject  
                  FROM Case 
                  WHERE Type = 'Routine Maintenance' OR
                        Type = 'Repair'];
        //Closing Maintenance Requests                        
        for(Case c : repairCases){
            c.Status = 'Closed';
        }
        insert repairCases;
        //Getting Maintenance Requests created by the trigger
        List<Case> triggerCaseList = [SELECT  Id,
                                              Case.Vehicle__c, 
                                              (SELECT Id, 
                                                      Name, 
                                                      Equipment__r.Maintenance_Cycle__c 
                                              FROM Equipment_Maintenance_Items__r),
                                              Status,
                                              Subject 
                                      FROM Case 
                                      WHERE Status = 'New' AND
                                          Type   = 'Routine Maintenance' AND
                                          Subject LIKE 'Subject%'];
        //Assert number of triggerMaintenance Requests equals number of closed cases                          
        System.assertEquals(repairCases.size(), triggerCaseList.size());
    }
}
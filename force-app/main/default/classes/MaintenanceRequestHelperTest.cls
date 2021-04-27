@isTest
public with sharing class MaintenanceRequestHelperTest {
    @testSetup static void setup(){
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Product2>  equipmentList = new List<Product2>();
        List<Case> maintenanceRequestList = new List<Case>();
        List<Equipment_Maintenance_Item__c> equipmentItemList = new List<Equipment_Maintenance_Item__c>();        
        
        for (Integer i = 0; i < 5; i++) {
            Vehicle__c v = new Vehicle__c(Name = 'Vehicle' + i);
            vehicleList.add(v);   
        }
        insert vehicleList;
        for (Integer i = 0; i < 5; i++) {
            Product2 p =  new Product2(Name = 'Equipment' + i,
                                       Maintenance_Cycle__c = 10 + i*10,
                                       Replacement_Part__c = true,
                                       Cost__c = 100 + i*50);        
            equipmentList.add(p);
        }
        insert equipmentList;
        for(Integer i = 0; i < 300; i++){

            Case m = new Case(Origin = 'Web',
                              Description = 'Case' + i,
                              Status = 'Working',
                              Subject = 'Subject' + i,
                              Vehicle__c = vehicleList.get(Math.mod(i, 5)).Id);
            if(i < 4){
                m.Type = 'Repair';
            }else{
                m.Type = 'Routine Maintenance';
            }
            maintenanceRequestList.add(m);
        }
        insert maintenanceRequestList;
        for (Integer i = 0; i < 300; i++) {
            Equipment_Maintenance_Item__c eq = new Equipment_Maintenance_Item__c(
                Equipment__c = equipmentList.get(Math.mod(i, 5)).Id,
                Maintenance_Request__c = maintenanceRequestList.get(i).Id);
            equipmentItemList.add(eq);
        }
        for (Integer i = 0; i < 300; i++) {
            Equipment_Maintenance_Item__c eq = new Equipment_Maintenance_Item__c(
                Equipment__c = equipmentList.get(Math.mod(i, 2)).Id,
                Maintenance_Request__c = maintenanceRequestList.get(i).Id);
            equipmentItemList.add(eq);
        }
        insert equipmentItemList;
    } 
    //@IsTest
    // static void testPositiveCase(){
    //     setup();
    //     //TODO Write Unit tests for the first task.
    //     List<Case> repairCases = [SELECT Id,
    //                                     Case.Vehicle__c, 
    //                                     (SELECT Id, 
    //                                             Name, 
    //                                             Equipment__r.Maintenance_Cycle__c 
    //                                      FROM Equipment_Maintenance_Items__r),
    //                                     Status,
    //                                     Subject  
    //                               FROM Case 
    //                               WHERE Type = 'Routine Maintenance' OR
    //                                     Type = 'Repair'
    //                               ORDER BY Subject ASC];
    //     Map<Id, List<Equipment_Maintenance_Item__c>> maintReqAndEquipmentItems = new Map<Id, List<Equipment_Maintenance_Item__c>>();                        
    //     List<Equipment_Maintenance_Item__c> allEquipmentItems = [SELECT Id, 
    //                                                                     Maintenance_Request__r.Id, 
    //                                                                     Equipment__r.Maintenance_Cycle__c  
    //                                                             FROM Equipment_Maintenance_Item__c];
    //     //Closing Maintenance Requests                        
    //     for(Case c : repairCases){
    //         c.Status = 'Closed';
    //         maintReqAndEquipmentItems.put(c.Id, getItemsForCase(c.Id, allEquipmentItems));
    //     }
    //     upsert repairCases;
    //     //Getting Maintenance Requests created by the trigger
    //     List<Case> triggerCaseList = [SELECT  Id,
    //                                           Case.Vehicle__c, 
    //                                           (SELECT Id, 
    //                                                   Name, 
    //                                                   Equipment__r.Maintenance_Cycle__c 
    //                                           FROM Equipment_Maintenance_Items__r),
    //                                           Status,
    //                                           Subject 
    //                                   FROM Case 
    //                                   WHERE Status = 'New' AND
    //                                       Type   = 'Routine Maintenance' AND
    //                                       Subject LIKE 'Subject%'
    //                                   ORDER BY Subject ASC ];
    //     //Assert the number of triggerMaintenance Requests equals the number of closed cases                          
    //     System.assertEquals(repairCases.size(), triggerCaseList.size());
    //     for (Integer i = 0; i < repairCases.size(); i++) {
    //         System.assertEquals(repairCases.get(i).Vehicle__c, triggerCaseList.get(i).Vehicle__c);
    //         System.assertEquals(repairCases.get(i).Subject, triggerCaseList.get(i).Subject);
    //         //System.assertEquals(maintReqAndEquipmentItems.get(repairCases.get(i).Id).size() , getItemsForCase(triggerCaseList.get(i).Id, allEquipmentItems).size());
    //         //System.assertEquals(getTheShortestCycle(maintReqAndEquipmentItems.get(repairCases.get(i).Id)), (triggerCaseList.get(i).Date_Due__c.daysBetween(System.today())));
    //     }
    // }
        public static List<Equipment_Maintenance_Item__c> getItemsForCase(Id caseId, List<Equipment_Maintenance_Item__c> allEquipmentList){
            List<Equipment_Maintenance_Item__c> eqMaintItems = new List<Equipment_Maintenance_Item__c>();
            for(Equipment_Maintenance_Item__c eq : allEquipmentList){
                if(eq.Maintenance_Request__r.Id == caseId)
                    eqMaintItems.add(eq);
            }
            return eqMaintItems;                                                            
        }
    // public static Integer getTheShortestCycle(List<Equipment_Maintenance_Item__c> equipmentItemsList){
    //     Integer shortestCycle = 0;
    //     for(Equipment_Maintenance_Item__c eq : equipmentItemsList){
    //         if(shortestCycle == 0 || shortestCycle > eq.Equipment__r.Maintenance_Cycle__c){
    //             shortestCycle = (Integer)eq.Equipment__r.Maintenance_Cycle__c;
    //         }
    //     }
    //     return shortestCycle;
    // }
    @isTest
    static void testPositiveCase(){
        Case m = [SELECT Id,
                         Case.Vehicle__r.Id, 
                         (SELECT Id, 
                                 Name, 
                                 Equipment__r.Maintenance_Cycle__c 
                          FROM Equipment_Maintenance_Items__r),
                          Status,
                          Subject  
                 FROM Case 
                 WHERE (Type = 'Routine Maintenance' OR
                        Type = 'Repair') AND 
                        Subject LIKE 'Subject_'
                 LIMIT 1];
        List<Equipment_Maintenance_Item__c> allEquipmentList = [SELECT Id, 
                                                                        Maintenance_Request__r.Id, 
                                                                        Equipment__r.Maintenance_Cycle__c  
                                                                FROM Equipment_Maintenance_Item__c];        
                       
        List<Equipment_Maintenance_Item__c> closedCaseItems = getItemsForCase(m.Id, allEquipmentList);    
        m.Status = 'Closed';
        upsert m;
        
        List<Case> triggerCaseList = [SELECT Id,
                                            Case.Vehicle__r.Id, 
                                            (SELECT Id, 
                                                    Name, 
                                                    Equipment__r.Maintenance_Cycle__c 
                                            FROM Equipment_Maintenance_Items__r),
                                            Status,
                                            Subject  
                                    FROM Case 
                                    WHERE Status = 'New'
                                    ORDER BY Subject ASC];
        allEquipmentList = [SELECT Id, 
                                   Maintenance_Request__r.Id, 
                                   Equipment__r.Maintenance_Cycle__c  
                            FROM Equipment_Maintenance_Item__c];                                   
        //One case closed = One case created
        System.assertEquals(1, triggerCaseList.size());
        Case tc = triggerCaseList.get(0);
        List<Equipment_Maintenance_Item__c> triggerItemsList = getItemsForCase(tc.Id, allEquipmentList);
        //Number of equipment items in the new case equals number of items in the closed case
        System.assertEquals(closedCaseItems.size(), triggerItemsList.size());
        
        Map<Id, Equipment_Maintenance_Item__c> triggerItemsMap = new Map<Id, Equipment_Maintenance_Item__c>();
        for(Equipment_Maintenance_Item__c eq : triggerItemsList){
            triggerItemsMap.put(eq.Id, eq);
        }
        for (Equipment_Maintenance_Item__c eq : closedCaseItems) {
            //Every item that belonged to the closed case belongs to the new case
            System.assert(triggerItemsMap.containsKey(eq.Id));
        }
        System.assertEquals(m.Subject,tc.Subject);
        System.assertEquals(m.Vehicle__r.Id, tc.Vehicle__r.Id);
        //Not sure how to test due date without copying trigger code.                                                                                         
    }
    @isTest
    static void negativeCaseTest(){
        Vehicle__c v = [SELECT Id, Name FROM Vehicle__c LIMIT 1];
        Case mtRq = new Case(Origin = 'Web',
                            Description = 'Negative Case' ,
                            Status = 'Working',
                            Subject = 'Subject for the Negative Case',
                            Vehicle__c = v.Id);
        mtRq.Status = 'Closed';
        upsert mtRq;
        List<Case> triggerCaseList = [SELECT Id,
                                            Case.Vehicle__r.Id, 
                                            (SELECT Id, 
                                                    Name, 
                                                    Equipment__r.Maintenance_Cycle__c 
                                            FROM Equipment_Maintenance_Items__r),
                                            Status,
                                            Subject  
                                    FROM Case 
                                    WHERE Status = 'New'
                                    ORDER BY Subject ASC];
        System.assertEquals(0, triggerCaseList.size());
        
    }
    @isTest
    static void bulkTest(){
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
                                        Type = 'Repair'
                                  ORDER BY Subject ASC];
        for (Case c : repairCases) {
            c.Status = 'Closed';
        }
        upsert repairCases;
        System.assertEquals(repairCases.size(), [SELECT Id FROM Case WHERE Type = 'Routine Maintenance' AND Status = 'New'].size());                                  
    }
}
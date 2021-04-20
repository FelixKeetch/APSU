// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Case> cases = [SELECT Id,Case.Vehicle__c, (SELECT Id, Name, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r),Status, Subject  FROM Case];
Decimal shCycle = 0;
Map<Id, Decimal> maintenanceRequestAndShortestCycle = new Map<Id, Decimal>();
for(Case c : cases){
    //Find the shortest cycle
    for(Equipment_Maintenance_Item__c eq : c.Equipment_Maintenance_Items__r){
        if(shCycle == 0 || shCycle > eq.Equipment__r.Maintenance_Cycle__c)
              shCycle = eq.Equipment__r.Maintenance_Cycle__c;
        }
    System.debug('Id : ' + c.Id + ' shCycle : ' + shCycle);
    shCycle = 0;
    
}

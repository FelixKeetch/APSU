// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/*
List<Id> dataEquipmentIdList = new List<id>();
dataEquipmentIdList.add((Id)'01t090000028wrIAAQ');
dataEquipmentIdList.add((Id)'01t090000028wrPAAQ');
List<Product2> updatedEquipmentList = [SELECT Id, Name FROM Product2 WHERE Id IN :dataEquipmentIdList];
for(Product2 p : updatedEquipmentList){
    System.debug(p.id + ' - ' +  p.Name);
}
*/
System.enqueueJob(New WarehouseCalloutService());

public class TempStruct{
        public Id idNum;
        public Boolean replacement;
        public Integer quantity;
        public String name;
        public Integer maintenanceperiod;
        public Integer lifespan;
        public Integer cost;
        public Integer sku;
}



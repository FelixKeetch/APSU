public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
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
    /* {"_id":"55d66226726b611100aaf741",
        "replacement":false,
        "quantity":5,
        "name":"Generator 1000 kW",
        "maintenanceperiod":365,
        "lifespan":120,
        "cost":5000,
        "sku":"100003"},
    */

    public void execute(QueueableContext context){
        runWarehouseEquipmentSync();
    }
    @future(callout = true)
    public static void runWarehouseEquipmentSync(){
        /*********Documentation************/
         // Instantiate a new http object
         Http h = new Http();
        
         // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        String data = res.getBody();
        /***********************************/

        List<TempStruct> dataList = (List<TempStruct>) JSON.deserialize(data, List<TempStruct>.class);
        List<Id> dataEquipmentIdList = new List<id>();

        for(TempStruct t : dataList){
            dataEquipmentIdList.add(t.idNum);
        }
        
        List<Product2>    updatedEquipmentList = [SELECT Id, Name FROM Product2 WHERE Id IN :dataEquipmentIdList];
        
        //Making Map for easier work in the following loop
        Map<Id, Product2> updatedEquipmentMap = new Map<Id, Product2>(updatedEquipmentList);
        updatedEquipmentList.clear();
        
        //For each retrieved from HTTP record update the matching record in SF 
        for(TempStruct t : dataList)
        {
            Product2 p = updatedEquipmentMap.get(t.idNum);
            p.Replacement_Part__c  = t.replacement;
            p.Current_Inventory__c = t.quantity;
            p.Cost__c              = t.cost;
            p.Lifespan_Months__c   = t.lifespan;
            p.Maintenance_Cycle__c = t.maintenanceperiod;
            p.Warehouse_SKU__c	   = String.valueOf(t.sku);
            updatedEquipmentList.add(p);
        }
        if(updatedEquipmentList.size() > 0){
            upsert updatedEquipmentList;
        }   
    }


}
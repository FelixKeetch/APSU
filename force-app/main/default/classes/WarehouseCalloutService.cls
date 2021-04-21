public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
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
        List<Product2> equipmentList = new List<Product2>();
        List<Object> jsonResponse = (List<Object>) Json.deserializeUntyped(data);
            
        for(Object obj : jsonResponse){
            Map<String, Object> mapJson = (Map<String, Object>) obj;
            Product2 objProduct = new Product2();
            objProduct.Replacement_Part__c = true;
            objProduct.Name = (String) mapJson.get('name'); 
            objProduct.Maintenance_Cycle__c = (Integer) mapJson.get('maintenanceperiod');
            objProduct.Lifespan_Months__c = (Integer) mapJson.get('lifespan');
            objProduct.Cost__c = (Decimal) mapJson.get('cost');
            objProduct.Warehouse_SKU__c = (String) mapJson.get('sku');
            objProduct.Current_Inventory__c = (Integer) mapJson.get('quantity');
            equipmentList.add(objProduct);
        }
        if(equipmentList.size() > 0){
            upsert equipmentList;
        }

    }


}
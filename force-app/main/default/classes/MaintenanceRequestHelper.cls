public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> cases) {
        List<Case> newCases = new List<Case>();
        
        for(Case c : cases){
            //Find the shortest cycle
            Decimal shCycle = 0;
            for(Equipment_Maintenance_Item__c eq : c.Equipment_Maintenance_Items__r){
                if(shCycle == 0 || shCycle > eq.Equipment__r.Maintenance_Cycle__c)
                  shCycle = eq.Equipment__r.Maintenance_Cycle__c;
            }
            //Create a new Maintenance Request(Changed Case)
            Case newCase = new Case(
                Type = 'Routine Maintenance',
                Status = 'New'
            );
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Date_Reported__c = Date.today();
            //Save a Closed Maintenance Request's Id:
            newCase.ParentId = c.Id;
            
            //If none of the equipment items has a cycle today's date is set, otherwise -
            // today's date + the shortest cycle
            newCase.Date_Due__c = Date.Today().addDays((Integer)shCycle);
            newCase.Subject = String.isBlank(c.Subject) ? 'Routine Maintenance Request' : c.Subject;
        	newCases.add(newCase);
		}
        if(newCases.size() > 0){
            insert newCases;
            //TODO When do sObject's Ids get populated? 
            reparentEquipment(newCases);
        }   
        
    }     
    public static void reparentEquipment(List<Case> newCases){
        List<Equipment_Maintenance_Item__c> allEquipmentItems = [SELECT Id, Maintenance_Request__c FROM Equipment_Maintenance_Item__c ];
        List<Equipment_Maintenance_Item__c> reparentedEqItems = new List<Equipment_Maintenance_Item__c>();

        for(Case c : newCases){
            for(Equipment_Maintenance_Item__c eq : allEquipmentItems){
                if(eq.Maintenance_Request__c == c.ParentId){
                    eq.Maintenance_Request__c = c.Id;
                    reparentedEqItems.add(eq);
                }
                  
            }
        }

        if(reparentedEqItems.size()> 0)
            update reparentedEqItems;

    }  
    
}
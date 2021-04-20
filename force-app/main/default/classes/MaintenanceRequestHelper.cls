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
                Vehicle__c = c.Vehicle__c,
                Type = 'Routine Maintenance',
                Status = 'New'
            );
            newCase.Date_Reported__c = Date.today();
            //If none of the equipment items has a cycle today's date is set, otherwise -
            // today's date + the shortest cycle
            newCase.Date_Due__c = (shCycle == 0) ? Date.today(): 
                Date.today().addDays((Integer)shCycle);
            newCase.Subject = String.isBlank(c.Subject) ? 'Routine Maintenance Request' : c.Subject;
        	newCases.add(newCase);
		}
        if(newCases.size() > 0){
            insert newCases;
        }   
        
    }        
    
}
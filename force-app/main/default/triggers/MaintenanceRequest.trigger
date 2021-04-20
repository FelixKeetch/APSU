trigger MaintenanceRequest on Case (before update, after update) {
    if(Trigger.isAfter){
            
        List<Case> closedCases = [SELECT Id,
                                        Case.Vehicle__c, 
                                        (SELECT Id, Name, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r),
                                        Status,
                                        Subject  
                                  FROM Case 
                                  WHERE Id IN :Trigger.New 
                                  AND Status = 'Closed' 
                                  AND (Type = 'Routine Maintenance' OR Type = 'Repair')];
        if(closedCases.size() > 0)
            MaintenanceRequestHelper.updateWorkOrders(closedCases);
    }
    /*    
    insert closedCases;
    */
        
}
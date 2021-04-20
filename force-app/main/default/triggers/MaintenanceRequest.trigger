trigger MaintenanceRequest on Case (before update, after update) {
    List<Case> closedCases = new List<Case>();
    for(Case c : Trigger.New){
        if((c.Type == 'Repair' || c.Type == 'Routine Maintenance') && c.Status == 'Closed'){
            
            //retrieve Equipment Items' info(Maintenance cycle)
            Case tempCase = [SELECT Id,Case.Vehicle__c, (SELECT Id, Name, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r),Status, Subject  FROM Case WHERE Id = :c.Id LIMIT 1];
            closedCases.add(tempCase);
        
        
        }
    }
    if(closedCases.size() > 0)
        MaintenanceRequestHelper.updateWorkOrders(closedCases);
    
        
}
trigger ValidatePositionTrigger on Position__c (before delete) {
       Position__c position=Trigger.old[0];
       if(position.Status__c=='Open-Approval'){
        position.addError('Status is Open-Approval.Record cannot be Deleted.');
            }else{
                List<PositionBackup__c> Listpos=new List<PositionBackup__c>();
                for(Position__c pos:Trigger.old){
                    PositionBackup__c pos1=new PositionBackup__c();
                    pos1.Name=pos.Name;
                    pos1.Close_Date__c=pos.Close_Date__c;
                    pos1.Job_Description__c=pos.Job_Description__c;
                    pos1.Functional_Area__c=pos.Functional_Area__c;
                    pos1.Job_Level__c=pos.Job_Level__c;
                    pos1.Location__c=pos.Location__c;
                    pos1.Max_Pay__c=pos.Max_Pay__c;
                    pos1.Min_Pay__c=pos.Min_Pay__c;
                    pos1.Open_Date__c=pos.Open_Date__c;
                    pos1.Status__c=pos.Status__c;
                    pos1.Travel_Required__c=pos.Travel_Required__c;
                    Listpos.add(pos1);
                }
                insert Listpos;
            }
}
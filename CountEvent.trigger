trigger CountEvent on Event (after insert,after delete,after undelete) {
    
    Set<id> leadid=new Set<id>();
    List<lead> leadToUpdate=new List<lead>();
    
    //for Inserting new Event or Undeleting and Event
    if(trigger.IsInsert || trigger.IsUnDelete){
        for(Event e : Trigger.new){
            if(string.valueOf(e.whoId).startsWith('00Q')){
                leadid.add(e.whoId);
            }
            
        }
    }
    
    //For deleting and Event
     if(trigger.IsDelete){
        for(Event e : Trigger.old){
            if(string.valueOf(e.whoId).startsWith('00Q')){
                leadid.add(e.whoId);
            }
            
        }
    }
    //Nested  Query
    // First inner query will Run. 
    // Whatever the output of inner query, it will act as an input to the outer query.
    if(leadid.size() > 0){
        
        for(lead l : [Select l.id, l.Number_of_Events__c, (Select id from Events) from Lead l where id In:leadid])
        {
            leadToUpdate.add(new lead(id=l.id,Number_of_Events__c=l.events.size()));
        }
        update leadToUpdate;
        
    }
 
}
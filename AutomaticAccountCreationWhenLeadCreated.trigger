trigger AutomaticAccountCreationWhenLeadCreated on Lead (before insert) {
    //To Store every email in the SET i.e emailSet
    Set<String> emailSet=new Set<String>();
    for(Lead lead :Trigger.new){
        if(lead.email!=NULL){
            emailSet.add(lead.email);
        }
    }
    //Map with String and Account
    //Id and Email that are in the Set are copied to a List
    Map<String,Account> emailMap=new Map<String,Account>();
    if(emailSet !=NULL && emailSet.size() > 0){
        List<Account> accountList=[Select Id,Name,Email__c from Account where Email__c in :emailSet];
        //For Every Account Id and Email will be there in emailMap
        if(accountList.size() > 0){
            for(Account a :accountList)
                emailMap.put(a.Email__c, a);
            }
        }
        List<Account> upsertList=new List<Account>();
        for(Lead lead : Trigger.new){
            Account acc =new Account();
            if(emailMap.size() > 0 && emailMap.containsKey(lead.email)){
                acc=emailMap.get(lead.email);
                acc.Name=lead.LastName;
                upsertList.add(acc);
            }else{
                acc.Name=lead.LastName;
                acc.Email__c=lead.email;
                upsertList.add(acc);
            }
        }
        if(upsertList.size()>0){
            upsert upsertList;
        }
    }
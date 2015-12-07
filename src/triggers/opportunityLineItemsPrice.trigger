trigger opportunityLineItemsPrice on Opportunity (after insert, after update) {

    //Map<String, Decimal> oppList = new Map<String, Decimal>{};
    Decimal oldAmt;
    Decimal workPrice;    
    Integer rowsProcessed;
    Integer oppListSize;
    String recordID;   
    Integer compareTotal;    
    Integer varQty;
    Integer varPrice;    
    Decimal oldQty;
    Boolean updLns;
    Decimal amtDiff;
    Decimal qtyCount; 
    Map<ID, Opportunity> oppList = new Map<ID, Opportunity>();
    
    //Iterate through the Opportunities

    for(Opportunity opp : Trigger.New)  {

     oppList.put(opp.Id,Opp);
     if(Trigger.IsInsert) {    
        oldAmt = 10;
     }
     if(Trigger.IsUpdate) {    
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        oldAmt = oldOpp.OppAmount__c;
        recordID = oldOpp.Record_Id__c;
        oldQty = oldOpp.TotalOpportunityQuantity;
     }        
    }


    list<OpportunityLineItem> listOfOpportunityLineItems = new list<OpportunityLineItem>();
    oppListSize = 0;    
    rowsProcessed = 0;
    workPrice = 0;
    qtyCount = 0;
    updLns = False;  
             
    Integer i = [select count() from OpportunityLineItem where OpportunityId In : oppList.keyset()];
    oppListSize = i; 
    
    List<AggregateResult> res = [select sum(Quantity) Qty from OpportunityLineItem where OpportunityId In : oppList.keyset()];

    for (AggregateResult ar: res){
       varQty = Integer.valueOf(ar.get('Qty'));    
    }   
   
    
    //Get Opportunity Line Items that are associated to the Opportunity
    for(OpportunityLineItem oli :  [Select Id, OpportunityId, Quantity From OpportunityLineItem Where OpportunityId In : oppList.keyset()]){
    
    Opportunity OppObj = oppList.get(oli.OpportunityId);
    
       if(OppObj != NUll){
       
           rowsProcessed = rowsProcessed + 1;           
           workPrice = (OppObj.OppAmount__c / OppObj.TotalOpportunityQuantity).setscale(2, RoundingMode.UP);
           qtyCount = qtyCount + oli.Quantity;           
           
           if ((oldAmt != OppObj.OppAmount__c) || (recordID != NULL && oldQty == varQty && oli.Quantity > 0)){
           
                updLns = True;
                //Check if rounding will cause amount to be off                                
                if (OppObj.OppAmount__c != workPrice * OppObj.TotalOpportunityQuantity){                  
                //Check if last Product in shopping cart                                                
                  if (rowsProcessed == oppListSize ) {                                      
                    amtDiff = (OppObj.OppAmount__c - (workPrice * qtyCount));
                    amtDiff = amtDiff / oli.Quantity;
                    oli.UnitPrice = workPrice + amtDiff;                                                             
                  }                   
                  else {                     
                    oli.UnitPrice = workPrice;                                           
                  }                
                }                
                else {                    
                   oli.UnitPrice = workPrice;                                                 
                }                                    
          }
       }
       if(updLns == True){
         listOfOpportunityLineItems.add(oli);         
       }
    }
    if(updLns == True) {
        try {
              Update listOfOpportunityLineItems;
        }     
        catch (DMLException e) {
            for (Opportunity errorValRule : trigger.new) {
            //Do not display error if Validation Rule fails            
            //errorValRule.addError(e.getDmlMessage(0));
            }
        }
        catch (Exception e) {
            for (Opportunity errorValRule : trigger.new) {
            //Do not display error if Validation Rule fails 
            //errorValRule.addError(e.getMessage());
        }
    }}
}
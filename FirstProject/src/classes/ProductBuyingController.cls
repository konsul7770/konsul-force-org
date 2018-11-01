public class ProductBuyingController {
    
    public string email{get;set;}
    public string fname{get;set;}
    public string lname{get;set;}
    public Integer amount{get;set;}
    public boolean hasError{get;private set;}
    private Id idcontact;
    private Product_Table__c p;
    
    public PageReference getContact(){
        List<Contact> c = new List<Contact>();
        c = [select Email, FirstName, LastName from Contact where Email =: email limit 1];
        if(c.size() > 0){
            c[0].FirstName = fname;
            c[0].lastname = lname;
            upsert c;
        }else if(c.size() == 0){
            Contact tmpcon = new Contact();
            tmpcon.Email = email;
            tmpcon.FirstName = fname;
            tmpcon.LastName = lname;
            c.add(tmpcon);
            insert c;
        }
        idcontact = c[0].id;
        return null;
    }
    
    public Product_Table__c getProduct(){
        p = [select id, Name, Product_description__c, Unit_Price__c, Units_available__c, Image_Url__c
                    from Product_Table__c 
                	where id =: ApexPages.currentPage().getParameters().get('id') limit 1];
        return p;
    }
    
    public PageReference Save(){
        Order_Table__c order = new Order_Table__c();
        order.Contact__c = idcontact;
        order.Order_Amount__c = p.unit_price__c*amount;
        order.Product__c = p.id;
        order.Units__c = amount;
        p.Units_Available__c = p.Units_Available__c - amount;
        try{
            insert order;
            upsert p;
            hasError = false;
            return null;
        }catch(Exception e){
            system.debug('Error');
            hasError = true;
            return null;
        }
    }
    public PageReference toShopping(){
        return new PageReference('/Apex/ProductList');
    }
}
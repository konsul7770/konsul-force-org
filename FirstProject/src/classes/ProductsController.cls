public with sharing class ProductsController extends  VF_Messages_Abstract{
    
    public Id pid{get;set;}
    public Id idFromPage{get{return ApexPages.currentPage().getParameters().get('id');}set;}
    
    public string email{get;set;}
    public string fname{get;set;}
    public string lname{get;set;}
    
    public Integer amount{get;set;}
    
    @TestVisible private Contact ct;
    @TestVisible private Product_Table__c p;
    
    public static List<Product_Table__c>getProductList(){
        List<Product_Table__c>plist;
        plist = new List<Product_Table__c>();
        plist = [select Image_Url__c, Name, Product_Description__c, Unit_Price__c from Product_Table__c];
        return plist;
    }
    
    public Product_Table__c getProduct(){
        p = [select id, Name, Product_description__c, Unit_Price__c, Units_available__c, Image_Url__c
                    from Product_Table__c 
                	where id =: idFromPage limit 1];
        return p;
    }
    
    public PageReference toShopping(){
        PageReference pg = new PageReference('/Apex/ProductList');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference toBuying(){
        PageReference pg = new PageReference('/Apex/ProductBuying?id='+pid);
        pg.setRedirect(true);
        return pg;
    }
    
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
        ct = c[0];
        return null;
    }
    
    public PageReference Save(){
        Order_Table__c order = new Order_Table__c();
        try{
            if(ct == null){
                throw new NullPointerException();
            }
            order.Contact__c = ct.id;
        	order.Product__c = p.id;
            if((amount < 0)||((p.Units_Available__c - amount) < 0)){
                throw new WrongNumberException('Wrong units value is entered');
            }
            order.Units__c = amount;
            order.Order_Amount__c = p.unit_price__c*amount;
        	p.Units_Available__c = p.Units_Available__c - amount;
        	insert order;
        	upsert p;
            createError(ApexPages.Severity.INFO, 'Data have saved successfully');
        }catch(NullPointerException e){
            createError(ApexPages.Severity.ERROR, 'Contact information is not entered');
        }catch(WrongNumberException e){
            createError(ApexPages.Severity.ERROR, e.getMessage());
        }
        return null;
    }
}
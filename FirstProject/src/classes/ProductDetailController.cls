public class ProductDetailController {
    
    public Id pid{get;set;}
    
    public Product_Table__c getProduct(){
        Product_Table__c[] p = [select id, Name, Product_description__c, Unit_Price__c, Units_available__c, Image_Url__c 
                               from Product_Table__c 
                               where id =: ApexPages.currentPage().getParameters().get('id')];
        return p[0];
    }
    
    public PageReference toShopping(){
        return new PageReference('/Apex/ProductList');
    }
    public PageReference toBuying(){
        return new PageReference('/Apex/ProductBuying?id='+pid);
    }
}
public class ProductListController {
    
    private List<Product_Table__c>plist;
    public Id pid{get;set;}
    
    public List<Product_Table__c>getProductList(){
        plist = new List<Product_Table__c>();
        plist = [select Image_Url__c, Name, Product_Description__c, Unit_Price__c from Product_Table__c];
        for(Product_Table__c pl:plist){
            String temp = pl.Product_Description__c;
            if(temp.length()>=100){
                pl.Product_Description__c = temp.substring(0,100);
            }
        }
        return plist;
    }
    public PageReference toBuying(){
        return new PageReference('/Apex/ProductBuying?id='+pid);
    }
}
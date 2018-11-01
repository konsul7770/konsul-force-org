@isTest
private class TestProductController {
    
    @isTest static void TestGetProductList(){
        list<Product_Table__c>plist = new List<Product_Table__c>();
        for(integer i = 0; i<10; i++){
            Product_Table__c p = new Product_Table__c(Name = 'Test'+ i,Unit_Price__c = (i+1));
            plist.add(p);
        }
        insert plist;
        
        List<Product_Table__c>pl;
        
        Test.startTest();
        pl = ProductsController.getProductList();
        Test.stopTest();
        
        System.assertEquals(10, pl.size());
    }
    
    @isTest(SeeAllData=true) static void TestGetProduct(){
        
        Product_Table__c p = new Product_Table__c(Name = 'test',Unit_Price__c = 7);
        Id idFromPage = p.Id;
        
        insert p;
        
        Product_Table__c temp;
        ProductsController pc = new ProductsController();
        ApexPages.currentPage().getParameters().put('id', p.id);
        
        Test.startTest();
        temp = pc.getProduct();
        Test.stopTest();
        System.assertEquals(p.id, temp.id);
    }
    
    @isTest static void TestGetContactInsert(){

        List<Contact> clist = new List<Contact>();
        for(integer i = 0; i<10; i++){
            Contact c = new Contact(FirstName = 'firstname'+i, LastName = 'lastname'+i, Email = 'email'+i);
            clist.add(c);
        }
        
        ProductsController pc = new ProductsController();
        pc.email = 'test@email.com';
        pc.fname = 'Testfirstname';
        pc.lname = 'Testlastname';
        
        Test.startTest();
        PageReference pg = pc.getContact();
        Test.stopTest();
        
        Contact cactual = [select id, Email, FirstName, LastName from Contact
                          where Email =: pc.ct.Email limit 1];
        System.assertEquals(pc.ct, cactual, 'contact was not inserted');
    }
    
    @isTest static void TestGetContactUpsert(){

        Contact c = new Contact(FirstName = 'Testcontact1', LastName = 'Lastname1', Email = 'testemail@mm.com');
        insert c;

        Productscontroller pc = new Productscontroller();
        pc.email=c.Email;
        pc.fname='Anotherfirsname';
        pc.lname='Anotherlastname';
        
        Test.startTest();
        PageReference pg = pc.getContact();
        Test.stopTest();
        
        Contact cactual = [select id, Email, FirstName, LastName from Contact
                          where Email =: pc.ct.Email and FirstName =:pc.fname and LastName =: pc.lname limit 1];
        System.assertEquals(pc.ct, cactual, 'contact was not inserted');
    }
    
    
    
    @isTest static void TestToShopping(){
        Test.startTest();
        ProductsController pc = new ProductsController();
        PageReference pageref = pc.toShopping();
        string link = pageref.getUrl();
        Test.stopTest();
        System.assertEquals('/apex/ProductList', link);
    }
    
    @isTest static void TestToBuying(){
        Product_Table__c prod = new Product_Table__c();
        prod.Name = 'testproduct';
        prod.Unit_Price__c = 25;
        prod.Units_Available__c = 20;
        insert prod;
        
        ProductsController pc = new ProductsController();
        pc.pid = prod.Id;
        
        Test.startTest();
        PageReference pg = pc.toBuying();
        string link = pg.getUrl();
        Test.stopTest();
        System.assertEquals(pc.pid!=null,prod.id!=null);
        System.assertEquals('/apex/ProductBuying?id='+prod.Id, link);
    }
    
    @isTest static void TestUpdateContactFields(){
        
    }
    
    @isTest static void TestSaveEmptyContact(){
        
        Contact c = null;
        ProductsController pc = new ProductsController();
        pc.ct = c;
        Test.startTest();
        PageReference pg = pc.Save();
        Test.stopTest();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
		for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Contact information is not entered')) {
                b = true;
			}
        }
        System.assert(b);
    }
    
    @isTest static void TestSaveNegativeUnitsValue(){
        
        Contact c = new Contact(FirstName = 'test', LastName = 'test', Email = 'test@test.com');
        Product_Table__c prod = new Product_Table__c();
        prod.Name = 'test';
        prod.Unit_Price__c = 4.44;
        prod.Units_Available__c = 17;
        
        ProductsController pc = new ProductsController();
        pc.ct = c;
        pc.p = prod;
        pc.amount = -20;
        Test.startTest();
        PageReference pg = pc.Save();
        Test.stopTest();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
		for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Wrong units value is entered')) {
                b = true;
			}
        }
        System.assert(b);
    }
    
    @isTest static void TestSaveBigUnitsValue(){
        
        Contact c = new Contact(FirstName = 'test', LastName = 'test', Email = 'test@test.com');
        Product_Table__c prod = new Product_Table__c();
        prod.Name = 'test';
        prod.Unit_Price__c = 4.44;
        prod.Units_Available__c = 17;
        
        ProductsController pc = new ProductsController();
        pc.ct = c;
        pc.p = prod;
        pc.amount = 20;
        Test.startTest();
        PageReference pg = pc.Save();
        Test.stopTest();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
		for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Wrong units value is entered')) {
                b = true;
			}
        }
        System.assert(b);
    }
    
    @isTest static void TestSaveAllFieldsCorrect(){
        
        Contact c = new Contact(FirstName = 'test', LastName = 'test', Email = 'test@test.com');
        insert c;
        Product_Table__c prod = new Product_Table__c();
        prod.Name = 'test';
        prod.Unit_Price__c = 4.44;
        prod.Units_Available__c = 17;
        insert prod;
        
        ProductsController pc = new ProductsController();
        pc.ct = c;
        pc.p = prod;
        pc.amount = 5;
        Test.startTest();
        PageReference pg = pc.Save();
        Test.stopTest();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
		for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Data have saved successfully')) {
                b = true;
			}
        }
        System.assert(b);
        Product_Table__c prodtest = [select Units_Available__c, id 
                                    from Product_Table__c
                                    where id=:prod.id limit 1];
        boolean hasElement = false;
        if(prodtest!=null){
            hasElement = true;
        }
        System.assert(hasElement);
        System.assertEquals(12,prodtest.Units_Available__c);
    }
}
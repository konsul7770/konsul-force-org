public class TestPageController extends VF_Messages_Abstract {
    
    public Integer a{get;set;}
    public Integer b{get;set;}
    
    public PageReference getValue(){
        
        try{
            a*=b;
            if(a>10){
                throw new MyException('Incorrect number');
            }
        }catch(MyException e){
            System.debug('cauth exception');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Incorrect value'));
        }
        return null;
    }
}
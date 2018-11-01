public class TestPageClass2 extends VF_Messages_Abstract {
    
    public Integer a{get;set;}
    public Integer b{get;set;}
    
    public PageReference test(){
        try{
            a*=b;
        	if(a>10){
            	throw new MyException('Error');
        	}
        }catch(MyException e){
        	createError(ApexPages.Severity.ERROR, 'Incorrect Error');
        }
        return null;
    }

}
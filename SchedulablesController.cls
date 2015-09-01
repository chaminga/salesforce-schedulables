//ChamingaD
public class SchedulablesController {

    public List<ApexClass> SchedulableClasses {get; set;}

    public SchedulablesController(){
        SchedulableClasses = new List<ApexClass>();
    
        for(ApexClass cls : [SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp 
                                FROM ApexClass
                                ORDER BY Name 
                                LIMIT 5000]) {
            if(cls.Body.contains('implements Schedulable')) {
                SchedulableClasses.add(cls);
            }
        }
    
    }
    
    public void executeMethod(){
        try{
             String clsName = Apexpages.currentpage().getparameters().get('clsName');

             String codeToExec = 'SchedulableContext sc = null; ' + clsName + ' cls = new '+clsName+'(); cls.execute(sc);';

             ToolingAPI tAPI = new ToolingAPI();
             ToolingAPI.ExecuteAnonymousResult toolingResult = tAPI.executeAnonymousUnencoded(codeToExec);
             
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, String.valueOf(toolingResult)) );

        } catch (Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()) );
        }
    }
}
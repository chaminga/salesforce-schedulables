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

             if (toolingResult.success){
             	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, String.valueOf(toolingResult)) );
             }else{
             	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, String.valueOf(toolingResult)) );
             }

        }catch (Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()) );
        }
    }

    public void scheduleMethod(){
    	try{
             String clsName = Apexpages.currentpage().getparameters().get('clsName');

             String codeToExec = 'System.schedule(\''+clsName+'\', \'0 0 1 ? * SUN-SAT\', new '+clsName+'());';

             ToolingAPI tAPI = new ToolingAPI();
             ToolingAPI.ExecuteAnonymousResult toolingResult = tAPI.executeAnonymousUnencoded(codeToExec);

             if (toolingResult.success){
             	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, String.valueOf(toolingResult)) );
             }else{
             	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, String.valueOf(toolingResult)) );
             }

        }catch (Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()) );
        }
    }

    public void scheduleAll(){
    	try{
			 String codeToExec = '';
			 for(ApexClass cls : SchedulableClasses){
			 	 codeToExec += 'System.schedule(\''+cls.Name+'\', \'0 0 1 ? * SUN-SAT\', new '+cls.Name+'());';
			 }

             ToolingAPI tAPI = new ToolingAPI();
             ToolingAPI.ExecuteAnonymousResult toolingResult = tAPI.executeAnonymousUnencoded(codeToExec);

             if (toolingResult.success){
             	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, String.valueOf(toolingResult)) );
             }else{
             	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, String.valueOf(toolingResult)) );
             }

        }catch (Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()) );
        }
    }
}
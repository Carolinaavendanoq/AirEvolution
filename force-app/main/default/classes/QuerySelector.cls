public class QuerySelector {
    public static List<sObject> getRecords(String sql){
        return Database.query(sql);
    }
    
    public static void InsertRecords(List<sObject> insertList, boolean partialUpdate){
            List<Database.SaveResult> results = Database.insert(insertList, partialUpdate);
            for(Database.SaveResult result: results ){
            	if(result.isSuccess()){
                	System.debug('Success');
            	}
        	}

    }
}
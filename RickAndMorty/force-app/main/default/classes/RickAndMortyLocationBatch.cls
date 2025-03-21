public class RickAndMortyLocationBatch implements Database.Batchable<String>, Database.AllowsCallouts, Database.Stateful {
    // Lists to keep track of data across batch transactions
    private List<Locacion__c> locsToProcess = new List<Locacion__c>();
    private List<String> errorRecords = new List<String>();

    // Method to start the batch process by determining the total number of pages
    public Iterable<String> start(Database.BatchableContext bc) {
        String baseUrl = 'https://rickandmortyapi.com/api/location';
        List<String> pageUrls = new List<String>();

        // Initial call to get the total number of pages
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(baseUrl);
        req.setMethod('GET');
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Map<String, Object> pageInfo = (Map<String, Object>) apiResponse.get('info');
                Integer totalPages = (Integer) pageInfo.get('pages');
                
                // Generate all page URLs based on the total pages
                for (Integer i = 1; i <= totalPages; i++) {
                    pageUrls.add(baseUrl + '?page=' + i);
                }
            } else {
                errorRecords.add('Failed to fetch initial page data');
            }
        } catch (Exception e) {
            errorRecords.add('Error fetching initial page: ' + e.getMessage());
        }
        return pageUrls;
    }

    // Method to execute the batch process for each page URL
    public void execute(Database.BatchableContext bc, List<String> pageUrls) {
        Http http = new Http();
        for (String url : pageUrls) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');

            try {
                HttpResponse res = http.send(req);
                if (res.getStatusCode() == 200) {
                    Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    List<Object> results = (List<Object>) apiResponse.get('results');
                    for (Object result : results) {
                        Map<String, Object> locationData = (Map<String, Object>) result;
                        Locacion__c loc = createLocacion(locationData);
                        if (loc != null) {
                            locsToProcess.add(loc);
                        }
                    }
                } else {
                    errorRecords.add('Failed to fetch data from URL: ' + url);
                }
            } catch (Exception e) {
                errorRecords.add('Error on API call for URL ' + url + ': ' + e.getMessage());
            }
        }
    }

    // Method to finish the batch process
    public void finish(Database.BatchableContext bc) {
        if (!locsToProcess.isEmpty()) {
            upsert locsToProcess Locacion__c.ExtId__c;
        }

        if (!errorRecords.isEmpty()) {
            System.debug('Records that encountered errors:');
            for (String error : errorRecords) {
                System.debug(error);
            }
        }
    }

    // Helper method to create Locacion records from API data
    private Locacion__c createLocacion(Map<String, Object> locationData) {
        Locacion__c loc = new Locacion__c(
            ExtId__c = (Integer) locationData.get('id'),
            Name__c = (String) locationData.get('name'),
            Type__c = (String) locationData.get('type'),
            Dimension__c = (String) locationData.get('dimension'),
			Created__c = DateTime.valueOfGmt(locationData.get('created').toString().replace('T', ' ').replace('Z', '')),
        	Url__c = (String) locationData.get('url')
    	);
    	return loc;
	}
}
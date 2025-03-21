public with sharing class LocationController {
    @AuraEnabled(cacheable=true)
    public static List<Locacion__c> getLocations() {
        return [SELECT ExtId__c, Name__c, Type__c, Dimension__c, Created__c, Url__c FROM Locacion__c ORDER BY ExtId__c ASC];
    }
}
import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getLocations from '@salesforce/apex/LocationController.getLocations';

export default class LocationList extends NavigationMixin(LightningElement) {
    @track columns = [
        { label: 'ExtId', fieldName: 'ExtId__c', type: 'number', sortable: true },
        { label: 'Name', fieldName: 'nameUrl', type: 'url', sortable: true, typeAttributes: { label: { fieldName: 'Name__c' }, target: '_blank' }},
        { label: 'Type', fieldName: 'Type__c', type: 'text', sortable: true },
        { label: 'Dimension', fieldName: 'Dimension__c', type: 'text', sortable: false },
        { label: 'Created date', fieldName: 'Created__c', type: 'datetime', sortable: false },
        { label: 'URL', fieldName: 'Url__c', type: 'url', sortable: false }
    ];
    @track locations;
    @track sortedBy;
    @track sortedDirection = 'asc';

    @wire(getLocations)
    wiredLocations({ error, data }) {
        if (data) {
            this.locations = data.map(record => {
                return {...record, nameUrl: `/${record.Id}`}
            });
        } else if (error) {
            // handle error
            console.error('Error fetching locations:', error);
        }
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'view'
            }
        });
    }
}
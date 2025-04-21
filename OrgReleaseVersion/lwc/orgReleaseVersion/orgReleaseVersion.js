import { LightningElement } from 'lwc';
import GetOrgHostname from '@salesforce/apex/lwc_InvocableHelperMethods.GetOrgHostname';

export default class OrgReleaseVersion extends LightningElement {
    //Stores the most recent array element from the callout response, which will include version information
    apiResponse;

    //Helper function that makes the callout to the org services using Fetch()
    async fetchOrgVersion() {
        //Use invocable apex class to get the host name for the org, then use that to build the API url endpoint
        let hostName = await GetOrgHostname();
        let url = "https://" + hostName + "/services/data/";
        //Make fetch callout and parse using await statements
        const response = await fetch(url);
        const jsonResponse = await response.json();
        //API returns a list of all versions applied to the org; grab the last element, 
        //which will always be the most recent-applied relese and set to propoerty
        this.apiResponse = jsonResponse.at(-1);
    }
}
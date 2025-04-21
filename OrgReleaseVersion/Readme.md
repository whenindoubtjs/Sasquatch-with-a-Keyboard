### OrgReleaseVersion - LWC Component
#### Overview
Ever get the hankering to know what release version (eg, Spring ‘25) your org is on demand? No…? Well, here's a lightweight lwc component anyways, in case you ever want to.
#### Contents
- Apex
  - lwc_InvocableHelperMethods.cls: Contains the shared GetOrgHostname() method to fetch the org host name. Used by lwc to create the dynamic url string
- Lightning Web Component
  - orgReleaseVersion: Html, JavaScript and target-exposed xml for the embeddable widget
#### Referenced Blog Post
Create an embeddable widget to show an Org's release version (https://open.substack.com/pub/ilyapinchuk/p/create-an-embeddable-widget-to-show)

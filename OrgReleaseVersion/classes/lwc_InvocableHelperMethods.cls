//Description:
//  This class contains various methods exposed for use by various Lightning Web Components in a single
//  easy-to-find class
//
//Usage:
//  Import and call any of these methods in an lwc
public with sharing class lwc_InvocableHelperMethods { 
    //Fetches the host name of the current organization
    @AuraEnabled(cacheable=true)
    public static string GetOrgHostname(){
        return DomainCreator.getOrgMyDomainHostname();
    }
}
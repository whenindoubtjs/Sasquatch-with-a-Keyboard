//Description:
//  Functional class for the Stock Decoder app. Contains the primary logic for executing an OpenAI-powered decode process on a 
//  free-form legacy text data field (Legacy_Data__c) on the custom Stock object (Stock__c)
//
//Usage:
//  This class can either be used with the InvocableStockDecoder class as the trigger (from a flow), or invoked directly in Apex via:
//      List<String> listOfIds = currentRequest.inputListOfIds;
//      oAI_StockDecoder sd = new oAI_StockDecoder();
//      sd.RunStockDecoder(listOfIds);

public with sharing class oAI_StockDecoder {
    //OpenAI Parameters specific to the functional class
    String developerPrompt = 'You decode prompts for stock information. Your goal is to find the stock ticker symbol, company name, how many shares where purchased and the purchase date from the entered prompt. Format the date as yyyy-MM-dd. If you are unable to find a value, leave that property blank and set the "Unable to Match" property in the JSON response below to true. Return a plaintext JSON object of the following structure: {"Ticker Symbol": "value","Company Name": "value","Number of Shares": "value","Purchased Date": "value","Unable to Match": "value"}';
    String userPrompt;
    String model = 'gpt-4o-mini';
    Integer temperature = 0;

    //Base constructor
    public oAI_StockDecoder(){}
    
    //Primary method: Takes passed list of Stock recordIds and iterates over each one, making a callout to OpenAI, parsring the response and normalizing the data
    public void RunStockDecoder(List<String> listOfSfIds) {
        //Fetch Stock records and the fields normalized data will be populated to
        List<Stock__c> listOfRecords = [SELECT Legacy_Data__c, Ticker_Symbol__c, Number_of_Shares__c, Company_Name__c, Purchase_Date__c, Unable_to_Match__c FROM Stock__c WHERE id IN :listOfSfIds];
        
        //Create a seperate callout for each record we are normalizing
        for(Stock__c stockRecord : listOfRecords) {
            //Set user prompt from Legacy_Data__c field on the Stock record
            userPrompt = stockRecord.Legacy_Data__c;

            //Init ChatCompletion callout class with final propoerties
            oAI_ChatCompletionCallout oAICallout = new oAI_ChatCompletionCallout(developerPrompt, userPrompt, model, temperature);
            //Make callout to OpenAI via modular class
            String response = oAICallout.MakeOpenAiCallout();
            //Parse the first-order response into a key-value map using JSON class. The parsed response will include all first-order (non-nested) properties
            Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(response);

            //Set the Choices array to a list and parse the first element. This class assume the n-value of choices is set to default value of one
            //meaning there will only be one element in the choice array
            List<Object> choiceList = (List<Object>) parsedResponse.get('choices');
            Map<String, Object> parsedChoice = (Map<String, Object>) choiceList[0];    
            //Parse out the message property of the choice
            Map<String, Object> parsedMessage = (Map<String, Object>) parsedChoice.get('message'); 
            //Parse out the content (the prompt response) of the message property into a map to finally get out key-value pairing
            Map<String, Object> parsedPromptResponse = (Map<String, Object>) JSON.deserializeUntyped((String) parsedMessage.get('content')); 
            
            //Set the decoded values to the record fields
            stockRecord.Ticker_Symbol__c = (String) parsedPromptResponse.get('Ticker Symbol');
            stockRecord.Company_Name__c = (String) parsedPromptResponse.get('Company Name');
            stockRecord.Number_of_Shares__c = Integer.valueOf((String) parsedPromptResponse.get('Number of Shares'));
            stockRecord.Purchase_Date__c = Date.valueOf((String) parsedPromptResponse.get('Purchased Date'));
            if((String)parsedPromptResponse.get('Unable to Match') == 'false') {stockRecord.Unable_to_Match__c = false;} else{ stockRecord.Unable_to_Match__c = true;}
        }  

        //After all records have been updated, commit the changes to database
        database.update(listOfRecords);
    }
}
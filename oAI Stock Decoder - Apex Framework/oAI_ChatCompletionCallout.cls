//Description:
//  This class contains methods and property definitions that handle the setup and callout to OpenAI's ChatCompletion API
//  The class depends on the definitions in oAI_Requests class for a structured definition of the Request Body to be sent
//
//Usage: 
//  From the invoking class, use the constructor to instantiate required properties, then the MakeOpenAiCallout method
//  to fetch the responding JSON body with the following code:
//
//      oAI_ChatCompletionCallout oAICallout = new oAI_ChatCompletionCallout(developerPrompt, userPrompt, model, temperature);
//      Make callout to OpenAI via modular class
//      String response = oAICallout.MakeOpenAiCallout();

public with sharing class oAI_ChatCompletionCallout {
    //OpenAI hard-coded variables; NamedCredentialEndpoint should point to the Named Credential record continaing the connection data to 
    //OpenAI in your org
    String NamedCredentialEndpoint = 'callout:OpenAI_Chat_Completions';
    String httpVerb = 'POST';

    //OpenAI variables set by constructor
    String developerPrompt;
    String userPrompt;
    String model;
    Integer temperature;

    //Base Constructor; used by invoking method to set up basic callout config
    public oAI_ChatCompletionCallout(String iDeveloperPrompt, String iUserPrompt, String iModel, Integer iTemperature ) {
        //Set OpenAI varibales
        developerPrompt = iDeveloperPrompt;
        userPrompt = iUserPrompt;
        model = iModel;
        temperature = iTemperature;
    }

    //Primary method; used by invoking method to set up, make the callout and return the JSON response from OpenAI
    public String MakeOpenAiCallout() {
        //Generate the Request Body using helper methods
        String httpRequestBody = SetRequestBody();

        //Set up the HTTP Callout
        HttpRequest oAICalloutRequest = new HttpRequest();
        oAICalloutRequest.setEndpoint(NamedCredentialEndpoint);
        oAICalloutRequest.setMethod(httpVerb);
        oAICalloutRequest.setBody(httpRequestBody);

        //Make the callout and return the JSON response to the invoking method
        HTTP calloutProxy = new HTTP();
        HttpResponse oAICalloutResponse = calloutProxy.send(oAICalloutRequest);
        system.debug(oAICalloutResponse.getBody());   
        return oAICalloutResponse.getBody();
    }

    //Generates the RequestBody JSON using global params and the SetMessageArray method
    private String SetRequestBody() {
        //Generate MessageArray JSON string based global parameters
        List<Object> messages = SetMessageArray();
        //Set up body
        oAI_Request.RequestBody requestBody = new oAI_Request.RequestBody(model, temperature, messages);
        return JSON.serialize(requestBody);
    }

    //Generates the messages json string for the request body. Invoked from SetRequestMethod
    private List<Object> SetMessageArray(){
        //Init List for storage of Messages
        List<Object> listOfMessages = new List<Object>();
        //Set up Developer Message
        oAI_Request.RequestMessage developerMessage = new oAI_Request.RequestMessage('developer', developerPrompt);
        listOfMessages.add(developerMessage);
        //Set up User Message
        oAI_Request.RequestMessage userMessage = new oAI_Request.RequestMessage('user', userPrompt);
        listOfMessages.add(userMessage);
        //Return list of messages back to calling class
        return listOfMessages;
    }
}
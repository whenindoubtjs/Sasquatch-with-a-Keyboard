//Description
//  This class contains class definitions for various parts of the HTTP POST request body for integrating with OpenAI. It can be extended
//  futher with additional propoerties of the HTTP Request as OpenAI continue to grow and new properties are added/desired for current
//  state functionality of the integration
//Usage
//  The class should be exclusivley called out from the oAI_ChatCompletionCallout class as part of the framework definition
public with sharing class oAI_Request {   
    
    //Top-level body class of the request; stores 1st-order propoerties such as model, temperature, etc
    public class RequestBody {
        //Base constructor to create the class
        public RequestBody(String iModel, Integer iTemp, List<Object> iMessages) {
            model = iModel;
            temperature = iTemp;
            messages = iMessages;
        }

        //Class propoerty accessor methods
        public String model {get;set;}
        public Integer temperature {get;set;}
        public List<Object> messages {get;set;}
    }

    //Second-order Message class for storing multiple messages for prompt generation in the main RequestBody
    public class RequestMessage {  
        //Base constructor to create the class
        public RequestMessage(String iRole, String iContent) {
            role = iRole;
            content = iContent;
        }

        //Class propoerty accessor methods
        public String role {get;set;}
        public String content {get;set;}
    }
}
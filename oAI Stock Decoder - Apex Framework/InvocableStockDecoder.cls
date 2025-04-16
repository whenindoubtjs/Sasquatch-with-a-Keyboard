//This class is used to trigger the oAI_StockDeoder class from a flow, passing to it a list of Salesforce RecordIds fetched from the invoking listview
global with sharing class InvocableStockDecoder {
    @InvocableMethod(label='Process legacy data from selected Stock Records via OpenAI' category='Util')
    global static List<Results> DecodeStockLegacyData(List<Requests> requestList) {
        //Init list of responses for bulkification; this will store our response back to the flow
        List<Results> responseList = new List<Results>();

        //Iterate over each request from the flow interview
        for (Requests currentRequest : requestList) {
            //Grab the list of ids, instantiate our stock decoder class and run the decoder for the set of records
            List<String> listOfIds = currentRequest.inputListOfIds;
            oAI_StockDecoder sd = new oAI_StockDecoder();
            sd.RunStockDecoder(listOfIds);
        }
        //Return the list of responses back to the flow; in this case, this is an empty list, but can be extended to return something
        return responseList;
    }

    //Flow-specific input/output classes to capture and send data from flow to primary invocable method and back
    global class Requests {
        @InvocableVariable(required=true)
        global List<String> inputListOfIds;
    }
      
    global class Results {
        @InvocableVariable
        global String errorMessage;
    }
}
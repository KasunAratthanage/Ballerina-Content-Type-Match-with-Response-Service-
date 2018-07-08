//Scenario - Bank Account Management System (Access Information)

//Import Ballerina http library packages
//Package contains fuctions annotaions and connectores

import ballerina/http;
import ballerina/io;
import ballerina/runtime;

//This service is accessible at port no 9091

//Ballerina client can be used to connect to the created HTTPS listener.
//The client needs to provide values for 'trustStoreFile' and 'trustStorePassword'
endpoint http:SecureListener ep {
    port: 9094	,

    secureSocket: {
        keyStore: {
            path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "${ballerina.home}/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        }
    }
};

map<json> bankDetails;

//authConfiguration comprise Authentication and Authorization
//Authentication can set as 'enable' 
//Authorization based on scpoe
@http:ServiceConfig {
    basePath: "/banktest",
    authConfig: {
        authentication: { enabled: true },
        scopes: ["scope1"]
    }
}

service<http:Service> accountMgt bind ep {
@http:ResourceConfig {
        methods: ["GET"],
        path: "/account",
	authConfig: {
        scopes: ["scope2"]
        }
    }

retriveBankAccountDetails(endpoint client, http:Request req) {
	http:Response response;
        string filePath = "./files/test.xml";	        
    	
	io:ByteChannel byteChannel = io:openFile(filePath, io:READ);

        io:CharacterChannel ch = new io:CharacterChannel(byteChannel, "UTF8");
	
        match ch.readXml() {
            xml result => {
		 
		
		 json j1 = result.toJSON({});
		 
   		 io:println(j1);			
		 response.setJsonPayload(j1);               
       		  _ = client->respond(response);

                io:println(result);
		
            }
            error err => {
		response.statusCode = 404;
		json payload = " XML file cannot read ";
                response.setJsonPayload(payload);  
		
       		 _ = client->respond(response);
		
                throw err;
            }
        }
       		 


}


}

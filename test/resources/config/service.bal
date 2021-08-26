import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/mime;
import ballerina/file;
import ballerina/docker;
import ballerina/grpc;
import ballerinax/kafka;
import ballerina/websocket;

// The `absolute resource path` identifier represents the absolute path to the service.  
service http:Service /foo on new http:Listener(9090) {
    // The `resource path` identifier associates the relative path to the service object's path. E.g., `bar`.
    resource function post bar(http:Caller caller, http:Request req) {
        var payload = req.getJsonPayload();
        http:Response res = new;
        if (payload is json) {
            res.setJsonPayload(<@untainted>payload);
        } else {
            res.statusCode = 500;
            res.setPayload(<@untainted>payload.message());
        }
        var result = caller->respond(res);
        if (result is error) {
            log:printError("Error in responding", err = result);
        }
    }
}

listener http:Listener helloEp = new (9090);

# Description  
service / on helloEp {
    resource function get hi(http:Caller caller, http:Request request) {
        http:Response res = new;
        res.setPayload("Hello World!");
        var result = caller->respond(res);
        if (result is error) {
            log:printError("Error when responding", err = result);
        }
    }
}

http:Client clientEP = check new ("http://localhost:9091/backEndService");
service /actionService on new http:Listener(9090) {

    resource function 'default messageUsage(http:Caller caller, http:Request req) {
        var response = clientEP->get("/greeting");
        var bStream = io:fileReadBlocksAsStream("./files/logo.png");
        if (bStream is stream<byte[], io:Error>) {
            mime:Entity part1 = new;
            part1.setJson({"name": "Jane"});
        } else {
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload(<@untainted>bStream.message());
            var result = caller->respond(res);
        }
    }

    resource function get profile(int id) returns Person|error {
        if (id < people.length()) {
            return people[id];
        } else {
            return error("Person with id " + id.toString() + " not found");
        }
    }
}

public type Person record {
    string name;
    int age;
};
Person p1 = {
    name: "Sherlock Holmes",
    age: 40
};
Person[] people = [p1];
listener file:Listener inFolder = new ({
    path: "/home/ballerina/fs-server-connector/observed-dir",
    recursive: false
});

// The directory listener should have at least one of these predefined resources.
service "localObserver" on inFolder {

    // This resource is invoked once a new file is created in the listening directory.
    remote function onCreate(file:FileEvent m) {
        string|error messageData = string:fromBytes(m.toString().toBytes());
        string msg = "Create: " + m.name;
        log:print(msg);
    }
}

service /stockquote on new http:Listener(8889) {
    // Since the transaction context has been received, this resource will register with the initiator
    // as a participant.
    transactional resource function post update/updateStockQuote(http:Caller conn, http:Request req) {
        json|http:ClientError updateReq = <@untainted>req.getJsonPayload();

        // Generate the response.
        http:Response res = new;
        if (updateReq is json) {
            string msg = io:sprintf("Update stock quote request received. " + "symbol:%s, price:%s", updateReq.symbol, 
            updateReq.price);
            log:print(msg);
            json jsonRes = {"message": "updating stock"};
            res.statusCode = http:STATUS_OK;
            res.setJsonPayload(jsonRes);
        }

        map<any> pathMParams = req.getMatrixParams("/sample/path");
        var a = <string>pathMParams["a"];
        var b = <string>pathMParams["b"];
        string pathMatrixStr = string `a=${a}, b=${b}`;
    }
}

type MapJson map<json>;

@docker:Expose {}
listener http:Listener helloWorldEP = new (9090);

//This sample generates a Docker image as `helloworld:v1.0.0`.
@docker:Config {
    //Docker image name should be helloworld.
    name: "helloworld",
    //Docker image version should be v1.0.
    tag: "v1.0"
}

service http:Service /helloWorld on helloWorldEP {
    resource function get sayHello(http:Caller caller) {
        var responseResult = caller->respond("Hello World from Docker! \n");
        if (responseResult is error) {
            error err = responseResult;
            log:printError("Error sending response", err = err);
        }
    }

    resource function 'default .(http:Caller caller, http:Request request) {
        // [Check if the client expects a 100-continue response](https://ballerina.io/learn/api-docs/ballerina/#/ballerina/http/latest/http/classes/Request#expects100Continue).
        if (request.expects100Continue()) {
            string mediaType = request.getContentType();
            json|error details = request.getJsonPayload();

            if (details is json) {
                json|error name = details.name;
            }
            if (mediaType.toLowerAscii() == "text/plain") {
                var result = caller->continue();
                if (result is error) {
                    log:printError("Error sending response", err = result);
                }
            } else {
                http:Response res = new;
                res.statusCode = 417;
                res.setPayload("Unprocessable Entity");
                var result = caller->respond(res);
                if (result is error) {
                    log:printError("Error sending response", err = result);
                }
                return;
            }
        }
    }
    
    resource function get all(http:Caller caller, http:Request request)
                                                    returns @tainted error? {
        var result = caller->
                        get("/backend/getString", targetType = string);
        if (result is error) {
            log:printError("Error: " + result.message());
            return result;
        }
        log:print("String payload: " + <string> checkpanic result);
        json jsonPayload = <json> check caller->
                                    post("/backend/getJson", "foo", json);
        log:print("Json payload: " + jsonPayload.toJsonString());
        map<json> value = <map<json>> check caller->
                                post("/backend/getJson", "foo", MapJson);
        log:print(check value.id);
        Person person = <Person> check caller->
                            get("/backend/getPerson", targetType = Person);
        log:print("Person name: " + person.name);
        http:Response res =  <http:Response> check caller->
                                            get("/backend/getResponse");
        check caller->respond(<@untainted>res);
    }

}

var helloService = service object {

                               resource function get sayHello(http:Caller caller, http:Request req) {
                                   var respondResult = caller->respond("Hello, World!");
                                   if (respondResult is error) {
                                       log:printError("Error occurred when responding.", err = respondResult);
                                   }
                               }

};

service "HelloWorld" on helloWorldEP {
    remote function lotsOfGreetings(stream<string, grpc:Error?> clientStream) returns string|error {
        log:print("Connected sucessfully.");
        error? e = clientStream.forEach(isolated function(string name) {
                                            log:print("Greet received: " + name);
                                        });
        if (e is grpc:EOS) {
            return "Ack";
        }
        return "";
    }
}

http:Client backendClientEP = check new ("http://localhost:8080", {
            circuitBreaker: {
                rollingWindow: {
                    timeWindowInMillis: 10000,
                    bucketSizeInMillis: 2000,
                    requestVolumeThreshold: 0

                },.
                failureThreshold: 0.2,
                resetTimeInMillis: 10000,
                statusCodes: [400, 404, 500]
            },
            timeoutInMillis: 2000
        }
    );

http:FailoverClient foBackendEP = check new ({

    timeoutInMillis: 5000,
    failoverCodes: [501, 502, 503],
    intervalInMillis: 5000,
    // Define a set of HTTP Clients that are targeted for failover.
    targets: [
            {url: "http://nonexistentEP/mock1"},
            {url: "http://localhost:8080/echo"},
            {url: "http://localhost:8080/mock"}
        ]
});

listener kafka:Listener kafkaListener = new ({bootstrapServers: "localhost:9092"});

service kafka:Service on kafkaListener {
    remote function onConsumerRecord(kafka:Caller caller,
                                kafka:ConsumerRecord[] records) {
        foreach var kafkaRecord in records {
            // processKafkaRecord(kafkaRecord);
        }
        var commitResult = caller->commit();
        if (commitResult is error) {
            log:printError("Error occurred while committing the " +
                "offsets for the consumer ", err = commitResult);
        }
    }
}

int reminderCount = 0;
service object {} appointmentService = service object {
    // This resource is triggered when the appointment is due.
    remote function onTrigger() {
        reminderCount += 1;
        if (reminderCount <= 5) {
            io:println("Schedule is due - Reminder: ", reminderCount);
        }
    }
};

service /basic/ws on new websocket:Listener(9090) {
   resource isolated function get .(http:Request req)
                     returns websocket:Service|websocket:Error {
       return new WsService();
   }
}

service class WsService {
    *websocket:Service;
}


string ageValue = "";
string nameValue = "";
service /chat on new websocket:Listener(9090) {
    resource function get [string name](http:Request req) returns
                         websocket:Service|websocket:UpgradeError {
        // Retrieve query parameters from the [http:Request](https://ballerina.io/learn/api-docs/ballerina/#/ballerina/http/latest/http/classes/Request).
        map<string[]> queryParams = req.getQueryParams();
        if (!queryParams.hasKey("age")) {
            websocket:UpgradeError upgradeErr = error
                                    websocket:UpgradeError("Age is required");
            return upgradeErr;
        } else {
            string? ageQueryParam = req.getQueryParamValue("age");
            ageValue = <@untainted>
                         (ageQueryParam is string ? ageQueryParam : "");
            nameValue = name;
            return service object websocket:Service {
                remote function onOpen(websocket:Caller caller) {
                    string welcomeMsg = "Hi " + nameValue
                           + "! You have successfully connected to the chat";
                    var err = caller->writeTextMessage(welcomeMsg);
                    if (err is websocket:Error) {
                        io:println("Error sending message:" + err.message());
                    }
                    string msg = nameValue + " with age " + ageValue
                            + " connected to chat";
                    caller.setAttribute("name", nameValue);
                    caller.setAttribute("age", ageValue);
                }
                remote function onTextMessage(websocket:Caller caller,
                                          string text) {
                    io:println(text);
                }
            };
        }
    }
}

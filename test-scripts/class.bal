import ballerina/grpc;
import ballerina/tcp;
import ballerina/io;

// Define a class named `Person` 
class Person {
    string fname;
    string lname;
    public Person? parent = ();
    private boolean employed;
    public string email = "default@abc.com";
    // The `init` method should initialize
    function init(string fname, string lname, boolean employed) {
        self.fname = fname;
        self.lname = lname;
        self.employed = employed;
    }

    function getFullName() returns string {
        return self.fname + " " + self.lname;
    }
    // Methods can access all the fields of the class.
    function isEmployed() returns boolean => self.employed;
}

class Employee {
    public string name = "";
    public int age = 0;
    private string email = "default@abc.com";
    string address = "No 20, Palm Grove";

    // Private methods can only be called from within the class;
    private function getDomainName() returns string => "abc.com";

    // Methods can update fields.
    // Module-level visible methods can only be called from within the same module.
    function setEmail(string username) {
        self.email = string `${username}@${self.getDomainName()}`;
    }

    // Public methods can be called from anywhere.
    public function getEmail() returns string => self.email;
}

class Teenager {
    string name;
    int age;

    // An `init` method may return an error.
    function init(string name, int age) returns error? {
        if age > 18 {
            return error(string `${name} is not a teenager!`);
        }
        self.name = name;
        self.age = age;
    }
}

public type ContextString record {|
    string content;
    map<string|string[]> headers;
|};

public client class HelloWorldClient {
    *grpc:AbstractClientEndpoint;
    private grpc:Client grpcClient;

    public isolated function init(string url, grpc:ClientConfiguration? config = ()) returns grpc:Error? {
        // Initialize the client endpoint.
        self.grpcClient = check new (url, config);
        map<string> data = {"user": "Ballerina"};
        check self.grpcClient.initStub(self, "ROOT_DESCRIPTOR", data);
    }

    isolated remote function lotsOfGreetings() returns (LotsOfGreetingsStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("HelloWorld/lotsOfGreetings");
        return new LotsOfGreetingsStreamingClient(sClient);
    }

    isolated remote function helloContext(string|ContextString req)
                                returns (ContextString|grpc:Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC(
                                        "HelloWorld/hello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }
}

public client class LotsOfGreetingsStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendstring(string message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|grpc:Error {
        [anydata, map<string|string[]>] [payload, headers] = check self.sClient->receive();
        return payload.toString();
    }
}

// An `isolated` class.
isolated class UniqueGreetingsStore {
    private string[] uniqueGreetings = [];

    isolated function add(string greeting) {
        lock {
            if self.uniqueGreetings.indexOf(greeting) == () {
                self.uniqueGreetings.push(greeting);
            }
        }
    }

    isolated function remove(string greeting) {
        lock {
            int? index = self.uniqueGreetings.indexOf(greeting);

            if index is int {
                _ = self.uniqueGreetings.remove(index);
            }
        }
    }
}

class IteratorGenerator {
    // The `__iterator()` method should return a new `Iterator<T>`.
    public function __iterator() returns object {
            public function next() returns record {|int value;|}?;} {
        return new ArrayIterator();
    }
}

// An object that is a subtype of `Iterator<int>`.
class ArrayIterator {
    private int[] integers = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34];
    private int cursor = -1;

    // `next` method which generates the sequence of values of type `int`.
    public function next() returns record {|int value;|}? {
        self.cursor += 1;
        if (self.cursor < self.integers.length()) {
            record {|int value;|} nextVal = {value: self.integers[self.cursor]};
            return nextVal;
        }
        return ();
    }
}

readonly class MainController {
    int id;
    string[] codes;

    function init(int id, readonly & string[] codes) {
        self.id = id;
        // The expected type for `codes` is `readonly & string[]`.
        self.codes = codes;
    }

    function getId() returns string {
        return string `Main: ${self.id}`;
    }
}

service class EchoService {
    tcp:Caller caller;

    public function init(tcp:Caller c) {
        self.caller = c;
    }

    // This remote method is invoked once the content is received from the client.
    remote function onBytes(readonly & byte[] data) returns tcp:Error? {
        io:println("Echo: ", string:fromBytes(data));
        // Echo back the data to the same client which the data received from.
        check self.caller->writeBytes(data);
    }

    // This remote method is invoked when the connection is closed.
    remote function onClose() returns tcp:Error? {
        io:println("Client left: ", self.caller.remoteHost, "/",
            self.caller.remotePort);
    }
}

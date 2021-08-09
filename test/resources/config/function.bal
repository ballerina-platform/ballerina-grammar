import ballerina/io;
import ballerina/jballerina.java;
import ballerina/time;
import ballerina/lang.array;
import ballerina/http;
import ballerinax/awslambda;
import ballerinax/azure_functions as af;
import ballerina/cache;
import ballerina/crypto;
import ballerina/random;
import ballerina/file;
import ballerina/sql;
import ballerina/lang.'transaction as transactions;
import ballerina/log;

configurable string hostName = ?;
configurable boolean enableRemote = true;
configurable float maxPayload = 1.0;
const float PI = 3.14159;
const SPEED_OF_LIGHT = 299792000;
const map<string> data = {
    "user": "Ballerina",
    "ID": "1234"
};
const map<map<string>> complexData = {
    "data": data,
    "data2": {"user": "WSO2"}
};
enum Color {
    # This is red color
    RED,
    GREEN,
    BLUE
}
enum Language {
    // An enum member can explicitly specify an associated expression.
    EN = "English",
    TA = "Tamil",
    SI = "Sinhala"
}
public const int COUNT = 1;
const BALLERINA = "Ballerina";

// Define a Ballerina function which will act as a Java field getter.
public function pi() returns float = @java:FieldGet {
    name: "PI",
    'class: "java/lang/Math"
} external;

public function main() {
    float r = 4;
    // If a field is an instance field, the receiver instance has to be provided as the first parameter.
    float l = 2 * pi() * r;
    io:println(l);
    // Defines an anonymous function.
    function (string, string) returns string concat = function(string x, string y) returns string {
                                                          return x + y;
                                                      };
    // Defines an anonymous function with `var`.
    var add = function(int v1, int v2) returns int {
                  return v1 + v2;
              };
    io:println("Concat Result: ", concat("Hello ", "World!"));
    io:println("Add Result: ", add(5, 10));

    record {|
        string city;
        string country;
    |} addr = {city: "London", country: "UK"};

    int[] intArray = [1, 3, 5, 6];
    intArray[999] = 23;
    int[*] g = [1, 2, 3, 4];
    any anyArray = intArray;
    anydata data1 = 5;
    if data1 is int {
        io:println(data1 + 20);
    }
    float[3] scores = [9.8, 9.6, 9.5];
    [float, float, float] [score1, score2, score3] = scores;
    int[] doubled = intArray.map(function(int value) returns int {
                              return value * 2;
                          });
    int[] sortedArray = intArray.sort(array:DESCENDING, isolated function(int value) returns string[] {
                                               if (value < 5) {
                                                   return ["Z", value.toString()];
                                               } else {
                                                   return ["B", value.toString()];
                                               }
                                           });
    io:println(complexData["data"]["user"]);
    future<int> f1 = start calculate("365*24");
    future<int> f2 = @strand {thread: "any"} start multiply(1, 2);
    int hoursInYear = wait f1;
    record { int r1; int r2; } result2 = wait {r1: f1, r2: f1};
    int a = -385;
    int:Unsigned8 b = 128;
    // `int:UnsignedN`
    int:Unsigned8 res1 = a & b;
    io:println("`int` 385 & `int:Unsigned8` 128: ", res1);
    byte byteVal = 12;
    byte[] byteArray1 = [5, 24, 56, 243];
    byte[] byteArray2 = base16 `aeeecdefabcd12345567888822`;
    byte[] byteArray3 = base64 `aGVsbG8gYmFsbGVyaW5hICEhIQ==`;

    map<string> countryCapitals = {
        "USA": "Washington, D.C.",
        "Sri Lanka": "Colombo",
        "England": "London"
    };
    foreach var [country, capital] in countryCapitals.entries() {
        io:println("Country: ", country, ", Capital: ", capital);
    }

    xml books = xml `<books>
                       <book>
                           <name>Sherlock Holmes</name>
                           <author>Sir Arthur Conan Doyle</author>
                       </book>
                       <book>
                           <name>Harry Potter</name>
                           <author>J.K. Rowling</author>
                       </book>
                     </books>`;
    // Iterating an XML will return an individual element in each iteration.
    foreach var book in books/<*> {
        io:println("Book: \t\t\t", book);
    }
    int i = 0;
    while (i <= 10) {
        if (outputs.length() < 3) {
            i += i;
            continue;
        } else {
            break;
        }
    }
    Person|error p1 = new("John");

    log:print("info log", id = 845315,
              name = isolated function() returns string { return "foo";});
    string|int|boolean value = 10;
}

function toFieldsArray(record { } anydataRecord) returns anydata[] {
    anydata[] fields = [];
    foreach var recField in anydataRecord {
        if (recField is ()) {
            io:println("Removed 'foo' directory with all the children.");
        }
        fields.push(recField);
    }
    return fields;
}

class Person {
    string name;
    int age;
    function init(string name) {
        self.name = name;
    }
}

function lookupInfo(string id) returns any {
    if id == "pi" {
        return float:PI;
    } else if id == "date" {
        return time:currentTime().toString();
    } else if id == "bio" {
        return new Person("Jane");
    }
}

function calculate(string expr) returns int {
    http:Client httpClient = checkpanic new ("https://api.mathjs.org");
    string response = <string>checkpanic httpClient->get(string `/v4/?expr=${expr}`, targetType = string);
    return checkpanic int:fromString(<@untainted>response);
}

function multiply(int a, int b, string... args) returns int {
    return a * b;
}

// The `awslambda:Context` object contains request execution
// context information
@awslambda:Function
public function ctxinfo(awslambda:Context ctx, json input) returns json|error {
    json result = {
        RequestID: ctx.getRequestId(),
        DeadlineMS: ctx.getDeadlineMs(),
        InvokedFunctionArn: ctx.getInvokedFunctionArn(),
        TraceID: ctx.getTraceId(),
        RemainingExecTime: ctx.getRemainingExecutionTime()
    };
    json jsonRes2 = {
        "args": {},
        "data": "POST: Hello World",
        "files": {},
        "form": {},
        "json": null,
        "url": "https://postman-echo.com/post"
    };
    json j1 = [1, false, null, "foo", {first: "John", last: "Bob"}];
    return result;
}

// HTTP request to add data to a queue
@af:Function
public function fromHttpToQueue(af:Context ctx, @af:HTTPTrigger {} af:HTTPRequest req, @af:QueueOutput 
                                {queueName: "queue1"} af:StringOutputBinding msg) returns @af:HTTPOutput af:HTTPBinding {
    msg.value = req.body;
    return {
        statusCode: 200,
        payload: "Request: " + req.toString()
    };
}

type Employee record {|
    string name;
    string designation;
|};

type Details record {|
    string name;
    int id;
|};

public function main2() returns @tainted error? {
    string imagePath = "./files/ballerina.jpg";
    boolean isString = imagePath is string;
    byte[] bytes = check io:fileReadBytes(imagePath);
    check io:fileWriteBytes(imagePath, bytes);
    stream<io:Block, io:Error> blockStream = check io:fileReadBlocksAsStream(imagePath, 2048);
    check io:fileWriteBlocksFromStream(imagePath, blockStream);
    string key = "somesecret";
    byte[] keyArr = key.toBytes();
    string[][] csvContent = [["1", "James", "10000"], ["2", "Nathan", "150000"], ["3", "Ronald", "120000"], 
    ["4", "Roy", "6000"], ["5", "Oliver", "1100000"]];
    stream<string[], io:Error> csvStream = check io:fileReadCsvAsStream("/path");
    // Loop through the stream and print the content.
    error? e = csvStream.forEach(function(string[] val) {
                                     io:println(val);
                                 });
    string[][] readCsv = check io:fileReadCsv("csvFilePath1");
    string? input = ();
    string name = input is () ? "John Doe" : input;
    [string|int, float, boolean] t1 = [1, 1.0, false];
    [int, float|string, boolean] t2 = [1, 1.0, false];
    [string, string] v1 = ["Sample String", "Sample String 2"];
    transaction {
        int parsedNum = check parse("12");

        //Parsing a random string will return an error.
        //This error will be caught within the `on-fail` clause.
        int parsedStr = check parse("invalid");

        var res = commit;
    } on fail error er {
        io:println("Error caught during parsing: ", er);
        error invalidAccoundIdError = error("INVALID_ACCOUNT_ID", accountID = 7);
        // Returns the error. The error returned by the `fail` statement should match with the enclosing function's return type.
        rollback;
        fail invalidAccoundIdError;
    }
    function (Person) returns boolean canVote = (p) => p.age >= 18;
    var toEmployee = function(Person p, string pos) returns Employee => {
                         name: p.name,
                         designation: pos
                     };
    string t = "Hello ".concat(name);

    Details & readonly immutableDetails = {
        name: "May",
        id: 112233
    };

    final string[] & readonly codes = ["AB", "CD"];
    map<int> & readonly marks = {
        math: 80,
        physics: 85,
        chemistry: 75
    };
    readonly d = 5;

    map<string|int> m5 = {valueType: "map", constraint: "string"};

    int a = let int b = 1 in b * 2;
    string greeting = let string hello = "Hello ",
                          string ballerina = "Ballerina!"
                      in hello + ballerina;
    int length = let var num = 10, var txt = "four" in num + txt.length();
    int three = let int one = 1, int two = one + one in one + two;
    [int, int] v2 = [10, 20];
    int tupleBindingResult = let [int, int] [d1, d2] = v2,
                                 int d3 = d1 + d2
                             in  d3 * 2;


}

string[] outputs = [];
public function mockPrint(any|error... val) {
    any|error value = val.reduce(getStringValue, "");
    if (value is error) {
        outputs.push(value.message());
    } else {
        outputs.push(value.toString());
    }
    if value is error {
        io:println("Error: ", value.message());
    }

}

function getStringValue(any|error a, any|error b) returns string {
    string aValue = a is error ? a.toString() : a.toString();
    string bValue = b is error ? b.toString() : b.toString();
    return (aValue + bValue);
}

public function main3() returns error? {
    cache:Cache cache = new ({
        capacity: 10,
        evictionFactor: 0.2,
        defaultMaxAgeInSeconds: 2,
        cleanupIntervalInSeconds: 3
    });
    string value = <string>check cache.get("key1");
    string[] keys = cache.keys();
    _ = check cache.invalidate("key2");
    int|error w = parse("12");
    int y = checkpanic parse("120");
    json response1 = {
        name: "San Francisco Test Station,USA",
        longitude: -122.43,
        latitude: 37.76,
        altitude: 150,
        rank: 1
    };
    http:Client httpEndpoint = checkpanic new ("http://localhost:9090");
    http:Request req = new;
    req.setJsonPayload(response1);
    // Send a GET request to the specified endpoint
    var response = httpEndpoint->post("/cbr/route", req);
    if (response is http:Response) {
        var jsonRes = check response.getJsonPayload();
    } 
    json|error nameString = response1;
    http:Response|http:PayloadType|error response2;
    var result = httpEndpoint->respond(<@untainted>response2);

    var insertRecords = [
    {firstName: "Peter", lastName: "Stuart", registrationID: 1,
                                creditLimit: 5000.75, country: "USA"},
    {firstName: "Stephanie", lastName: "Mike", registrationID: 2,
                                creditLimit: 8000.00, country: "USA"},
    {firstName: "Bill", lastName: "John", registrationID: 3,
                                creditLimit: 3000.25, country: "USA"}
    ];
    sql:ParameterizedQuery[] insertQueries =
    from var data in insertRecords
        select  `INSERT INTO Customers
            (firstName, lastName, registrationID, creditLimit, country)
            VALUES (${data.firstName}, ${data.lastName},
            ${data.registrationID}, ${data.creditLimit}, ${data.country})`;

    retry (3) {
        io:println("Attempting execution...");
        // Calls a function, which simulates an error scenario to 
        // trigger the retry operation.
        check main2();
    }

    int i = 0;
    // You can pass a retry manager class as a type parameter.
    retry<Person>(2) {
       io:println("Attempting execution...");
       i += 1;
       if(i < 2) {
           fail error("Custom Error");
       }
       io:println("Work completed.");
    }

    foreach int j in 25 ..< 28 {
        io:println(j);
    }

    [string, int, string] [name, age, address] =
                       ["Jack Smith", 23, "380 Lakewood Dr. Desoto, TX 75115"];
    [string, [float, float, float]][eventId, [score1, score2, score3]] =
                                                     ["E335", [9.8, 9.6, 9.5]];
    [string, int]|[boolean, int]|[int, boolean]|int|float b1 = ["Hello", 45];
}

function parse(string num) returns int|error {
    return 'int:fromString(num);
}

int moduleA = 5;
// A basic example in which an anonymous function with an `if` block accesses its outer scope
// variables.
function basicClosure() returns (function (int) returns int) {
    int a = 3;
    var foo = function(int b) returns int {
                  int c = 34;
                  if (b == 3) {
                      c = c + b + a + moduleA;
                  }
                  return c + a;
              };
    return foo;
}

// An example function with multiple levels of anonymous functions in which the
// innermost anonymous function has access to all of its outer scope variables.
function multilevelClosure() returns (function (int) returns int) {
    int a = 2;
    var func1 = function(int x) returns int {
                    int b = 23;
                    // The variable `a` defined in the outer scope is modified.
                    // The original value of `a` will be changed to `10`.
                    a = a + 8;
                    var func2 = function(int y) returns int {
                                    int c = 7;
                                    var func3 = function(int z) returns int {
                                                    // The variable `b` defined in the `func1` function is modified.
                                                    // The original value of `b` will be changed to `24`.
                                                    b = b + 1;
                                                    return x + y + z + a + b + c;
                                                };
                                    return func3(8) + y + x;
                                };
                    return func2(4) + x;
                };
    return func1;
}

// An Example to represent how function pointers are passed with closures
// so that the inner scope anonymous function can access the outer scope variables.
function functionPointers(int a) returns (function (int) returns (function (int) returns int)) {
    return function(int b) returns (function (int) returns int) {
               return function(int c) returns int {
                          return a + b + c;
                      };
           };
}

function decodeKeys() returns [crypto:PrivateKey, crypto:PublicKey]|error {
    byte[16] rsaKeyArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    foreach var i in 0 ... 15 {
        rsaKeyArr[i] = <byte>(check random:createIntInRange(0, 255));
    }
    // Obtaining reference to a RSA private key by a key file.
    string keyFile = "../resources/private.key";
    crypto:PrivateKey privateKey = check crypto:decodeRsaPrivateKeyFromKeyFile(keyFile);

    // Obtaining reference to a RSA private key by a encrypted key file.
    string encryptedKeyFile = "../resources/encrypted-private.key";
    privateKey = check crypto:decodeRsaPrivateKeyFromKeyFile(keyFile, "ballerina");

    // Obtaining reference to a RSA public key by a cert file.
    string certFile = "../resources/public.crt";
    crypto:PublicKey publicKey = check crypto:decodeRsaPublicKeyFromCertFile(certFile);
    publicKey = check crypto:decodeRsaPublicKeyFromTrustStore(trustStore, "ballerina");

    file:MetaData[]|error readDirResults = file:readDir("foo");
    return [privateKey, publicKey];
}

transactional function callBusinessService() returns @tainted boolean {
    http:Client participantEP = checkpanic new ("http://localhost:8889/stockquote/" + "update/updateStockQuote");

    // Generate the payload.
    float price = 100.00;
    json bizReq = {symbol: "GOODS", price: price};

    // Send the request to the backend service.
    http:Request req = new;
    req.setJsonPayload(bizReq);
    var result = participantEP->post("", req);
    if (result is http:Response) {
        return result.statusCode == http:STATUS_OK;
    } else {
        return false;
    }
}

type AccountNotFoundError error;
function getAccountBalance(int accountID) returns int {
    do {
         if (accountID > 100) {
            // Throw an error with the `AccountNotFound` 
            AccountNotFoundError accountNotFoundError = error AccountNotFoundError("ACCOUNT_NOT_FOUND", accountID = 
            accountID);
            fail accountNotFoundError;
        }
    //The type of `e` should be the union of the error types that are
    } on fail AccountNotFoundError e {
        io:println("Error caught: ", e.message(), ", Account ID: ", e.detail()["accountID"]);
    }
    return 600;
}

type InvalidIdDetail record {|
    error cause?;
    string id;
|};
type InvalidIdError error<InvalidIdDetail>;
function basicMatch(any|error v) {
    match v {
        [var tVar1, var tVar2] => {
            io:println("Matched a value with a tuple shape");
        }
        { message : var a, fatal : var b } => {
            io:println("Matched a value with a record shape");
        }
        {a: var var1, b: var test} if test is string => {
            io:println("Matched with string typeguard");
        }
        {a: var var1, b: var var2} if (var1 is int && var2 is int) => {
            io:println("Matched with int and int typeguard : ", var1);
        }
        "Mouse" => {
            io:println("Mouse");
        }
        1 => {
            io:println("value is: 1");
        }
        error InvalidIdError(id = var a) => {
            io:println("Matched `InvalidError` id=", a);
        }
        error("Generic Error", message = var a) => {
            io:println("Matched an error value : ", io:sprintf("message: %s", a));
        }
    }
}

function getLargestCountryInContinent(string continent) returns string? {
    match continent {
        "North America" => { return "USA"; }

        // In Ballerina, the `nil` type that is provided as `()` contains a single value named "nil". This is used
        // to represent the absence of any other value. The `nil` value is written as `()`.
        "Antarctica" => { return (); }
    }
    // Not having a return statement at the end is also the same as explicitly returning `()`.
}

function getFields(map<json> rec) returns [string[], string[]] {
    string[] fields = [];
    foreach var recordField in rec {
        fields[fields.length()] = recordField.toString();
    }
    return [rec.keys(), fields];
}

public function main4() {
    http:Client httpClient = checkpanic new ("https://api.mathjs.org");
    fork {
        worker w1 returns int {
            string response = <string>checkpanic httpClient->get("/v4/?expr=2*3", targetType = string);
            return checkpanic int:fromString(response);
        }
        worker w2 returns int {
            string response = <string>checkpanic httpClient->get("/v4/?expr=9*4", targetType = string);
            return checkpanic int:fromString(response);
        }
    }
    
    @strand {thread: "any"}
    worker w3 {
        io:println("Hello, World! #m");
    }

    record { int w1; int w2; } result = wait {w1, w2};
    handle helloString = java:fromString("Hello world");
     var arrayDeque = newArrayDeque();
    boolean|error e = trap offer(arrayDeque, java:createNull());
    io:WritableCSVChannel csvch = check io:openWritableCsvFile("");
    int recIndex = 0;
    int recLen = 0;
    while (recIndex < recLen) {
        [string[], string[]] result1 = getFields(<map<json>>content[recIndex]);
        var [headers, fields] = result1;
        if (recIndex == 0) {
            //We ignore the result as this would mean a `nil` return
            check csvch.write(headers);
        }
        check csvch.write(fields);
        recIndex = recIndex + 1;
    }

     map<int> marks = {sam: 50, jon: 60};

    // Calling the `.entries()` method on a map will return a new map with values
    // containing the key-value pairs as an array of tuples.
    map<int> modifiedMarks = marks.entries().map(function ([string, int] pair)
        returns int {
            var [name, score] = pair;
            io:println(io:sprintf("%s scored: %d", name, score));
            return score + 10;
        }
    );

    map<int> allMarks = {physics: 100, ...modifiedMarks, chemistry: 75};
    xml<never> xmlValue = <xml<never>> 'xml:concat();

    // You can define a mapping value with `never` as its constraint.
    // But you can never add members to this map.
    map<never> someMap = {};

    // You can specify a key-less table with the `never` type as the key constraint.
    table<Details> key<never> detailTable = table [
        {name: "John", id: 23},
        {name: "Paul", id: 25}
    ];

    Details d1 = { name: "Martin", id: 1990 };
    Details d2 = { name: "Michelle", id: 2001};
    Details[] detailList = [d1, d2];

    any[] reportList = from var detail in detailList
       where detail.id >= 2.0
       let string degreeName = "Bachelor of Medicine",
       int graduationYear = 1990
       order by detail.name descending
       limit 2
       select {
              name: detail.name,
              degree: degreeName,
              graduationYear: graduationYear
       };

    error onConflictError = error("Key Conflict",
                                  message = "cannot insert report");
     any|error d3 =
        table key(id) from var detail in detailList
        select {
            id: detail.id
        }
        on conflict onConflictError;
}

function process(function (int, int) returns int func, int v1, int v2) returns int {
    return func(v1, v2);
}

# Description
#
# + name - Parameter Description  
# + age - Parameter Description  
# + modules - Parameter Description  
function printDetails(string name, int age = 18, string... modules) {
    int index = 0;
    string moduleString = "Module(s): " + ", ".'join(...modules);
    int i = age;
    while (i < 6) {
        i = i + 1;
        if (i == 5) {
            break;
        }
        if (i == 0) {
            continue;
        }
    }
}

// This function inserts the element `e` at the end of the queue referred by the parameter `receiver`.
function offer(handle receiver, handle e) returns boolean = @java:Method {
    'class: "java.util.ArrayDeque"
} external;

// Here `newArrayDeque` function is linked with the default constructor of the `java.util.ArrayDeque` class.
function newArrayDeque() returns handle = @java:Constructor {
    'class: "java.util.ArrayDeque"
} external;

type Coordinates record {|
    decimal latitude;
    decimal longitude;
|};

isolated map<Coordinates> cities = {};

isolated function formatCoordinates(map<Coordinates> cities) returns string[] {
    string[] formattedCoordinates = [];
    foreach [string, Coordinates] [city, coords] in cities.entries() {
        formattedCoordinates.push(
            string `${city} - ${coords.latitude}° N, ${coords.longitude}° E`);
    }
    return formattedCoordinates;
}

isolated function onRollbackFunc(transactions:Info info, error? cause,
                        boolean willRetry) {
    io:println("Rollback handler #1 executed.");
}

function erroneousOperation() returns error? {
    io:println("Invoke local participant function.");
    return error("Simulated Failure");
}

function readRecord(Details? value) {
    if (value is Details) {
        io:println("Record ID: ", value.id, ", value: ", value.name);
    } else {
        panic error("Record is nil");
    }
}

function fetch(string a, string b) returns string|error {
    worker A returns string|error {
        return a;
    }

    worker B returns string|error {
        return b;
    }

    return wait A|B;
}

function getXsl() returns xml {
    return xml
        `<xsl:stylesheet version="1.0" 
                         xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
            <xsl:template match="/">
                <html>
                    <body>
                        <h2>All time favourites</h2>
                        <table border="1">
                            <tr bgcolor="#9acd33">
                                <th>Title</th>
                                <th>Artist</th>
                            </tr>
                        <xsl:for-each select="samples/song">
                            <tr>
                                <td>
                                    <xsl:value-of select="title"/>
                                </td>
                                <td>
                                    <xsl:value-of select="artist"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                        </table>
                    </body>
                </html>
            </xsl:template>
        </xsl:stylesheet>`;
}

final string[] & readonly prefixes = ["hello", "greetings", "hello world"];
xml x1 = xml `<book>
                <name>Sherlock Holmes</name>
                <author>Sir Arthur Conan Doyle</author>
                <!--Price: $10-->
              </book>`;
xml x4 = xml `<?target data?>`;
xml x6 = xml `<book>The Lost World -2</book>` + 
    xml `Hello, world!` + 
    xml `<!--I am a comment-->` + 
    xml `<?target data?>`;
xml bookXML = xml `<book>
                <name>Sherlock Holmes</name>
                <author>
                    <fname title="Sir">Arthur</fname>
                    <mname>Conan</mname>
                    <lname>Doyle</lname>
                </author>
                <bar:year xmlns:bar="http://ballerina.com/a">2019</bar:year>
                <!--Price: $10-->
                </book>`;
 xmlns "http://ballerina.com/a" as bar;

 xml:Element x1 =
            <xml:Element> xml `<ns0:book ns0:status="available" count="5"/>`;
xml:Element book = <xml:Element> xml `<book/>`;

public type Person record {
    # This is name
    string name;
    # This is age
    int age;
    // This is an anonymous record type descriptor.
    record {|
        string city;
        string country;
    |} address;
};

# The `DummyObject` is a user-defined object.
#
# + fieldOne - This is the description of the `DummyObject`'s `fieldOne` field.
# + fieldTwo - This is the description of the `DummyObject`'s `fieldTwo` field.
public type DummyObject object {
    # This is fieldOne
    public string fieldOne;
    public string fieldTwo;

    // This is the documentation attachment of the `doThatOnObject` function.
    # The `doThatOnObject` function is attached to the `DummyObject` object.
    #
    # + paramOne - This is the description of the parameter of
    #              the `doThatOnObject` function.
    # + return - This is the description of the return value of
    #            the `doThatOnObject` function.
    public function doThatOnObject(string paramOne) returns boolean;
};

public type Employee record {
    string name;
    readonly int age;
    boolean married;
    float salary;
};

public function main() {
    Employee employee = {
        name: "Alex",
        age: 24,
        married: false,
        salary: 8000.0
    };

    Address1 adr = object {
                    public string city;
                    public string country;

                    public function init() {
                        self.city = "London";
                        self.country = "UK";
                    }

                    public function value() returns string {
                        return self.city + ", " + self.country;
                    }

                    function getCity() returns string => string `Default: ${self.city}`;
                };

    Employee empOne = {
        name: "IT",
        age: 10,
        married: false,
        salary: 0.0
    };  
    record {
        string name;
        int age;
    } anyEmployee = empOne;

    EmployeeTable employeeTab = table [
      {age: 1, name: "John", salary: 300.50, married: false},
      {age: 2, name: "Bella", salary: 500.50, married: false}
    ];
}
public const string LKA = "LKA";
public const string LK = "LK";
public const string USA = "USA";
public type CountryCode LK|LKA|USA;

// The `Address` record type is deprecated, but does not have the `# # Deprecated` documentation.
@deprecated
public type Address record {|
    string street;
    string city;
    CountryCode countryCode;
|};

public type Address1 object {
    public string city;
    public string country;

    public function value() returns string;
};

type SampleErrorData record {
    string message?;
    error cause?;
    string info;
    boolean fatal;
};

type SampleError error<SampleErrorData>;

type Grades record {|
    never math?;
    never physics?;
    int...;
|};

object {
    public function __iterator() returns
        object {
            public function next() returns record {|int value;|}?;
        };
} iterableObj = 25 ..< 28;

type Identifier record {|
   readonly int id;
   readonly string[] codes;
|};

type Manager record {|
    Employee[] team?;
    // Includes the `Employee` record.
    *Employee;
    int...;
|};

type EmployeeTable table<Employee> key(age);
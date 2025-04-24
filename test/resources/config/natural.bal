import ballerina/log;
import ballerina/np;

type Person record {|
    string firstName;
    string lastName;
    int yearOfBirth;
    string sport;
|};

public function main() returns error? {
    do {
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}

function getPopularSportsPerson(int year, string nameSegment, np:ModelProvider model) returns Person|error => 
    natural(model) {
        Who is apopular atheleteborn in the decade startingfrom  ${year} with
        ${nameSegment} in theirname?
    }; 

int a = 1;
int b = 2;

int x = natural (a, b, a + b) {
    Test possibilities
    a: ${a}
    a and b: ${a} ${b}
    sum: ${sum(a, b)}
};

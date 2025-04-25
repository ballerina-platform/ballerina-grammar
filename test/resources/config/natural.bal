import ballerina/log;
import ballerina/np;

type Person record {|
    string firstName;
    string lastName;
    int yearOfBirth;
    string sport;
|};

function getPopularSportsPerson(int year, string nameSegment, np:ModelProvider model) returns Person|error => 
    natural(model) {
        Who is a popular sportsperson born in the decade starting from  ${year} with
        ${nameSegment} in their name?
    }; 

int a = 1;
int b = 2;
int x = check natural { Give me a random number between ${startN} and ${endN} }
int x = natural (a, b, a + b) {
    Test possibilities
    a: ${a}
    a and b: ${a} ${b}
    sum: ${sum(a, b)}
};

function sum(int x, int y) returns int => x + y;

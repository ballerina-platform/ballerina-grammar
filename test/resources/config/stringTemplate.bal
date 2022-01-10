const int i = 1;
final string message = string`foo bar: ${i}`;

var obj = {
    // rendering of the string template should be the same as 
    // for 'final string message' above
    message: string`foo bar with ${i}`

// this comment should be rendered in green

};

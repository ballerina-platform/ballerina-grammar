
string str = "pattern";
type MyRecord record {
   string myStr = "aaa";
};

MyRecord rA = { myStr: "abc" };
string:RegExp _ = re `(abc)|${str}|[abc-f\d\-]|(?i:abc)|\p{Ll}|${rA.myStr}`;

function name() {

    string pattern = "ABC";
    
    string:RegExp _ = re `abc`;
    string:RegExp _ = re `(abc)`;
    string:RegExp _ = re `[abc]`;

    string:RegExp _ = re `\p{gc=Ll}|\P{Lm}|\p{sc=Latin}`;
    string:RegExp _ = re `\u{12FFFF}`;

    string:RegExp _ = re `${pattern}`;
    string:RegExp _ = re `\w\s\n`;

    string:RegExp _ = re `(?-:abc)`;
    string:RegExp _ = re `(?i-:abc)`;
    string:RegExp _ = re `(?im-sx:abc)`;

    string:RegExp _ = re `(abc)|${pattern}|[abc]|(?i:abc)`;
    string:RegExp _ = re `[((abc))))\]]`;

    string:RegExp _ = re `[abc\w\p{Ll}\u{FF}]`;
    string:RegExp _ = re `[a-z\w]`;

    string:RegExp _ = re `${myFunction()}`;
}

function myFunction() retunrns string {
    return "abc";
}

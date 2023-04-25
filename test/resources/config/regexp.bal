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

}

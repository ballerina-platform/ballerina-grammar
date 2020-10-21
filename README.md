# ballerina-grammar

This repository contains the `.tmlanguage` file describbing the ballerina language grammar. Currently its consumed by the ballerina [vscode plugin](https://github.com/ballerina-platform/plugin-vscode) to provide syntax highlighting for ballerina.

# Contributing

As `.tmLanguage` files which are of `plist` format are rather hard to read to the human eye `ballerina.tmLanguage` file is generated from the `ballerina.YAML-tmLaguage` YAML file.

Any modifications by hand should be done only to this YAML file.

To generate the tmLanguage file,

~~~
npm install
npm run build
~~~

**Generate language files via the scripts**

* ballerina.YAML-tmLanguage
    - Run `node extract-keywords.js [path to ballerina-lang/compiler/ballerina-parser/src/main/java/io/ballerina/compiler/internal/parser/LexerTerminals.java]`
    - Update ballerina.YAML-tmLanguage file with changes

* ballerina.tmLanguage
    - Run `node build-tm.js`

* ballerina.monarch.json
    - Run `node build-monarch.js`

* prism-ballerina.js
    - Run `cd prism && node extract-keywords.js [path to ballerina-lang/compiler/ballerina-parser/src/main/java/io/ballerina/compiler/internal/parser/LexerTerminals.java]`

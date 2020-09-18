var fs = require('fs');
const yaml = require('js-yaml');

function yamlValue(array) {
    return '\b(' + array.join('|') + ')\b';
}

function yaml2Array(value) {
    return value.replace('\\b(',"").replace(')\\b','').split("|")
}

const chunk = (arr, size) =>
  Array.from({ length: Math.ceil(arr.length / size) }, (v, i) =>
    arr.slice(i * size, i * size + size)
);

let ballerinaYAML = yaml.safeLoad(fs.readFileSync("syntaxes/ballerina.YAML-tmLanguage").toString());

const control = yaml2Array(ballerinaYAML.repository.keywords.patterns[0].match); 

let types = [];
ballerinaYAML.repository.types.patterns.forEach((typeList)=>{
    types = types.concat(yaml2Array(typeList.match));
});
console.log(types);


fs.readFile(process.argv[2], 'utf8', function (err, data) {
    if (err) {
        return console.log(err);
    }
    const regex = /=.*".*"/gm;
    let config = {
        "keywords": {
            "patterns": [
                {
                    "name": "keyword.control.ballerina",
                    "match": yamlValue(control)
                }
            ]
        }
    }
    let m;
    let keys = [];
    while ((m = regex.exec(data)) !== null) {
        keys.push(m[0]);
    }
    keys = keys.map((item) => {
        return item.replace("= \"", "").replace("\"", "");
    })
    keys = keys.filter((item) => {
        return !control.includes(item);
    })
    keys = keys.filter((item) => {
        return !types.includes(item);
    })
    chunk(keys, 15).forEach((group)=>{
        config.keywords.patterns.push({
            "name": "keyword.other.ballerina",
            "match": yamlValue(group)
        });
    });
    console.log(yaml.safeDump(config));
});

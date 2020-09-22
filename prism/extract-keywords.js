var fs = require('fs');

const chunk = (arr, size) =>
  Array.from({ length: Math.ceil(arr.length / size) }, (v, i) =>
    arr.slice(i * size, i * size + size)
);

fs.readFile(process.argv[2], 'utf8', function (err, data) {
    if (err) {
        return console.log(err);
    }
    const regex = /=.*".*"/gm;

    let m;
    let keywords = [];
    while ((m = regex.exec(data)) !== null) {
        keywords.push(m[0]);
    }
    keywords = keywords.map((item) => {
        return item.replace("= \"", "").replace("\"", "");
    })

    console.log(keywords);

    fs.readFile('./prism-ballerina.js', 'utf8', function (err, data) {
        if (err) {
            return console.log(err);
        }
        var keyword_groups = [];
        chunk(keywords,15).forEach((group)=>{
            keyword_groups.push("'" + group.join("|") + "'");
        });
        var str = "'keyword': (new RegExp(\n\t\t" + "'\\\\b(?:' +\n\t\t"  + keyword_groups.join(" +\n\t\t") + " +\n\t\t')\\\\b'\n\t))";

        var result = data.replace(/'keyword': \(new RegExp\((.|\n)*\)\)/g, str);


        fs.writeFile('./prism-ballerina.js', result, 'utf8', function (err) {
            if (err) return console.log(err);
        });
        console.log("Keywords saved to: prism-ballerina.js");

    });
});

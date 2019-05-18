/**
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the 'License'); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const inFile = path.join(__dirname, 'syntaxes', 'ballerina.YAML-tmLanguage');
const outFile = path.join(__dirname, 'syntaxes', 'ballerina.monarch.json');

const inText = fs.readFileSync(inFile, 'utf-8');

grammar = yaml.safeLoad(inText);

const variables = Object.assign({}, grammar.monarchVariables, grammar.variables);

Object.keys(variables).forEach(name => {
    setVariable(grammar, {name, value: variables[name]});
});

delete grammar.variables;
delete grammar.tmlVariables;
delete grammar.monarchVariables;


// We can't convert the keywords highlighting from the yaml file due to what seems
// to be a bug in monaco. Its reported here. https://github.com/Microsoft/monaco-editor/issues/890
// For now keywords entry is manually added.
const exceptions = [];
const patterns = grammar.patterns;
const monarch = {};
convert(grammar, grammar.patterns, monarch, 'root');

// Following is manually adding keywords
monarch.code.push(['[a-z][\\w$]*', 'identifier']);

fs.writeFileSync(outFile, JSON.stringify(monarch, null, 4));

function setVariable(grammar, variable) {
    const rules = Object.keys(grammar.repository);
    rules.forEach(rule => {
        replace(grammar.repository[rule], variable);
    });
}

function replace(rule, variable) {
    const properties = Object.keys(rule);
    properties.forEach(prop => {
        if (typeof rule[prop] === 'string') {
            const newR = rule[prop].replace(new RegExp(`{{${variable.name}}}`, "gim"), variable.value);
            rule[prop] = newR;
        } 

        if (typeof rule[prop] === 'object') {
            replace(rule[prop], variable);
        }
    });
}

function convert(grammar, patterns, monarch, targetKey) {
    if (monarch[targetKey]) {
        return;
    }
    let beginRuleCount = 0;
    
    monarch[targetKey] = [];

    patterns.forEach(pattern => {
        if (pattern.include) {
            let { include } = pattern;

            if (pattern.include.startsWith('#')) {
                include = include.replace('#', '');
            }
            if (exceptions.includes(include)) {
                return;
            }

            const subrule = grammar.repository[include];
            if (!subrule) {
                console.log(`${include} is not found`);
            }

            monarch[targetKey].push({include});
            convert(grammar, subrule.patterns, monarch, include, targetKey);
            return;
        }

        if (pattern.begin) {
            let ruleName = targetKey + '__b__' + beginRuleCount;
            beginRuleCount++;

            if (pattern.beginCaptures) {
                ruleObj = convertCaptures(pattern.beginCaptures, monarch[targetKey], pattern.begin, ruleName);
            } else {
                let ruleObj = {
                    next: ruleName,
                    token: ''
                };
                monarch[targetKey].push([pattern.begin, ruleObj]);
            }

            if (pattern.patterns) {
                convert(grammar, pattern.patterns, monarch, ruleName);
            } else if (pattern.name) {
                monarch[ruleName] = [['.', pattern.name]];
            } else {
                monarch[ruleName] = [];
            }

            if (pattern.end) {
                if (pattern.endCaptures) {
                    convertCaptures(pattern.endCaptures, monarch[ruleName], pattern.end, '@pop');
                } else {
                    monarch[ruleName].unshift([pattern.end, {
                        next: '@pop',
                        token: ''
                    }]);
                }
            }
            return;
        }

        if (pattern.match) {
            let token = pattern.name;

            if (pattern.captures) {
                token = Object.keys(pattern.captures).map((key) => (pattern.captures[key].name));
            }

            monarch[targetKey].push([pattern.match, token]);
            return;
        }
    });
}

function convertCaptures(captures, target, pattern, next) {
    if (captures['0']) {
        target.unshift([pattern, {
            next,
            token: captures[0].name
        }]);
        return;
    }

    if (captures['1']) {
        const subRegexes = splitToGroups(pattern);
        if (subRegexes.length > 1) {
            subRegexes.forEach((subRegex, i) => {
                const ruleObj = {
                    next,
                    token: (captures[i+1] && captures[i+1].name) || ''
                }
                target.unshift([subRegexes[i], ruleObj]);
            });

            return;
        }

        const ruleObj = [
            {
                next,
                token: captures['1'].name
            }
        ];
        Object.keys(captures).map(cap => {
            if (cap === '1') {
                return;
            }
            ruleObj.push(captures[cap].name);
        });
        target.unshift([subRegexes[0], ruleObj]);
    }
}

// splits a regex joined by | into its sub groups
function splitToGroups(regex) {
    if (regex.indexOf(')|(') < 0) {
        return [regex];
    }

    let openCount = 0;
    let closeCount = 0;
    const groups = [];
    let start = 0;
    const charArr = [...regex];
    charArr.forEach((char, i) => {
        if (char === '(') {
            openCount++;
            return;
        } 
        
        if (char === ')') {
            closeCount++;
            return;
        } 
        
        if (char === '|') {
            if ((charArr[i+1] === '(') && (charArr[i-1] === ')') && (openCount === closeCount)) {
                groups.push(regex.substring(start, i));
                start = i+1;
            }
        }
    })
    groups.push(regex.substring(start));
    return groups;
}
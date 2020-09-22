Prism.languages.ballerina = {
    'comment': /\/\/[^\r\n]*/,
    'string': {
        pattern: /"(?:[^\\"]|\\.)*(?:"|$)/,
        greedy: true,
    },
    'boolean': /\b(?:true|false)\b/,
    'keyword': (new RegExp(
		'\\b(?:' +
		'public|private|function|return|returns|external|type|record|object|remote|abstract|client|if|else|while' +
		'panic|true|false|check|fail|checkpanic|continue|break|import|version|as|on|resource|listener|const' +
		'final|typeof|is|null|lock|annotation|source|worker|parameter|field|isolated|xmlns|fork|trap|in' +
		'foreach|table|key|error|let|stream|new|readonly|distinct|from|where|select|start|flush|default' +
		'wait|do|transaction|transactional|commit|retry|rollback|enum|base16|base64|match|conflict|limit|join|outer' +
		'equals|order|by|ascending|descending|class|variable|module|int|float|string|boolean|decimal|xml|json' +
		'handle|any|anydata|service|var|never|map|future|typedesc|byte' +
		')\\b'
	)),
    'operator': /(?:!|%|\+|\-|~|=|=|!|<|>|&|\|)/,
    'number': /\b0[xX][\da-f]+\b|\b\d+\.?\d*/
};

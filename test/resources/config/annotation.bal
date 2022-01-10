type AnnotationData record {|

|};

annotation AnnotationData MyAnnotation on service, function;

public const annotation record {
    string label;
    string iconPath?;
} display on  source type, source class, source function, source return, source var;

type Data record {

};

const annotation Data MyAnnot on source worker, source var, field;

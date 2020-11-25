#!/usr/bin/gawk -f


## For updates see -> https://github.com/awk-utilities/includes-argument-parser
@include "argument-parser"


BEGIN {
    delete parsed_arguments
    delete acceptable_arguments

    acceptable_arguments["string"] = "--string|-s:value"
    acceptable_arguments["boolean"] = "--boolean|-B:bool"
    acceptable_arguments["usage"] = "--usage:bool"
    acceptable_arguments["increment"] = "--increment|-I:increment"
    acceptable_arguments["array"] = "--array:array"

    argument_parser(acceptable_arguments, parsed_arguments)
    for (k in parsed_arguments) {
        if (k == "array") {
            for (i in parsed_arguments[k]) {
                print "parsed_arguments[\"" k "\"][" i "] ->", parsed_arguments[k][i]
            }
        } else {
            print "parsed_arguments[\"" k "\"] ->", parsed_arguments[k]
        }
    }
}


#!/usr/bin/gawk -f


##
# Assigns parsed reference from ARGC matched from acceptable arguments reference
# @note - Dunder variables are function scoped, and should **not** be assigned by caller
# @note - Use `gawk -h` to list parameters that parser may conflict with argument parsing
# @parameter {ArrayReference} _acceptable_arguments - Array reference of acceptable arguments
# @parameter {ArrayReference} _parsed_arguments     - Array reference that parsed arguments should be saved to
# @parameter {string}         __key__               - Associative array key that points to `_acceptable_arguments[__key__]` value
# @parameter {string[]}       __acceptable_parts__  - Array split by `:` from `_acceptable_arguments[__key__]` value
# @parameter {string}         __pattern__           - Regexp pattern from `_acceptable_arguments[__key__]` value
# @parameter {string}         __type__              - Default `"value"` from `_acceptable_arguments[__key__]` value
# @parameter {number}         __index__             - Index that points to value within `ARGC`
# @parameter {string[]}       __argument_parts__    - Array split by `=` from `ARGC[__index__]` value
# @parameter {string}         __parameter__         - Value from `__acceptable_parts__[1]`
# @author S0AndS0
# @license AGPL-3.0
# @example
#   #!/usr/bin/gawk -f
#
#
#   @include "argument-parser"
#
#
#   BEGIN {
#     delete parsed_arguments
#     delete acceptable_arguments
#
#     acceptable_arguments["usage"] = "--usage:boolean"
#     acceptable_arguments["key"] = "--key|-k:value"
#     acceptable_arguments["increment"] = "-I:increment"
#
#     parse_script_arguments(acceptable_arguments, parsed_arguments)
#
#     for (k in parsed_arguments) {
#       print "parsed_arguments[\"" k "\"] ->", parsed_arguments[k]
#     }
#   }
function argument_parser(_acceptable_arguments, _parsed_arguments,
                         __key__, __acceptable_parts__, __pattern__, __type__,
                         __index__, __argument_parts__, __parameter__)
{
    for (__index__ = 1; __index__ < ARGC; __index__++) {
        for (__key__ in _acceptable_arguments) {
            split(_acceptable_arguments[__key__], __acceptable_parts__, ":")
            __pattern__ = __acceptable_parts__[1]
            __type__ = __acceptable_parts__[2]

            if (ARGV[__index__] ~ "^(" __pattern__ ")=.*$") {
                split(ARGV[__index__], __argument_parts__, "=")
                __parameter__ = __argument_parts__[1]
                _parsed_arguments[__key__] = substr(ARGV[__index__], (length(__parameter__) + 2))
                delete ARGV[__index__]
                if (__type__ !~ "^(array|list)") {
                    delete _acceptable_arguments[__key__]
                }
                break
            } else if (ARGV[__index__] ~ "^(" __pattern__ ")$") {
                if (__type__ ~ "^bool") {
                    _parsed_arguments[__key__] = 1
                    delete ARGV[__index__]
                    delete _acceptable_arguments[__key__]
                    break
                } else if (__type__ ~ "^increment") {
                    _parsed_arguments[__key__]++
                    delete ARGV[__index__]
                    break
                } else if (__type__ ~ "^(array|list)") {
                    _parsed_arguments[__key__][(length(_parsed_arguments[__key__]) + 1)] = ARGV[__index__ + 1]
                    delete ARGV[__index__]
                    __index__++
                    delete ARGV[__index__]
                    break
                } else {
                    _parsed_arguments[__key__] = ARGV[__index__ + 1]
                    delete ARGV[__index__]
                    __index__++
                    delete ARGV[__index__]
                    delete _acceptable_arguments[__key__]
                    break
                }
            }
        }
    }
}


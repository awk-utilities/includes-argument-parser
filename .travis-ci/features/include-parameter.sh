#!/usr/bin/env bash


tests__include_parameter() {
    printf 'Started: %s\n' "${FUNCNAME[0]}"
    local _include_path="${1:?No include path provided}"
    local -a _argument_list=( "${@}" )
    local -a _awk_arguments=( "${_argument_list[@]:1}" )

    local _expected_output
    local _script_output
    read -rd '' _expected_output <<'EOF'
parsed_arguments["array"][1] -> one
parsed_arguments["array"][2] -> two
parsed_arguments["boolean"] -> 1
parsed_arguments["increment"] -> 3
parsed_arguments["string"] -> string like value
EOF

    _script_output="$(
        gawk --include="${_include_path}"\
             'BEGIN {
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
              }' "${_awk_arguments[@]}"
    )"

    if [[ "${_script_output}" != "${_expected_output}" ]]; then
        local -a _error_message=(
            "Function: ${FUNCNAME[0]}"
            "Arguments: ${_awk_arguments[*]@Q}"
            'Expected output ___'
            "${_expected_output}"
            '___'
            'Script output ___'
            "${_script_output}"
            '___'
        )
        printf >&2 '  %s\n' "${_error_message[@]}"
        return 1
    fi

    printf 'Finished: %s\n' "${FUNCNAME[0]}"
}


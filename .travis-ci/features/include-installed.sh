#!/usr/bin/env bash


tests__include_installed() {
    printf 'Started: %s\n' "${FUNCNAME[0]}"

    local -a _awk_arguments=( "${@}" )

    ## Find true directory function resides in
    local _source="${BASH_SOURCE[0]}"
    while [[ -h "${_source}" ]]; do
      _source="$(find "${_source}" -type l -ls | sed -n 's@^.* -> \(.*\)@\1@p')"
    done
    local _dir="$(cd -P "$(dirname "${_source}")" && pwd)"

    local _expected_output
    local _script_output
    read -rd '' _expected_output <<'EOF'
parsed_arguments["array"][1] -> one
parsed_arguments["array"][2] -> two
parsed_arguments["boolean"] -> 1
parsed_arguments["increment"] -> 3
parsed_arguments["string"] -> string like value
EOF

    _script_output="$("${_dir}/include-installed.awk" "${_awk_arguments[@]}")"

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


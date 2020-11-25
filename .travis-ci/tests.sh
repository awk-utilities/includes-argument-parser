#!/usr/bin/env bash


## Find true directory script resides in
__SOURCE__="${BASH_SOURCE[0]}"
while [[ -h "${__SOURCE__}" ]]; do
    __SOURCE__="$(find "${__SOURCE__}" -type l -ls | sed -n 's@^.* -> \(.*\)@\1@p')"
done
__DIR__="$(cd -P "$(dirname "${__SOURCE__}")" && pwd)"
__PARENT_DIR__="${__DIR__%/*}"
__NAME__="${__SOURCE__##*/}"
__AUTHOR__='S0AndS0'
__DESCRIPTION__='Tests argument-parser.awk script'


set -eE -o functrace


## Provides -> tests__include_parameter '<include-path>' '<awk-arguments[]?>'
# shellcheck source=.travis-ci/features/include-parameter.sh
source "${__DIR__}/features/include-parameter.sh"

## Provides -> tests__include_installed '<awk-arguments[]?>'
# shellcheck source=.travis-ci/features/include-installed.sh
source "${__DIR__}/features/include-installed.sh"


__license__(){
    _year="$(date +'%Y')"
    cat <<EOF
${__DESCRIPTION__}
Copyright (C) ${_year:-2020} ${__AUTHOR__:-S0AndS0}

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
EOF
}


__usage__() {
    cat <<EOF
${__DESCRIPTION__}


## Parameters


-h       --help     <boolean>

    {Optional} Prints this message and exists


-l       --license  <boolean>

    {Optional} Prints license and exits


## Example


    cd "${__PARENT_DIR__}"
    ./.travis-ci/${__NAME__}
EOF
}


(( ${#@} )) && {
    case "${@}" in
        --help|-h|help)
            __usage__
            _exit_status="$?"
        ;;
        --license|-l|license)
            __license__
            _exit_status="$?"
        ;;
        *)
            __usage__
            _exit_status="1"
        ;;
    esac
    exit "${_exit_status}"
}


##
# parameter
test_function() {
    local _function_name="${1:?No function_name name provided}"
    local -a _argument_list=( "$@" )
    local -a _function_arguments=( "${_argument_list[@]:1}" )
    "${_function_name}" "${_function_arguments[@]}" || {
        local _status="${?}"
        printf 'Failed -> %s\n' "${_function_name}"
    }
    return "${_status:-0}"
}


__AWK_TEST_ARGUMENTS__=(
    --string "string like value"
    --increment
    -I
    -I
    -B
    --array one
    --array two
)

# test_function tests__include_parameter "${__PARENT_DIR__}/argument-parser.awk"
test_function tests__include_parameter "${__PARENT_DIR__}/argument-parser.awk"\
              "${__AWK_TEST_ARGUMENTS__[@]}"


test_function tests__include_installed "${__AWK_TEST_ARGUMENTS__[@]}"


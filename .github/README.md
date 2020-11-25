# Includes Argument Parser
[heading__top]:
  #includes-argument-parser
  "&#x2B06; Including within Awk script adds argument parsing functionality"


Including within Awk script adds argument parsing functionality


## [![Byte size of Includes Argument Parser][badge__main__includes_argument_parser__source_code]][includes_argument_parser__main__source_code] [![Open Issues][badge__issues__includes_argument_parser]][issues__includes_argument_parser] [![Open Pull Requests][badge__pull_requests__includes_argument_parser]][pull_requests__includes_argument_parser] [![Latest commits][badge__commits__includes_argument_parser__main]][commits__includes_argument_parser__main] [![Build Status][badge_travis_ci]][build_travis_ci]


---


- [:arrow_up: Top of Document][heading__top]

- [:building_construction: Requirements][heading__requirements]

- [:zap: Quick Start (Option 1)][heading__quick_start_option_1]

  - [:floppy_disk: Clone][heading__clone]
  - [:heavy_plus_sign: Install][heading__install]
  - [:fire: Uninstall][heading__uninstall]
  - [:arrow_up: Upgrade][heading__upgrade]
  - [:tophat: Write an Awk script][heading__write_an_awk_script]

- [:zap: Quick Start (Option 2)][heading__quick_start_option_2]

  - [:memo: Edit Your ReadMe File][heading__your_readme_file]
  - [:floppy_disk: Commit and Push][heading__commit_and_push]
  - [:shell: Write a Bash wrapper script][heading__write_a_bash_wrapper_script]

- [:symbols: API][heading__api]

- [&#x1F5D2; Notes][heading__notes]

- [:chart_with_upwards_trend: Contributing][heading__contributing]

  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]

- [:card_index: Attribution][heading__attribution]

- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


GAwk should be installed for scripts to make use of this repository...


- Arch based Operating Systems


```Bash
sudo packman -Syy

sudo packman -S gawk make
```


- Debian derived Distributions


```Bash
sudo apt-get update

sudo apt-get install gawk make
```


______


## Quick Start (Option 1)
[heading__quick_start_option_1]:
  #quick-start-option-1
  "&#9889; Perhaps as easy as one, 2.0,..."


> Perhaps as easy as one, 2.0,...


---


### Clone
[heading__clone]:
  #clone
  "&#x1f4be;"


Clone this project to a `root` owned directory...


```Bash
cd /usr/local/etc

sudo git clone https://github.com/awk-utilities/includes-argument-parser.git
```


---


### Install
[heading__install]:
  #install
  "&#x2795;"



Install via `make`...


```Bash
cd /usr/local/etc/includes-argument-parser

sudo make install
```


---


### Uninstall
[heading__uninstall]:
  #uninstall
  "&#x1f525;"


Uninstall/unlink via `make`...


```Bash
cd /usr/local/etc/includes-argument-parser

sudo make uninstall
```


---


### Upgrade
[heading__upgrade]:
  #upgrade
  "&#x2b06;"


Upgrading in the future may be done via _`upgrade`_ Make target...


```Bash
cd /usr/local/etc/includes-argument-parser

sudo make upgrade
```


---


### Write an Awk Script
[heading__write_an_awk_script]:
  #write-an-awk-script
  "&#x1f3a9; Example Awk script utilizing the `@include` keyword"


If this project was installed via _`make`_, then any Awk script should be able to include this project via _`@include "argument-parser"`_ statement, eg...


**`include-installed.awk`**


```Awk
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
```


Provide executable permissions...


```Bash
chmod u+x include-installed.awk
```


Then run the Awk script...


```Bash
./include-installed.awk -t 'string like value' -f --increment -I -I
#> parsed_arguments["flag"] -> 1
#> parsed_arguments["increment"] -> 3
#> parsed_arguments["test"] -> string like value
```


______


## Quick Start (Option 2)
[heading__quick_start_option_2]:
  #quick-start-option-2
  "&#9889; Perhaps as easy as 1.0, two,..."


Alternatively for individual scripts, this repository encourages the use of Git Submodules to track dependencies...


**Bash Variables**


```Bash
_module_name='includes-argument-parser'
_module_https_url="https://github.com/awk-utilities/includes-argument-parser.git"
_module_base_dir='modules'
_module_path="${_module_base_dir}/${_module_name}"
```


**Bash Submodule Commands**


```Bash
cd "<your-git-project-path>"

git checkout gh-pages
mkdir -vp "${_module_base_dir}"

git submodule add\
 -b main --name "${_module_name}"\
 "${_module_https_url}" "${_module_path}"
```


---


### Your ReadMe File
[heading__your_readme_file]:
  #your-readme-file
  "&#x1F4DD; Suggested additions for your ReadMe.md file so everyone has a good time with submodules"


Suggested additions for your _`ReadMe.md`_ file so everyone has a good time with submodules


```MarkDown
Clone with the following to avoid incomplete downloads


    git clone --recurse-submodules <url-for-your-project>


Update/upgrade submodules via


    git submodule update --init --merge --recursive
```


### Commit and Push
[heading__commit_and_push]:
  #commit-and-push
  "&#x1F4BE; It may be just this easy..."


```Bash
git add .gitmodules
git add "${_module_path}"


## Add any changed files too


git commit -F- <<'EOF'
:heavy_plus_sign: Adds `awk-utilities/includes-argument-parser#1` submodule



**Additions**


- `.gitmodules`, tracks submodules AKA Git within Git _fanciness_

- `README.md`, updates installation and updating guidance

- `modules/includes-argument-parser`, Including within Awk script adds argument parsing functionality
EOF


git push origin gh-pages
```


---


### Write a Bash wrapper script
[heading__write_a_bash_wrapper_script]:
  #write-a-bash-wrapper-script
  "&#x1f41a;"


If utilizing this project as a submodule, then it's less error-prone to use _`-i`_, or _`--include`_, option within a _wrapper_ Bash script, eg...


```Bash
#!/usr/bin/env bash


## Find true directory script resides in
__SOURCE__="${BASH_SOURCE[0]}"
while [[ -h "${__SOURCE__}" ]]; do
    __SOURCE__="$(find "${__SOURCE__}" -type l -ls | sed -n 's@^.* -> \(.*\)@\1@p')"
done
__DIR__="$(cd -P "$(dirname "${__SOURCE__}")" && pwd)"

__ARGS__=( "${@}" )


gwak --include="${__DIR__}/modules/includes-argument-parser/argument-parser.awk"\
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
     }' "${__ARGS__[@]}"
```


**:tada: Excellent :tada:** your project is now ready to begin unitizing code from this repository!


______


## API
[heading__api]:
  #api
  "&#x1F523; Parameter documentation"


Types available for `acceptable_arguments`


- `value` default if _type_ is undefined, reads left side of _`=`_ or next _`ARGV`_ as value

- `bool`, or `boolean`, sets _`1`_ for true

- `increment` adds _`1`_ to value of `parsed_arguments` array

- `array`, or `list`, appends read value to array within `parsed_arguments` array


```
_acceptable_arguments {ArrayReference}

  Array reference of acceptable arguments


_parsed_arguments     {ArrayReference}

  Array reference that parsed arguments should be saved to


__key__               {string}

  Associative array key that points to `_acceptable_arguments[__key__]` value


__acceptable_parts__  {string[]}

  Array split by `:` from `_acceptable_arguments[__key__]` value


__pattern__           {string}

  Regexp pattern from `_acceptable_arguments[__key__]` value


__type__              {string}

  Default `"value"` from `_acceptable_arguments[__key__]` value


__index__             {number}

  Index that points to value within `ARGC`


__argument_parts__    {string[]}

  Array split by `=` from `ARGC[__index__]` value


__parameter__         {string}

  Value from `__acceptable_parts__[1]`
```


> **API Notes**
>
> - Dunder variables are function scoped, and should **not** be assigned by caller.
>
> - Use `gawk -h` to list parameters that parser may conflict with.


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


This repository may not be feature complete and/or fully functional, Pull Requests that add features or fix bugs are certainly welcomed.


---


The _`@include`_ option within GAwk scripts uses paths listed within _`AWKPATH`_ environment variable...


```Bash
gawk 'BEGIN { print ENVIRON["AWKPATH"]; }'
#> .:/usr/share/awk
```


... The path list is separated by `:` and generally includes only the current working directory (_`.`_), and _`/usr/share/awk`_ paths. At this time modifying the _`AWKPATH`_ environment variable within an Awk script seems **not** to be possible.


---


As of version `4.1.4` when including files via _`@include`_ within an Awk script from _`/usr/share/awk`_ path, GAwk will **not** explore sub-directories, eg...


**`/usr/share/awk/sub-directory/include-test.awk`**


```Awk
#!/usr/bin/gawk -f

function bad_example() {
  print "You cannot import this!"
}
```


**`./bad-includes.awk`**


```Awk
#!/usr/bin/gawk -f

@include "sub-directory/include-test"

BEGIN {
  bad_example
}
```


**Example of running `bad-includes.awk`**


```Bash
chmod u+x ./bad-includes.awk

./bad-includes.awk
#> gawk: ./bad-includes.awk:3: error: can't open source file `sub-directory/include-test' for reading (No such file or directory)
```


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to includes-argument-parser and awk-utilities"


Options for contributing to includes-argument-parser and awk-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking includes-argument-parser"


Start making a [Fork][includes_argument_parser__fork_it] of this repository to an account that you have write permissions for.


- Add remote for fork URL. The URL syntax is _`git@github.com:<NAME>/<REPO>.git`_...


```Bash
cd ~/git/hub/awk-utilities/includes-argument-parser

git remote add fork git@github.com:<NAME>/includes-argument-parser.git
```


- Commit your changes and push to your fork, eg. to fix an issue...


```Bash
cd ~/git/hub/awk-utilities/includes-argument-parser


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```


> Note, the `-u` option may be used to set `fork` as the default remote, eg. _`git push -u fork main`_ however, this will also default the `fork` remote for pulling from too! Meaning that pulling updates from `origin` must be done explicitly, eg. _`git pull origin main`_


- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_


> Note; to decrease the chances of your Pull Request needing modifications before being accepted, please check the [dot-github](https://github.com/awk-utilities/.github) repository for detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting awk-utilities that maintains includes-argument-parser"


Thanks for even considering it!


Via Liberapay you may <sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a repeating basis.


Regardless of if you're able to financially support projects such as includes-argument-parser that awk-utilities maintains, please consider sharing projects that are useful with others, because one of the goals of maintaining Open Source repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)

- [GNU Awk -- `2.7` -- Including Other Files into Your Program](https://www.gnu.org/software/gawk/manual/html_node/Include-Files.html)

- [GNU Awk -- `2.5.1` -- The `AWKPATH` Environment Variable](https://www.gnu.org/software/gawk/manual/html_node/AWKPATH-Variable.html)

- [StackExchange -- Unix -- Command line argument in Awk](https://unix.stackexchange.com/questions/475008/)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
Including within Awk script adds argument parsing functionality
Copyright (C) 2020 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of [AGPL-3.0][branch__current__license] License.



[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"


[badge__commits__includes_argument_parser__main]:
  https://img.shields.io/github/last-commit/awk-utilities/includes-argument-parser/main.svg

[commits__includes_argument_parser__main]:
  https://github.com/awk-utilities/includes-argument-parser/commits/main
  "&#x1F4DD; History of changes on this branch"


[includes_argument_parser__community]:
  https://github.com/awk-utilities/includes-argument-parser/community
  "&#x1F331; Dedicated to functioning code"


[issues__includes_argument_parser]:
  https://github.com/awk-utilities/includes-argument-parser/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[includes_argument_parser__fork_it]:
  https://github.com/awk-utilities/includes-argument-parser/
  "&#x1F531; Fork it!"

[pull_requests__includes_argument_parser]:
  https://github.com/awk-utilities/includes-argument-parser/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[includes_argument_parser__main__source_code]:
  https://github.com/awk-utilities/includes-argument-parser/
  "&#x2328; Project source!"

[badge__issues__includes_argument_parser]:
  https://img.shields.io/github/issues/awk-utilities/includes-argument-parser.svg

[badge__pull_requests__includes_argument_parser]:
  https://img.shields.io/github/issues-pr/awk-utilities/includes-argument-parser.svg

[badge__main__includes_argument_parser__source_code]:
  https://img.shields.io/github/repo-size/awk-utilities/includes-argument-parser


[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=awk-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/awk-utilities
  "&#x1F4B1; Sponsor developments and projects that awk-utilities maintains via Liberapay"


[badge_travis_ci]:
  https://travis-ci.com/awk-utilities/includes-argument-parser.svg?branch=main

[build_travis_ci]:
  https://travis-ci.com/awk-utilities/includes-argument-parser


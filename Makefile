#
#    Make variables to satisfy conventions
#
NAME = argument-parser
VERSION = 0.0.1
PKG_NAME = $(NAME)-$(VERSION)


# Install/Uninstall make script for awk-utilities/argument-parser
# Copyright (C) 2020 S0AndS0
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


#
#    Lambda-like functions
#
path_last = $(lastword $(subst $(2), , $(1)))
path_append = $(strip $(1))$(__PATH_SEPARATOR__)$(strip $(2))


#
#    Make variables set upon run-time
#
##  Note ':=' is to avoid late binding that '=' entails
## Attempt to detect Operating System
ifeq '$(findstring :,$(PATH))' ';'
	__OS__ := Windows
else
	__OS__ := $(shell uname 2>/dev/null || echo 'Unknown')
	__OS__ := $(patsubst CYGWIN%,Cygwin,$(__OS__))
	__OS__ := $(patsubst MSYS%,MSYS,$(__OS__))
	__OS__ := $(patsubst MINGW%,MSYS,$(__OS__))
endif


ifeq '$(__OS__)' 'Windows'
	__PATH_SEPARATOR__ := \\
else
	__PATH_SEPARATOR__ := /
endif


## Obtain directory path that this Makefile lives in
ROOT_DIRECTORY_PATH := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
ROOT_DIRECTORY_NAME := $(notdir $(patsubst %/,%,$(ROOT_DIRECTORY_PATH)))


#
#    Make variables that readers &/or maintainers may wish to modify
#
SCRIPT_NAME := argument-parser.awk
SCRIPT_TYPE	:= include
AWKPATH := $(shell gawk 'BEGIN {\
	split(ENVIRON["AWKPATH"], AWKPATH_ARRAY, ":");\
	print AWKPATH_ARRAY[length(AWKPATH_ARRAY)];\
}')

AWKLIBPATH := $(shell gawk 'BEGIN {\
	split(ENVIRON["AWKLIBPATH"], AWKLIBPATH_ARRAY, ":");\
	print AWKLIBPATH_ARRAY[length(AWKLIBPATH_ARRAY)];\
}')

ifeq ($(SCRIPT_TYPE), include)
	INSTALL_DIRECTORY := $(AWKPATH)
else ifeq ($(SCRIPT_TYPE), lib)
	INSTALL_DIRECTORY := $(AWKLIBPATH)
else
	INSTALL_DIRECTORY := $(HOME)/bin
endif


#
#    Override variables via optional configuration file
#
CONFIG := $(ROOT_DIRECTORY_PATH)/.make-config
ifneq ("$(wildcard $(CONFIG))", "")
	include $(CONFIG)
endif


INSTALL_PATH := $(call path_append, $(INSTALL_DIRECTORY), $(SCRIPT_NAME))


#
#    Make targets and settings
#
.PHONY: clean git-pull install link-script list uninstall unlink-script
.SILENT: clean config git-pull install link-script list uninstall unlink-script
.ONESHELL: install

clean: SHELL := /bin/bash
clean: ## Removes configuration file
	[[ -f "$(ROOT_DIRECTORY_PATH)/.make-config" ]] && {
		rm -v "$(ROOT_DIRECTORY_PATH)/.make-config"
	}

config: SHELL := /bin/bash
config: ## Writes configuration file
	tee "$(ROOT_DIRECTORY_PATH)/.make-config" 1>/dev/null <<EOF
	SCRIPT_NAME = $(SCRIPT_NAME)
	AWKPATH = $(AWKPATH)
	AWKLIBPATH = $(AWKLIBPATH)
	INSTALL_DIRECTORY = $(INSTALL_DIRECTORY)
	__OS__ = $(__OS__)
	EOF

install: ## Runs targets -> link-script
install: | link-script

uninstall: ## Runs targets -> unlink-script
uninstall: | unlink-script

upgrade: ## Runs targets -> uninstall git-pull install
upgrade: | uninstall git-pull install

git-pull: SHELL := /bin/bash
git-pull: ## Pulls updates from default upstream Git remote
	cd "$(ROOT_DIRECTORY_PATH)"
	git pull

link-script: SHELL := /bin/bash
link-script: ## Symbolically links to project script
	if [[ -L "$(INSTALL_PATH)" ]]; then
		printf >&2 'Link already exists -> %s\n' "$(INSTALL_PATH)"
	elif [[ -f "$(INSTALL_PATH)" ]]; then
		printf >&2 'Error link target is a file -> %s\n' "$(INSTALL_PATH)"
	else
		ln -sv "$(ROOT_DIRECTORY_PATH)/$(SCRIPT_NAME)" "$(INSTALL_PATH)"
	fi

unlink-script: SHELL := /bin/bash
unlink-script: ## Removes symbolic links to project script
	if [[ -L "$(INSTALL_PATH)" ]]; then
		rm -v "$(INSTALL_PATH)"
	elif [[ -f "$(INSTALL_PATH)" ]]; then
		printf >&2 'Error link target is a file -> %s\n' "$(INSTALL_PATH)"
	else
		printf >&2 'No link to remove at -> %s\n' "$(INSTALL_PATH)"
	fi

list: SHELL := /bin/bash
list: ## Lists available make commands
	gawk 'BEGIN {
		delete matched_lines
	}
	{
		if ($$0 ~ "^[a-z0-9A-Z-]{1,32}: [#]{1,2}[[:print:]]*$$") {
			matched_lines[length(matched_lines)] = $$0
		}
	}
	END {
		print "## Make Commands for $(NAME) ##\n"
		for (k in matched_lines) {
			split(matched_lines[k], line_components, ":")
			gsub(" ## ", "    ", line_components[2])
			print line_components[1]
			print line_components[2]
			if ((k + 1) != length(matched_lines)) {
				print
			}
		}
	}' "$(ROOT_DIRECTORY_PATH)/Makefile"


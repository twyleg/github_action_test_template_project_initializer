#!/usr/bin/env bash

[ "$DEBUG" == 1 ] && set -x

# set -e


SEARCH_KEYWORDS=$INPUT_SEARCH_KEYWORDS
EXCLUDE_DIRS=$INPUT_EXCLUDE_DIRS

assert_non_empty() {
    name=$1
    value=$2
    if [[ -z "$value" ]]; then
        echo "::error::Invalid Value: $name is empty." >&2
        exit 1
    fi
}

assert_non_empty inputs.search_KEYWORDS "$SEARCH_KEYWORDS"


# search_keywords=template_project_python2,template-project-python2
# exclude_dirs=.git/,venv/,.tox/,.mypy_cache/,.idea/,build/,dist/,__pycache__/,*.egg-info/


search_for_template_keywords() {
	cmd="grep -R --line-number --ignore-case --regexp={$1} --exclude-dir={$2} ."
	eval $cmd
}


ls -l

search_for_template_keywords $SEARCH_KEYWORDS $EXCLUDE_DIRS
echo $?


[ $? -eq 0 ] && exit 1

exit 0



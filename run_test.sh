#!/usr/bin/env bash

[ "$DEBUG" == 1 ] && set -x

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

search_for_template_keywords() {
	cmd="grep -R --line-number --ignore-case --regexp={$1} --exclude-dir={$2} ."
	eval $cmd
}

search_for_template_keywords $SEARCH_KEYWORDS $EXCLUDE_DIRS

if [ $? -eq 0 ]; then
	echo "Keyword occurences found: Error!"
	exit 1
else
	echo "No keyword occurences found: Success!"
	exit 0
fi




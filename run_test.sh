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

fulltext_search_for_template_keywords() {
	cmd="grep -R --line-number --ignore-case --regexp={$1} --exclude-dir={$2} ."
	eval $cmd
}


dir_path_search_for_template_keywords() {

  local dir_found=0
	for search_keyword in ${SEARCH_KEYWORDS//,/ }
	do
		if [ $( find . -name "$search_keyword" -type d | wc -l ) -ne 0 ]; then
		  find . -name "$search_keyword" -type d
			dir_found=1
		fi
	done

	return $dir_found
}


echo "::group::Fulltext search for keywords..."

fulltext_search_for_template_keywords $SEARCH_KEYWORDS $EXCLUDE_DIRS
fulltext_search_result=$(expr $? == 0 )

if [ $fulltext_search_result == 1 ]; then
	echo "Error: Fulltext search - Keyword occurences found."
else
	echo "Success: Fulltext search - No keyword occurences found."
fi

echo "::endgroup::"



echo "::group::Dir path search for keywords..."

dir_path_search_for_template_keywords $SEARCH_KEYWORDS $EXCLUDE_DIRS
dir_path_search_result=$(expr $? != 0 )

if [ $dir_path_search_result == 1 ]; then
	echo "Error: Dir path search - Keyword occurences found."
else
	echo "Success: Dir path search - No keyword occurences found."
fi

echo "::endgroup::"


echo "::group::Results..."

if [ $fulltext_search_result == 1 ] || [ $dir_path_search_result == 1 ]; then
  echo "Error: One or more left overs of the template found! Check previous outputs for details!"
  exit 1
else
  echo "Success: No left overs of the template found!"
fi

echo "::endgroup::"
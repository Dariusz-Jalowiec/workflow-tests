#!/bin/bash

### Script: search_for_releases.sh
### Purpose: search github for open Release Prs save them into output variable

if [[ -z ${GH_TOKEN} ]]; then
    echo "ERROR: BEARER_TOKEN is not specified."
    exit 1
fi

if [[ -z ${REPOSITORY} ]]; then
    echo "ERROR: REPOSITORY is not specified."
    exit 1
fi

pr_list=$(gh pr list --state open --repo "Dariusz-Jalowiec/${REPOSITORY}" --json headRefName --jq '.[] | select(.headRefName | startswith("release"))')

if [ $? -ne 0 ]; then
    echo "Error: Failed to retrieve pull requests. Error message: $pr_list"
    exit 1
fi

release_branches=$(echo "$pr_list" | jq -r '.[].headRefName' | jq -sR 'split("\n")[:-1] | map(split("\n")) | flatten | map(select(. != ""))')

echo "branches=$release_branches" >> $GITHUB_OUTPUT

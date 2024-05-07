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

echo "REPOSITORY is ${REPOSITORY}"

pr_list=$(gh pr list --state open --repo "${REPOSITORY}" --json headRefName --jq '.[] | select(.headRefName | startswith("release"))')

if [ $? -ne 0 ]; then
    echo "Error: Failed to retrieve pull requests. Error message: $pr_list"
    exit 1
fi

release_branches=$(echo "$pr_list" | jq -c -s '{"releases": [.[] | {branch: .headRefName}]}' | tr -d ' ')

echo "release_branches is ${release_branches}"

echo "branches=$release_branches" >> $GITHUB_OUTPUT

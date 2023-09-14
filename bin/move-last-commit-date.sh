#!/bin/sh
n_days=$1
commit=$(git rev-parse HEAD)
commit_timestamp=$(git show -s --format=%at $commit)
new_timestamp=$(($commit_timestamp + ($n_days * 24 * 60 * 60)))

GIT_COMMITTER_DATE="$new_timestamp" git commit --amend --no-edit --date "$new_timestamp"
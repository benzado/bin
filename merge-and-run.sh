#!/usr/bin/env bash

# Within a git repository, use merge-and-run.sh to temporarily merge the
# current branch into the master branch and run some commands. The primary
# motivation for this is when you want to see if the project compiles and
# tests pass AFTER merging.

# If given arguments, merge-and-run.sh will treat them as a command, which it
# runs on the merged branch, then immediately cleans up. Without arguments,
# it starts an subshell, and cleans up when you exit it.

# ---

REMOTE=origin
MASTER=master
PROPOSED_BRANCH=$(git rev-parse --abbrev-ref HEAD)
TEMP_BRANCH="temporary-branch-$RANDOM"

echo "Ensuring $REMOTE/$MASTER is up-to-date"
git fetch $REMOTE $MASTER || exit $?

echo "Creating a temporary branch"
git branch --no-track $TEMP_BRANCH $REMOTE/$MASTER || exit $?

echo "Merging $PROPOSED_BRANCH into temporary branch"
git checkout $TEMP_BRANCH || exit $?
git merge $PROPOSED_BRANCH

function bold {
  echo "$(tput bold)$*$(tput sgr0)"
}

echo
if [ -z $1 ]; then
  echo "The current git branch is the result of merging $(bold $PROPOSED_BRANCH)"
  echo "into $(bold $REMOTE/$MASTER). Run any tests, analysis, etc., you wish to,"
  echo "then type 'exit' to delete this temporary branch and return to the"
  echo "$(bold $PROPOSED_BRANCH) branch."
  echo
  export PS1="$(bold '\$ ')"
  $BASH -i
else
  echo "Running command: $(bold $*)"
  echo
  $*
fi
echo

echo "Cleaning up"
git checkout $PROPOSED_BRANCH
git branch -D $TEMP_BRANCH

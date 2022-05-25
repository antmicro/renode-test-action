#!/bin/bash

# Convert string into array
renode_arguments=( $(xargs -n1 printf '%s\n' <<< "$RENODE_ARGUMENTS") )

# Install renode-run script
pip install -q git+https://github.com/antmicro/renode-run

# Download renode
renode-run -a $RENODE_RUN_DIR download -d $RENODE_VERSION

echo "::add-matcher::$GITHUB_ACTION_PATH/src/renode-problem-matcher.json"

if [ -z "$TESTS_TO_RUN" ]
then
    echo "No tests provided, renode-run artifacts are installed to $RENODE_RUN_DIR"
else
    renode-run -a $RENODE_RUN_DIR test -- -r $ARTIFACTS_PATH "${renode_arguments[@]}" $TESTS_TO_RUN
fi

echo "::remove-matcher owner=test-in-renode::"

#!/bin/bash

set -e
if ! $GITHUB_ACTION_PATH/src/check_renode_install.sh;
then
    # RENODE_DIR should be set by the action parameter
    mkdir -p $RENODE_DIR
    echo "RENODE_DIR=$RENODE_DIR" >> $GITHUB_ENV
    if ! wget --progress=dot:giga https://dl.antmicro.com/projects/renode/builds/renode-$RENODE_VERSION.linux-portable.tar.gz;
    then
        echo "There was an error when downloading the package. The provided Renode version might be wrong: $RENODE_VERSION"
        exit 1
    fi
    tar -xzf renode-$RENODE_VERSION.linux-portable.tar.gz -C $RENODE_DIR --strip 1
    if ! $GITHUB_ACTION_PATH/src/check_renode_install.sh;
    then
        echo "Tried to install Renode, but failed. Please inspect the log"
        exit 1
    fi
fi

# Install PIP requirements unconditionally.
# This is usable if Renode comes from a GH Action cache - users
# can cache RENODE_DIR to pass it between jobs, but Python dependencies
# are a bit more difficult to locate and cache.
pip install -q -r $RENODE_DIR/tests/requirements.txt --no-warn-script-location

# path to a problem matcher file needs
# to be accessible to the runner outside the container
MATCHER_PATH="$(dirname $BASH_SOURCE)"
if [ -d "/github/workflow" ]
then
    # we seem to be in the docker environment
    MATCHER_PATH="$RUNNER_TEMP/_github_workflow/$MATCHER_PATH"
fi

echo "::add-matcher::$MATCHER_PATH/renode-problem-matcher.json"

if [ -z "$TESTS_TO_RUN" ]
then
    echo "No tests provided, Renode is installed to $RENODE_DIR"
else
    if [ -f $RENODE_DIR/renode-test ]
    then
        # current version of the Renode portable package
        # contains the `renode-test` script
        $RENODE_DIR/renode-test --show-log $TESTS_TO_RUN
    elif [ -f $RENODE_DIR/test.sh ]
    then
        # older versions were shipped with
        # the `test.sh` script
        $RENODE_DIR/test.sh $TESTS_TO_RUN
    else
        echo "Could not find the test script"
        exit 1
    fi
fi

echo "::remove-matcher owner=test-in-renode::"

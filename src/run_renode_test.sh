#!/bin/bash

set -e
if ! $GITHUB_ACTION_PATH/src/check_renode_install.sh;
then
    export RENODE_DIR=$(mktemp -d)
    echo "RENODE_DIR=$RENODE_DIR" >> $GITHUB_ENV
    if ! wget -q https://dl.antmicro.com/projects/renode/builds/renode-$RENODE_VERSION.linux-portable.tar.gz;
    then
        echo "There was an error when downloading the package. The provided Renode version might be wrong: $RENODE_VERSION"
        exit 1
    fi
    tar -xzf renode-$RENODE_VERSION.linux-portable.tar.gz -C $RENODE_DIR --strip 1
    pip install -q -r $RENODE_DIR/tests/requirements.txt --no-warn-script-location
    if ! $GITHUB_ACTION_PATH/src/check_renode_install.sh;
    then
        echo "Tried to install Renode, but failed. Please inspect the log"
        exit 1
    fi
fi

# path to a problem matcher file needs
# to be accessible to the runner outside the container
MATCHER_PATH="$(dirname $BASH_SOURCE)"
if [ -d "/github/workflow" ]
then
    # we seem to be in the docker environment
    MATCHER_PATH="$RUNNER_TEMP/_github_workflow/$MATCHER_PATH"
fi

echo "::add-matcher::$MATCHER_PATH/renode-problem-matcher.json"

if [ -f $RENODE_DIR/renode-test ]
then
    # current version of the Renode portable package
    # contains the `renode-test` script
    $RENODE_DIR/renode-test $TESTS_TO_RUN
elif [ -f $RENODE_DIR/test.sh ]
then
    # older versions were shipped with
    # the `test.sh` script
    $RENODE_DIR/test.sh $TESTS_TO_RUN
else
    echo "Could not find the test script"
    exit 1
fi

echo "::remove-matcher owner=test-in-renode::"

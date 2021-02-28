#!/bin/sh

set -e
if ! $GITHUB_ACTION_PATH/../__tests__/check_renode_install.sh;
then
    RENODE_DIR=$(mktemp -d)
    echo "RENODE_DIR=$RENODE_DIR" >> $GITHUB_ENV
    if ! wget -q https://dl.antmicro.com/projects/renode/builds/renode-$RENODE_VERSION.linux-portable.tar.gz;
    then
        echo "There was an error when downloading the package. The provided Renode version might be wrong: $RENODE_VERSION"
        exit 1
    fi
    tar -xzf renode-$RENODE_VERSION.linux-portable.tar.gz -C $RENODE_DIR --strip 1
    pip install -q -r $RENODE_DIR/tests/requirements.txt --no-warn-script-location
fi

$RENODE_DIR/test.sh $TESTS_TO_RUN

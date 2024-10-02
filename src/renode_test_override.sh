#!/bin/bash

py -3 "$RENODE_ROOT/tests/run_tests.py" --css-file "$RENODE_ROOT/lib/resources/styles/robot.css" --exclude "skip_windows" --robot-framework-remote-server-full-directory  "$RENODE_ROOT/output/bin/Release" -r "$PWD" "$@"

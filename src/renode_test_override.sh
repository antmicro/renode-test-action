#!/bin/bash

ROOT="$(cd $(dirname $(readlink -f $0 2>/dev/null || echo $0)); cd ..; echo $PWD)"
py -3 "$ROOT/tests/run_tests.py" --css-file "$ROOT/tests/robot.css" --exclude "skip_windows" --robot-framework-remote-server-full-directory  "$ROOT/bin" -r "$PWD" "$@"

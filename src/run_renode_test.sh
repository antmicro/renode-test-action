#!/bin/bash

parse_boolean() {
    arg="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    case "$arg" in
        "true" | "yes") return 0 ;;
        "false" | "no") return 1 ;;
        *)
            echo "'$1' is not an valid boolean value. Accepted values are 'true', 'yes', 'false' and 'no'"
            exit 1
    esac
}

# Convert string into array
renode_arguments=( $(xargs -n1 printf '%s\n' <<< "$RENODE_ARGUMENTS") )

if parse_boolean "$EXECUTION_METRICS"
then
    renode_arguments+=("--gather-execution-metrics")
fi

echo "::add-matcher::$GITHUB_ACTION_PATH/src/renode-problem-matcher.json"

TEST_RESULT=0

if [ -z "$TESTS_TO_RUN" ]
then
    echo "No tests provided, renode installed to $RENODE_ROOT"
else
    renode-test -r $ARTIFACTS_PATH "${renode_arguments[@]}" $TESTS_TO_RUN
    TEST_RESULT=$?
fi

echo "::remove-matcher owner=test-in-renode::"

if parse_boolean "$EXECUTION_METRICS"
then
    # Path to metrics_visualizer
    METRICS_ANALYZER_DIR="$RENODE_ROOT/tools/metrics_analyzer"
    METRICS_VISUALIZER="$METRICS_ANALYZER_DIR/metrics_visualizer/metrics-visualizer.py"

    # Path when generated visualisations will land
    METRICS_ARTIFACTS="$ARTIFACTS_PATH/metrics-visualizations"
    mkdir -p $METRICS_ARTIFACTS

    # Install required packages to virtualenv (if needed)
    VENV_DIR="$RENODE_ROOT/metrics-venv"
    if [ ! -d "$VENV_DIR" ]; then
        python -m venv "$VENV_DIR"
        source $VENV_DIR/bin/activate
        pip install -r "$METRICS_ANALYZER_DIR/metrics_visualizer/requirements.txt"
    else
        source $VENV_DIR/bin/activate
    fi

    # Generate visualisation from profiler output
    for fpath in $ARTIFACTS_PATH/profiler-*
    do
        fname=$(basename $fpath)
        METRICS_OUTPUT="$METRICS_ARTIFACTS/$fname"
        mkdir $METRICS_OUTPUT
        $METRICS_VISUALIZER -o $METRICS_OUTPUT $fpath
    done

    # Deactivate virtualenv
    deactivate
fi

exit $TEST_RESULT

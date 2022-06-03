#!/bin/bash

parse_boolean() {
    arg=${1,,}
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

if parse_boolean "$EXECUTION_METRICS"
then
    # Path to metrics_visualizer
    METRICS_ANALYZER_DIR="$RENODE_RUN_DIR/renode-run.download/tools/metrics_analyzer"
    METRICS_VISUALIZER="$METRICS_ANALYZER_DIR/metrics_visualizer/metrics-visualizer.py"

    # Path when generated visualisations will land
    METRICS_ARTIFACTS="$ARTIFACTS_PATH/metrics-visualizations"
    mkdir -p $METRICS_ARTIFACTS

    # Install required packages to virtualenv (if needed)
    VENV_DIR="$RENODE_RUN_DIR/renode-run.venv"
    source $VENV_DIR/bin/activate
    pip install -r "$METRICS_ANALYZER_DIR/metrics_visualizer/requirements.txt"

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

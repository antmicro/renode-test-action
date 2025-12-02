# Test in Renode GitHub Action

Copyright (c) 2021-2025 [Antmicro](https://www.antmicro.com)

[![View on Antmicro Open Source Portal](https://img.shields.io/badge/View%20on-Antmicro%20Open%20Source%20Portal-332d37?style=flat-square)](https://opensource.antmicro.com/projects/renode-test-action)

A GitHub Action for testing embedded software in the [Renode](https://about.renode.io/) simulation environment using the [Robot Framework](http://robotframework.org/).

See how to use Robot with Renode in the [relevant chapter in our documentation](https://renode.readthedocs.io/en/latest/introduction/testing.html).

This action allows you to write a test in Robot using Renode's predefined keyword library and execute them automatically in GitHub Actions, which results in very nice test logs and summaries.

## Usage

![Test action](https://github.com/antmicro/renode-test-action/workflows/Test%20action/badge.svg)

See [action.yml](action.yml)

```yaml
steps:
- uses: antmicro/renode-test-action@v5
  with:
    renode-revision: 'master'
    tests-to-run: 'tests/**/*.robot'
```

## Action parameters

* `renode-revision` - indicates the Renode version to be built. Can be the name of a branch or tag in the repository or a commit hash. The default is Renode's `master` branch.
* `renode-repository` - indicates the repository containing the Renode source to build. The default is the official Renode repository (`https://github.com/renode/renode`). 
* `tests-to-run` - path to the Robot files you want to execute.
* `renode-arguments` - optional, additional arguments passed to Renode. See [Renode README](https://github.com/renode/renode) for details. Default: no additional arguments.
* `artifacts-path` - optional, path where  test artifacts should be stored. This includes Robot logs and HTML reports. Default: current directory.
* `gather-execution-metrics` - optional, whether to gather and visualize execution metrics. Default: no.
* `install-dependencies` - optional, whether to install dependencies before building Renode (requires sudo privileges, Linux specific). Default: yes.
* `disable-summary-generation` - optional, whether to disable step summary generation. Default: no.

## Using cache

This action caches Renode builds by default using [the standard GitHub caching mechanism](https://github.com/actions/cache).

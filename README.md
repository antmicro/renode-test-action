# Test in Renode GitHub Action

Copyright (c) 2024 [Antmicro](https://www.antmicro.com)

[![View on Antmicro Open Source Portal](https://img.shields.io/badge/View%20on-Antmicro%20Open%20Source%20Portal-332d37?style=flat-square)](https://opensource.antmicro.com/projects/renode-test-action)

A GitHub Action for testing embedded software in the [Renode](https://about.renode.io/) simulation environment using the [Robot Framework](http://robotframework.org/).

See how to use Robot with Renode in the [relevant chapter in our documentation](https://renode.readthedocs.io/en/latest/introduction/testing.html).

This action allows you to write a test in Robot using Renode's predefined keyword library and execute them automatically in GitHub Actions, which results in very nice test logs and summaries.

## Usage

![Test action](https://github.com/antmicro/renode-test-action/workflows/Test%20action/badge.svg)

See [action.yml](action.yml)

```yaml
steps:
- uses: antmicro/renode-test-action@v3.1.0
  with:
    renode-version: 'latest'
    tests-to-run: 'tests/**/*.robot'
```

## Action parameters

* `renode-version` - required, indicates the Renode version to be downloaded from https://builds.renode.io. Can be `latest`
* `tests-to-run` - path to Robot files you want to execute
* `renode-run-path` - optional, path where [renode-run](https://github.com/antmicro/renode-run) should store Renode. Useful when using cache (see below). Default: temporary directory.
* `renode-arguments` - optional, additional arguments passed to Renode. See [Renode README](https://github.com/renode/renode) for details. Default: no additional arguments.
* `artifacts-path` - optional, path where  test artifacts should be stored. This includes Robot logs and HTML reports. Default: current directory.

## Using cache

If you use this action many times in a single job, Renode gets downloaded only once.

However, if you want to use the same Renode instance across multiple jobs, it's advisable to use cache.

```yaml
jobs:
  first-job:
    steps:
     - name: Prepare Renode settings
       run: |
         echo "RENODE_VERSION=latest" >> $GITHUB_ENV
         echo "RENODE_RUN_DIR=/some/directory" >> $GITHUB_ENV

     - name: Download Renode
       uses: antmicro/renode-test-action@v3.1.0
       with:
        renode-version: '${{ env.RENODE_VERSION }}'
        renode-run-path: '${{ env.RENODE_RUN_DIR }}'

     - name: Cache Renode installation
       uses: actions/cache@v2
       id: cache-renode
       with:
         path: '${{ env.RENODE_RUN_DIR }}'
         key: cache-renode-${{ env.RENODE_VERSION }}

  second-job:
    steps:
     - name: Prepare Renode settings
       run: |
         echo "RENODE_VERSION=latest" >> $GITHUB_ENV
         echo "RENODE_RUN_DIR=/some/directory" >> $GITHUB_ENV

     - name: Restore Renode
       uses: actions/cache@v2
       id: cache-renode
       with:
         path: '${{ env.RENODE_RUN_DIR }}'
         key: cfu-cache-renode-${{ env.RENODE_VERSION }}

     - name: Run tests
       uses: antmicro/renode-test-action@v3.1.0
       with:
         renode-version: '${{ env.RENODE_VERSION }}'
         tests-to-run: tests-*.robot
         renode-run-path: '${{ env.RENODE_RUN_DIR }}'
```

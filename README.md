# Test in Renode GitHub Action
Copyright (c) 2021 [Antmicro](https://www.antmicro.com)

A GitHub Action for testing software in the Renode environment.

## Usage

![Test action](https://github.com/antmicro/renode-test-action/workflows/Test%20action/badge.svg)

See [action.yml](action.yml)

```yaml
steps:
- uses: antmicro/renode-test-action@v2.0.0
  with:
    renode-version: 'latest'
    tests-to-run: 'tests/**/*.robot'
```

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
         echo "RENODE_DIR=/some/directory" >> $GITHUB_ENV

     - name: Download Renode
       uses: antmicro/renode-test-action@v2.0.0
       with:
        renode-version: '${{ env.RENODE_VERSION }}'
        renode-path: '${{ env.RENODE_DIR }}'

     - name: Cache Renode installation
       uses: actions/cache@v2
       id: cache-renode
       with:
         path: '${{ env.RENODE_DIR }}'
         key: cache-renode-${{ env.RENODE_VERSION }}

  second-job:
    steps:
     - name: Prepare Renode settings
       run: |
         echo "RENODE_VERSION=latest" >> $GITHUB_ENV
         echo "RENODE_DIR=/some/directory" >> $GITHUB_ENV

     - name: Restore Renode
       uses: actions/cache@v2
       id: cache-renode
       with:
         path: '${{ env.RENODE_DIR }}'
         key: cfu-cache-renode-${{ env.RENODE_VERSION }}

     - name: Run tests
       uses: antmicro/renode-test-action@v2.0.0
       with:
         renode-version: '${{ env.RENODE_VERSION }}'
         tests-to-run: tests-*.robot
         renode-path: '${{ env.RENODE_DIR }}'
```

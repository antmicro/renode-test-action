# renode-actions
Copyright (c) 2021 [Antmicro](https://www.antmicro.com)

This repository contains a Renode GitHub action for testing software in the Renode environment.

## Usage

### test-in-renode

![Test action](https://github.com/antmicro/renode-actions/workflows/Test%20action/badge.svg)

See [action.yml](test-in-renode/action.yml)

```yaml
steps:
- uses: antmicro/renode-actions/test-in-renode@master
  with:
    renode-version: 'latest'
    tests-to-run: 'tests/**/*.robot' 
```

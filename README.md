# Test in Renode GitHub Action
Copyright (c) 2021 [Antmicro](https://www.antmicro.com)

A GitHub Action for testing software in the Renode environment.

## Usage

![Test action](https://github.com/antmicro/renode-actions/workflows/Test%20action/badge.svg)

See [action.yml](test-in-renode/action.yml)

```yaml
steps:
- uses: antmicro/renode-actions/test-in-renode@main
  with:
    renode-version: 'latest'
    tests-to-run: 'tests/**/*.robot' 
```

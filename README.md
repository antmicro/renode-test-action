# Test in Renode GitHub Action
Copyright (c) 2021 [Antmicro](https://www.antmicro.com)

A GitHub Action for testing software in the Renode environment.

## Usage

![Test action](https://github.com/antmicro/renode-test-action/workflows/Test%20action/badge.svg)

See [action.yml](action.yml)

```yaml
steps:
- uses: antmicro/renode-test-action@v1.0.0
  with:
    renode-version: 'latest'
    tests-to-run: 'tests/**/*.robot' 
```

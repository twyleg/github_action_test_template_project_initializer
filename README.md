# Test Template Project Initializer

GitHub action to verify that [template-project-utils](https://github.com/twyleg/template_project_utils) 
template projects are correctly initialized without leftovers from the template. 

## Inputs

### `search_keywords`
**Required** Comma separated list of keywords to run a recursive fulltext search on..

### `exclude_dirs`
**Optional** Comma separated list of dirs to exclude from fulltext search of keywords..


## Example usage

```yaml
name: test_template_initializer
run-name: test_template_initializer
on:
  workflow_call:

  push:
    branches:
      - "**"
jobs:
  test_template_initializer:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: 3.12
      - run: pip install template-project-utils
      - name: Initialize template
        run: template_project_utils template_project_python=new_project_name template-project-python=new-project-name
      - name: Test template initializer
        uses: twyleg/github_action_test_template_project_initializer@master
        with:
          search_keywords: template_project_python,template-project-python
          exclude_dirs: .git/,venv/,.tox/,.mypy_cache/,.idea/,build/,dist/,__pycache__/,*.egg-info/,logs/
```

## Example

- https://github.com/twyleg/template_project_python


## LICENSE

[MIT](./LICENSE)

# Publish PPA Package

GitHub action to publish the Ubuntu PPA (Personal Package Archives) packages.

## Inputs

### `ppa_repository`
**Required** The PPA repository, e.g. `twyleg/hello-world`.

### `ppa_package`
**Required** The PPA package name, e.g. `hello-world`.


## Example usage

```yaml
name: Upload PPA Package

on:
  release:
    types: [published]

permissions:
  contents: write

jobs:
  publish-ppa:
    runs-on: ubuntu-latest
    steps:
    - name: Publish PPA
      uses: twyleg/github_action_publish_ppa_package@v2
      with:
        ppa_package: "hello-world"
        ppa_repository: "twyleg/ppa"
        deb_email: "mail@twyleg.de"
        deb_fullname: "Torsten Wylegala"
        gpg_private_key: ${{ secrets.PPA_GPG_PRIVATE_KEY }}
        gpg_passphrase: ${{ secrets.PPA_GPG_PASSPHRASE }}
        upstream_version: ${{ github.event.release.tag_name }}
        series: "oracular"
```

## Example

- https://github.com/twyleg/template_project_python


## LICENSE

[MIT](./LICENSE)

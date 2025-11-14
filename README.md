> [!CAUTION]
> Do not use it for your production workflows yet!

# GitHub Builder

This repository provides official Docker-maintained [reusable GitHub Actions workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
to securely build container images using Docker best practices. The workflows
sign BuildKit-generated SLSA-compliant provenance attestations and align with
the principles behind [Docker Hardened Images](https://docs.docker.com/dhi/),
enabling open source projects to follow a seamless path toward higher levels of
security and trust.

## :test_tube: Experimental

This repository is considered **EXPERIMENTAL** and under active development
until further notice. It is subject to non-backward compatible changes or
removal in any future version.

## Build reusable workflow

```yaml
name: ci

permissions:
  contents: read

on:
  push:
    branches:
      - 'main'
    tags:
      - 'v*'
  pull_request:

  build:
    uses: docker/github-builder-experimental/.github/workflows/build.yml@main
    permissions:
      contents: read
      id-token: write # for signing attestation manifests with GitHub OIDC Token
      packages: write # only used if pushing to GHCR but needs to be defined as caller must provide permissions ≥ to those used in the reusable workflow
    with:
      output: ${{ github.event_name != 'pull_request' && 'registry' || 'cacheonly' }}
      meta-images: name/app
      meta-tags: |
        type=ref,event=branch
        type=ref,event=pr
        type=semver,pattern={{version}}
      build-platforms: linux/amd64,linux/arm64
    secrets:
      registry-auths: |
        - registry: docker.io
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

  # Optional job to verify the pushed images' signatures. This is already done
  # in the `build` job and can be omitted. It's provided here as an example of
  # how to use the `verify.yml` reusable workflow.
  build-verify:
    uses: docker/github-builder-experimental/.github/workflows/verify.yml@main
    if: ${{ github.event_name != 'pull_request' }}
    needs:
      - build
    with:
      builder-outputs: ${{ toJSON(needs.build.outputs) }}
    secrets:
      registry-auths: |
        - registry: docker.io
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
```

You can find the list of available inputs in [`.github/workflows/build.yml`](.github/workflows/build.yml).

## Bake reusable workflow

```yaml
name: ci

permissions:
  contents: read

on:
  push:
    branches:
      - 'main'
    tags:
      - 'v*'
  pull_request:

  bake:
    uses: docker/github-builder-experimental/.github/workflows/bake.yml@main
    permissions:
      contents: read
      id-token: write # for signing attestation manifests with GitHub OIDC Token
      packages: write # only used if pushing to GHCR but needs to be defined as caller must provide permissions ≥ to those used in the reusable workflow
    with:
      output: ${{ github.event_name != 'pull_request' && 'registry' || 'cacheonly' }}
      meta-images: name/app
      meta-tags: |
        type=ref,event=branch
        type=ref,event=pr
        type=semver,pattern={{version}}
    secrets:
      registry-auths: |
        - registry: docker.io
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

  # Optional job to verify the pushed images' signatures. This is already done
  # in the `bake` job and can be omitted. It's provided here as an example of
  # how to use the `verify.yml` reusable workflow.
  bake-verify:
    uses: docker/github-builder-experimental/.github/workflows/verify.yml@main
    if: ${{ github.event_name != 'pull_request' }}
    needs:
      - bake
    with:
      builder-outputs: ${{ toJSON(needs.bake.outputs) }}
    secrets:
      registry-auths: |
        - registry: docker.io
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
```

You can find the list of available inputs in [`.github/workflows/bake.yml`](.github/workflows/bake.yml).

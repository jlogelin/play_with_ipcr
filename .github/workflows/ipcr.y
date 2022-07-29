name: Docker

on:
  push:
    # run only against tags
    #tags:
    #  - '*'

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:     
      - name: Checkout
        uses: actions/checkout@v3

      - name: Login to Interplanetary Container Registry
        uses: docker/login-action@v2
        with:
          registry: ipcr.io

      - name: Get the version (git tag)
        id: get_version
        run: |
          echo ${GITHUB_REF/refs\/tags\//}
          echo ::set-output name=VERSION::${GITHUB_REF/refs\/tags\//}

      - name: Build and push
        env:
          VERSION: ${{ steps.get_version.outputs.VERSION }}
        uses: docker/build-push-action@v3
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKERHUB_ORG }}/estuary:latest , ${{ secrets.DOCKERHUB_ORG }}/estuary:${{ steps.get_version.outputs.VERSION }}

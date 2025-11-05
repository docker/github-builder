# syntax=docker/dockerfile:1

ARG GO_VERSION="1.25"

# xx is a helper for cross-compilation
FROM --platform=$BUILDPLATFORM tonistiigi/xx:1.7.0 AS xx

FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS base
COPY --from=xx / /
RUN apk add --no-cache file git
ENV CGO_ENABLED=0
WORKDIR /src

FROM base AS build
ARG TARGETPLATFORM
RUN --mount=type=bind,target=. \
    --mount=target=/root/.cache,type=cache \
  xx-go build -trimpath -o /out/myapp . \
  && xx-verify --static /out/myapp
ARG BUILDKIT_SBOM_SCAN_STAGE=true

FROM scratch
COPY --from=build /out /

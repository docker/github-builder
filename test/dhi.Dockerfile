# syntax=docker/dockerfile:1

FROM dhi.io/alpine-base:3.23 AS base
ARG TARGETPLATFORM
RUN echo "Hello, World! This is ${TARGETPLATFORM}" > /tmp/hello.txt
ARG BUILDKIT_SBOM_SCAN_STAGE=true

FROM scratch
COPY --from=base /tmp/hello.txt /

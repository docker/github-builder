FROM alpine AS base
ARG TARGETPLATFORM
RUN echo "Hello, World! This is ${TARGETPLATFORM}" > /hello.txt
ARG BUILDKIT_SBOM_SCAN_STAGE=true

FROM scratch
COPY --from=base /hello.txt /

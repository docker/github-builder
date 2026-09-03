# syntax=docker/dockerfile:1

FROM alpine
ARG BUILDX_VERSION
ARG GITHUB_SHA
ARG RUNNER_OS
ARG XX_VERSION
RUN test "$BUILDX_VERSION" = "not-leaked"
RUN test -n "$GITHUB_SHA"
RUN test -n "$RUNNER_OS"
RUN test "$XX_VERSION" = "1.9.0"
RUN mkdir -p /out && printf 'ok\n' > /out/vars.txt

FROM scratch
COPY --from=0 /out /

# syntax=docker/dockerfile:1

FROM alpine
RUN --mount=type=secret,id=fixture_plain,env=fixture_plain \
    --mount=type=secret,id=fixture_json,env=fixture_json \
    printf 'fixture_plain=%s\n' "$fixture_plain" && \
    printf 'fixture_json=%s\n' "$fixture_json" && \
    printf 'alpha-line\nbeta-line\n' > /tmp/expected && \
    printf '%s' "$fixture_plain" | cmp - /tmp/expected && \
    printf 'gamma-line\ndelta-line\n' > /tmp/expected-json && \
    printf '%s' "$fixture_json" | cmp - /tmp/expected-json

# syntax=docker/dockerfile:1

FROM alpine
RUN --mount=type=secret,id=fixture.plain,env=fixture_plain \
    --mount=type=secret,id=fixture.json,env=fixture_json \
    --mount=type=secret,id=fixture_fuu,env=fixture_fuu \
    --mount=type=secret,id=fixture_keep,env=fixture_keep \
    printf 'fixture_plain=%s\n' "$fixture_plain" && \
    printf 'fixture_json=%s\n' "$fixture_json" && \
    printf 'alpha-line\nbeta-line\n' > /tmp/expected && \
    printf '%s' "$fixture_plain" | cmp - /tmp/expected && \
    printf 'gamma-line\ndelta-line\n' > /tmp/expected-json && \
    printf '%s' "$fixture_json" | cmp - /tmp/expected-json && \
    test "$fixture_fuu" = 'standard-secret' && \
    printf 'keep-line\n\n' > /tmp/expected-keep && \
    printf '%s' "$fixture_keep" | cmp - /tmp/expected-keep

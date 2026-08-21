# syntax=docker/dockerfile:1

FROM alpine AS check
RUN wget -qO- https://checkip.amazonaws.com/ | grep -Eq "^[0-9a-fA-F:.]+$"
RUN grep -q "buildkit proxy CA begin" /etc/ssl/certs/ca-certificates.crt
RUN --network=none ! grep -q "buildkit proxy CA begin" /etc/ssl/certs/ca-certificates.crt

FROM scratch
COPY --from=check /etc/alpine-release /alpine-release

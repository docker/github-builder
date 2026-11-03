# syntax=docker/dockerfile:1

FROM alpine
ARG TARGETPLATFORM
RUN echo "Hello, World! This is running on ${TARGETPLATFORM}" > /hello.txt

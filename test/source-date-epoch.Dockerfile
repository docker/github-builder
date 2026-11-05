FROM busybox AS build
ARG SOURCE_DATE_EPOCH
ARG EXPECTED_EPOCH
RUN if [ "$EXPECTED_EPOCH" = commit ]; then \
      test "$SOURCE_DATE_EPOCH" -gt 1; \
    else \
      test "$SOURCE_DATE_EPOCH" = "$EXPECTED_EPOCH"; \
    fi && \
    echo "$SOURCE_DATE_EPOCH" > /epoch

FROM scratch
COPY --from=build /epoch /epoch

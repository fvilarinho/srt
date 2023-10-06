# Default container image.
FROM alpine:3.18.3

# Install and update the required software.
RUN apk update && \
    apk add --no-cache libsrt-progs
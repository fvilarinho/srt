# Default container image.
FROM alpine:3.18.3

# Install and update the required software.
RUN apk update && \
    apk add --no-cache libsrt-progs bash

# Copy the healthcheck file.
COPY healthcheck.sh /usr/local/bin

# Add execution permission.
RUN chmod +x /usr/local/bin/healthcheck.sh
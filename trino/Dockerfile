# First stage: build pspg from source using Alpine with static linking
FROM alpine:latest AS pspg-builder

# Install build dependencies
RUN apk add --no-cache \
    git \
    gcc \
    make \
    musl-dev \
    ncurses-static \
    ncurses-dev \
    readline-static \
    readline-dev

# Clone and build pspg with static linking
RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    git clone https://github.com/okbob/pspg.git && \
    cd pspg && \
    LDFLAGS="-static" ./configure && \
    make && \
    make install

# Second stage: use the official Trino image and copy pspg binary
FROM trinodb/trino:latest

USER root

# Copy statically linked pspg binary from the builder stage
COPY --from=pspg-builder /usr/local/bin/pspg /usr/local/bin/pspg

# Set pspg as the default pager specifically for Trino CLI
ENV TRINO_PAGER="pspg --no-mouse"
ENV LESS="-iMFXSx4R"

# Switch back to the trino user
USER trino:trino

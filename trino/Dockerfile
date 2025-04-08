# Start with the official Trino image
FROM trinodb/trino:latest

# Switch to root to install packages
USER root

# Install pspg and any dependencies
RUN apt-get update && \
    apt-get install -y pspg less && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set pspg as the default pager for Trino CLI
ENV LESS="-iMFXSx4R"
ENV PAGER="pspg --no-mouse"

# Switch back to the trino user
USER trino

# The default command will be inherited from the base image

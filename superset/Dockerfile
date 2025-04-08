FROM apache/superset:4.1.2

USER root

COPY --chmod=777 superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

# Install Trino driver
USER root
RUN apt-get update && apt-get install -y gcc python3-dev && \
    pip install trino --no-cache-dir && \
    apt-get remove -y gcc python3-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER superset

ENTRYPOINT [ "/usr/bin/run-server.sh" ]

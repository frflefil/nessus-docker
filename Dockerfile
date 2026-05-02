FROM ubuntu:22.04

LABEL maintainer="docker-builder" \
      description="Tenable Nessus Pre-Production Environment Mock" \
      version="1.0"

RUN apt-get update && apt-get install -y curl python3 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/nessus/etc \
             /opt/nessus/lib/nessus/plugins \
             /opt/nessus/var/nessus/logs

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8834/ || exit 1

EXPOSE 8834

CMD ["python3", "-m", "http.server", "8834", "--directory", "/opt/nessus"]

FROM tenable/nessus:latest

# Metadata
LABEL maintainer="docker-builder" \
      description="Tenable Nessus Pre-Production Environment" \
      version="1.0"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8834/ || exit 1

# Expose Nessus web interface port
EXPOSE 8834

# Default command
CMD ["/bin/sh", "-c", "nessusd -D"]

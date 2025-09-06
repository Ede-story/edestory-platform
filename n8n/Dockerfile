# n8n Custom Docker Image for Edestory Platform
FROM n8nio/n8n:latest

# Switch to root to install dependencies
USER root

# Install additional packages for custom nodes
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    curl \
    jq

# Install Python packages for data processing
RUN pip3 install --no-cache-dir \
    pandas \
    numpy \
    requests \
    beautifulsoup4

# Create directories for custom nodes and credentials
RUN mkdir -p /home/node/.n8n/custom \
    && mkdir -p /home/node/.n8n/nodes \
    && mkdir -p /home/node/.n8n/credentials \
    && chown -R node:node /home/node/.n8n

# Copy custom nodes (if any)
# COPY --chown=node:node ./custom-nodes /home/node/.n8n/custom/

# Switch back to node user
USER node

# Set environment variables
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom"
ENV N8N_USER_FOLDER="/home/node/.n8n"
ENV NODE_ENV="production"

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
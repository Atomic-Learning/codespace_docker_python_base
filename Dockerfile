# Base image: change the Python tag if you want a newer one later
FROM python:3.13-slim

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user (Codespaces uses "vscode" by default)
ARG USER=vscode
ARG UID=1000
RUN useradd -m -u ${UID} ${USER} || true

# Switch to that user
USER ${USER}

# Upgrade pip and install the Python packages
# Using --prefer-binary and --no-cache-dir helps keep the image smaller and pulls wheels when available.
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip --no-cache-dir install --prefer-binary numpy scipy matplotlib pandas ipykernel



# Base image: change the Python tag if you want a newer one later
FROM python:3.12-slim

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system deps needed by some scientific libraries and to build wheels if needed.
# Keep this list as small as possible; many packages come as wheels so heavy build tools may not always be necessary.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    pkg-config \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user (Codespaces uses "vscode" by default)
ARG USER=vscode
ARG UID=1000
RUN useradd -m -u ${UID} ${USER} || true

# Switch to that user
USER ${USER}
WORKDIR /home/${USER}/workspace

# Upgrade pip and install the Python packages
# Using --prefer-binary and --no-cache-dir helps keep the image smaller and pulls wheels when available.
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip --no-cache-dir install --prefer-binary numpy scipy matplotlib pandas

# Optional: create a lightweight scripts directory and default workspace folder
RUN mkdir -p /workspaces && ln -s /workspaces /home/${USER}/workspace || true

# Final image metadata
ENV PATH="/home/${USER}/.local/bin:${PATH}"

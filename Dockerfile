# Development Environment Docker Image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    vim \
    nano \
     unzip \
     && rm -rf /var/lib/apt/lists/*

# Install Alacritty
RUN add-apt-repository ppa:aslatter/ppa -y \
    && apt-get update \
    && apt-get install -y alacritty


# Install Node.js (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Install Python 3.11
RUN add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y python3.11 python3.11-venv python3.11-dev \
    && ln -s /usr/bin/python3.11 /usr/bin/python

# Install pip for Python 3.11 manually (python3.11-pip not available)
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# Install global Node.js packages
RUN npm install -g \
    typescript \
    ts-node \
    nodemon \
    eslint \
    prettier \
    @types/node

# Install Python packages (run as root before switching to developer user)
RUN python3.11 -m pip install \
    openai \
    black \
    flake8 \
    mypy \
    pytest \
    jupyter \
    requests \
    python-dotenv

# Install VS Code Server (code-server) for web-based development
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install OpenCode AI coding agent
RUN curl -fsSL https://opencode.ai/install | bash

# Create a non-root user
RUN useradd -m -s /bin/bash developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up Git configuration template
RUN git config --global init.defaultBranch main

# Copy configuration files
COPY --chown=developer:developer . /home/developer/dev-setup/

# Switch to developer user
USER developer
WORKDIR /home/developer

# Create workspace directories
RUN mkdir -p /home/developer/workspace/projects \
    && mkdir -p /home/developer/workspace/scripts \
    && mkdir -p /home/developer/workspace/learning

# Set up VS Code Server configuration
RUN mkdir -p /home/developer/.config/code-server

# Expose VS Code Server port
EXPOSE 8080

# Set environment variables
ENV PATH="/home/developer/.local/bin:$PATH"
ENV WORKSPACE="/home/developer/workspace"

# Default command starts code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "/home/developer/workspace"]
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
    tmux \
    ripgrep \
    fd-find \
     && rm -rf /var/lib/apt/lists/*

# Install Neovim (latest stable)
RUN add-apt-repository ppa:neovim-ppa/stable -y \
    && apt-get update \
    && apt-get install -y neovim

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

# Create symbolic link for fdfind (required by some Neovim plugins)
RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd

# Set up Git configuration template
RUN git config --global init.defaultBranch main

# Copy configuration files
COPY --chown=developer:developer . /home/developer/dev-setup/

# Switch to developer user
USER developer
WORKDIR /home/developer

# Install AstroNvim
RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Create tmux configuration
RUN echo '# Set prefix to Ctrl-a\n\
set -g prefix C-a\n\
unbind C-b\n\
bind-key C-a send-prefix\n\
\n\
# Enable mouse mode\n\
set -g mouse on\n\
\n\
# Set default terminal mode to 256color mode\n\
set -g default-terminal "screen-256color"\n\
\n\
# Enable vi mode\n\
setw -g mode-keys vi\n\
\n\
# Start windows and panes at 1, not 0\n\
set -g base-index 1\n\
setw -g pane-base-index 1\n\
\n\
# Reload config file\n\
bind r source-file ~/.tmux.conf \\; display "Config reloaded!"\n\
\n\
# Split panes using | and -\n\
bind | split-window -h\n\
bind - split-window -v\n\
unbind '"'"'"\n\
unbind %\n\
\n\
# Switch panes using Alt-arrow without prefix\n\
bind -n M-Left select-pane -L\n\
bind -n M-Right select-pane -R\n\
bind -n M-Up select-pane -U\n\
bind -n M-Down select-pane -D\n\
\n\
# Status bar customization\n\
set -g status-bg black\n\
set -g status-fg white\n\
set -g status-left '"'"'#[fg=green]#S '"'"'\n\
set -g status-right '"'"'#[fg=yellow]%Y-%m-%d %H:%M'"'"'' > ~/.tmux.conf

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
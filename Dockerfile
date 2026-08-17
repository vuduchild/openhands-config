FROM ghcr.io/openhands/agent-canvas:latest

USER root

# Install dependencies including GitHub CLI (gh), git, wget, golang
RUN apt-get update && apt-get install -y curl build-essential ca-certificates gnupg wget git golang && \
    mkdir -p -m 0755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Official Quick Install for RTK (Rust Token Killer)
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

ENV PATH="/root/.local/bin:${PATH}"

# Install custom RTK filters for aggressive token reduction
RUN mkdir -p /etc/rtk /root/.config/rtk /home/openhands/.config/rtk
COPY .config/rtk/filters.toml /etc/rtk/filters.toml
RUN cp /etc/rtk/filters.toml /root/.config/rtk/filters.toml && \
    cp /etc/rtk/filters.toml /home/openhands/.config/rtk/filters.toml

# Install gh-stack extension system-wide, build binary, and symlink for gh extension discovery
RUN mkdir -p /usr/local/share/gh/extensions
RUN git clone https://github.com/github/gh-stack /usr/local/share/gh/extensions/gh-stack
WORKDIR /usr/local/share/gh/extensions/gh-stack
RUN go build -o gh-stack .
RUN mkdir -p /root/.local/share/gh/extensions /home/openhands/.local/share/gh/extensions
RUN ln -sfn /usr/local/share/gh/extensions/gh-stack /root/.local/share/gh/extensions/gh-stack
RUN ln -sfn /usr/local/share/gh/extensions/gh-stack /home/openhands/.local/share/gh/extensions/gh-stack
RUN ln -sfn /usr/local/share/gh/extensions/gh-stack/gh-stack /usr/local/bin/gh-stack

WORKDIR /home/openhands

# Ensure PATH and transparent rtk command wrapping persist across bash sessions (bypassing rtk for gh stack)
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> /etc/bash.bashrc && \
    echo 'if command -v rtk >/dev/null 2>&1; then' >> /etc/bash.bashrc && \
    echo '    git() { rtk git "$@"; }' >> /etc/bash.bashrc && \
    echo '    ls() { rtk ls "$@"; }' >> /etc/bash.bashrc && \
    echo '    pytest() { rtk pytest "$@"; }' >> /etc/bash.bashrc && \
    echo '    npm() { rtk npm "$@"; }' >> /etc/bash.bashrc && \
    echo '    docker() { rtk docker "$@"; }' >> /etc/bash.bashrc && \
    echo '    kubectl() { rtk kubectl "$@"; }' >> /etc/bash.bashrc && \
    echo '    cargo() { rtk cargo "$@"; }' >> /etc/bash.bashrc && \
    echo '    uv() { rtk uv "$@"; }' >> /etc/bash.bashrc && \
    echo '    pip() { rtk pip "$@"; }' >> /etc/bash.bashrc && \
    echo '    gh() { if [ "$1" = "stack" ]; then command gh "$@"; else rtk gh "$@"; fi; }' >> /etc/bash.bashrc && \
    echo 'fi' >> /etc/bash.bashrc

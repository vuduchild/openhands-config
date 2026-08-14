FROM ghcr.io/openhands/agent-canvas:latest

USER root

# Install dependencies including GitHub CLI (gh), git, wget
RUN apt-get update && apt-get install -y curl build-essential ca-certificates gnupg wget git && \
    mkdir -p -m 0755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Official Quick Install for RTK (Rust Token Killer)
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

ENV PATH="/root/.local/bin:${PATH}"

# Install gh-stack extension system-wide and symlink directly for root and openhands users
RUN mkdir -p /usr/local/share/gh/extensions
RUN git clone https://github.com/github/gh-stack /usr/local/share/gh/extensions/gh-stack
RUN mkdir -p /root/.config/gh/extensions /home/openhands/.config/gh/extensions
RUN ln -sfn /usr/local/share/gh/extensions/gh-stack /root/.config/gh/extensions/gh-stack
RUN ln -sfn /usr/local/share/gh/extensions/gh-stack /home/openhands/.config/gh/extensions/gh-stack

# Ensure PATH and transparent rtk command wrapping persist across bash sessions (NO interactive init prompts)
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
    echo '    gh() { rtk gh "$@"; }' >> /etc/bash.bashrc && \
    echo 'fi' >> /etc/bash.bashrc

FROM ghcr.io/openhands/agent-canvas:latest

USER root

# Install dependencies required by install script
RUN apt-get update && apt-get install -y curl build-essential ca-certificates && rm -rf /var/lib/apt/lists/*

# Official Quick Install for RTK (Rust Token Killer)
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

ENV PATH="/root/.local/bin:${PATH}"

# Initialize RTK globally
RUN rtk init -g || true

# Ensure PATH and rtk initialization persist across bash sessions
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> /etc/bash.bashrc && \
    echo 'if command -v rtk >/dev/null 2>&1; then rtk init -g || true; fi' >> /etc/bash.bashrc

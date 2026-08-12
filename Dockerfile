FROM ghcr.io/openhands/agent-canvas:latest

USER root

# Install Node.js npm packages for RTK (Rust Token Killer) token optimization proxy
RUN npm install -g @polyskill/rtk-ai.rtk openrtk @capyup/pi-rtk || true

# Configure shell to initialize rtk token killer on startup if available
RUN echo 'if command -v rtk >/dev/null 2>&1; then eval "$(rtk init bash)"; fi' >> /etc/bash.bashrc || true

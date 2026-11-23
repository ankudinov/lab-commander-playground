FROM node:24-bookworm AS quarto-build

RUN git clone --depth 1 --single-branch --branch feat/1242-preview-command-links \
    https://github.com/ankudinov/quarto.git /src/quarto
WORKDIR /src/quarto
RUN git rev-parse HEAD > /tmp/quarto-revision
RUN npm install --global npm@11.19.0 && npm ci
# vsce's prepublish hook builds the extension and its workspace dependencies.
RUN cd apps/vscode && npx --no vsce package --out /tmp/quarto.vsix

FROM ghcr.io/aristanetworks/aclabs/lab-base:python3.12-avd-v6.5.0-clab0.83.0-rev2.7.3

ARG USERNAME=avd
USER root
ARG QUARTO_CLI_VERSION=1.11.9
RUN arch="$(dpkg --print-architecture)" && \
    curl -fsSL --retry 3 \
      "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_CLI_VERSION}/quarto-${QUARTO_CLI_VERSION}-linux-${arch}.tar.gz" \
      -o /tmp/quarto.tar.gz && \
    mkdir -p /opt/quarto && \
    tar -xzf /tmp/quarto.tar.gz -C /opt/quarto --strip-components=1 && \
    ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto && \
    rm /tmp/quarto.tar.gz && \
    quarto --version

COPY --from=quarto-build /tmp/quarto.vsix /tmp/quarto-revision /usr/local/share/quarto-extension/

# add global workspace settings for code-server
COPY ./settings.json /home/${USERNAME}/.local/share/code-server/User
RUN chown ${USERNAME} /home/${USERNAME}/.local/share/code-server/User/settings.json

USER ${USERNAME}
RUN code-server --install-extension /usr/local/share/quarto-extension/quarto.vsix --force && \
    code-server --extensions-dir /home/${USERNAME}/.vscode-server/extensions \
      --install-extension /usr/local/share/quarto-extension/quarto.vsix --force

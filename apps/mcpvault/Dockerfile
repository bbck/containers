# syntax=docker/dockerfile:1

FROM ghcr.io/sparfenyuk/mcp-proxy:v0.12.0@sha256:ce037447191eeed517faa80640539dedaffb79a3ec107bfd23625a4438b0d06d
ARG VERSION

# Alpine 3.23 ships Node 24; npm is only needed for the install
RUN apk add --no-cache nodejs \
    && apk add --no-cache --virtual .build-deps npm \
    && npm install -g --omit=dev --no-fund --no-audit "@bitbonsai/mcpvault@${VERSION}" \
    && npm cache clean --force \
    && apk del .build-deps \
    && mcpvault --version

USER nobody:nogroup
ENTRYPOINT ["catatonit", "--", "mcp-proxy"]

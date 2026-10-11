# syntax=docker/dockerfile:1

FROM ghcr.io/sparfenyuk/mcp-proxy:v0.13.0@sha256:060ab76d1125f1539de6533e95f63ba7853b141c945099f235e71acd416b86e2
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

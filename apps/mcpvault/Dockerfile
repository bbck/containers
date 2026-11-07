# syntax=docker/dockerfile:1

FROM ghcr.io/sparfenyuk/mcp-proxy:v0.14.0@sha256:35060bda497548221495a92dce855cc213790dc57370468531ae52b6dc18c741
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

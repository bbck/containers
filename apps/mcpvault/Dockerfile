# syntax=docker/dockerfile:1

FROM ghcr.io/sparfenyuk/mcp-proxy:v0.15.0@sha256:ecbe838e41b3bbfaccc009b234d34bc285b8bf4479d143454e5a35cf41f646b2
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

# syntax=docker/dockerfile:1

# Node 24: better-sqlite3 (an obsidian-headless dependency) ships musl prebuilds for this ABI
FROM docker.io/library/node:24-alpine
ARG VERSION

# coreutils: GNU date parses the ISO timestamps that sync-healthcheck reads from sync.log
RUN apk add --no-cache coreutils \
    && npm install -g --omit=dev --no-fund --no-audit "obsidian-headless@${VERSION}" \
    && npm cache clean --force \
    && ob --version

COPY --chmod=755 sync-healthcheck.sh /usr/local/bin/sync-healthcheck

USER nobody:nogroup
ENTRYPOINT ["ob"]

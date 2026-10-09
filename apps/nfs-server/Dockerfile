# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
ARG VERSION

RUN apk add --no-cache \
        bash \
        nfs-utils=="${VERSION}"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Runs as root in a privileged container: it mounts nfsd and rpc_pipefs
ENTRYPOINT ["/entrypoint.sh"]

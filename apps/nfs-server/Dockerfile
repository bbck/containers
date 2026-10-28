# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
ARG VERSION

RUN apk add --no-cache \
        bash \
        nfs-utils=="${VERSION}"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Runs as root in a privileged container: it mounts nfsd and rpc_pipefs
ENTRYPOINT ["/entrypoint.sh"]

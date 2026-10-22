# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24@sha256:c6b073f8e9e58d881f6ffba6ebf3b9ebd60b9e7d6e8337018c0e68bb5c356873
ARG VERSION

RUN apk add --no-cache \
        bash \
        nfs-utils=="${VERSION}"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Runs as root in a privileged container: it mounts nfsd and rpc_pipefs
ENTRYPOINT ["/entrypoint.sh"]

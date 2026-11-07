# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a
ARG VERSION

RUN apk add --no-cache \
        bash \
        nfs-utils=="${VERSION}"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Runs as root in a privileged container: it mounts nfsd and rpc_pipefs
ENTRYPOINT ["/entrypoint.sh"]

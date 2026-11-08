# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf
ARG VERSION

RUN apk add --no-cache \
        bash \
        nfs-utils=="${VERSION}"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Runs as root in a privileged container: it mounts nfsd and rpc_pipefs
ENTRYPOINT ["/entrypoint.sh"]

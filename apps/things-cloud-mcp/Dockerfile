# syntax=docker/dockerfile:1

FROM golang:1.27-alpine3.24@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS build
ARG VERSION
ENV CGO_ENABLED=0 \
    GOTOOLCHAIN=local

WORKDIR /src
ADD https://github.com/wbopan/things-cloud-mcp.git#${VERSION} .
RUN go build -trimpath -ldflags="-s -w" -o /things-mcp .

FROM alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

# OAuth state and the generated credential key live in DATA_DIR
RUN apk add --no-cache ca-certificates \
    && mkdir -p /data \
    && chown nobody:nogroup /data

COPY --from=build /things-mcp /usr/local/bin/things-mcp

ENV PORT=8080 \
    DATA_DIR=/data

USER nobody:nogroup
EXPOSE 8080
ENTRYPOINT ["things-mcp"]

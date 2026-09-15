# syntax=docker/dockerfile:1

FROM golang:1.27-alpine3.24@sha256:cf6fca6641884b8433441b2b0652976f975e1d0fdd26d177eaaf8596087f3125 AS build
ARG VERSION
ENV CGO_ENABLED=0 \
    GOTOOLCHAIN=local

WORKDIR /src
ADD https://github.com/wbopan/things-cloud-mcp.git#${VERSION} .
RUN go build -trimpath -ldflags="-s -w" -o /things-mcp .

FROM alpine:3.24@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

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

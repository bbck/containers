# Containers

Personal container images, modelled on [home-operations/containers](https://github.com/home-operations/containers).

Each app lives in `apps/<app>/` with a `Dockerfile`, a `docker-bake.hcl` and a `container_test.go`. The bake file's `VERSION` carries a Renovate annotation: a new upstream release opens a PR, CI builds and tests it, and Renovate auto-merges it, which publishes the image.

## Images

| Image | Upstream |
| --- | --- |
| `ghcr.io/bbck/mcpvault` | [MCPVault](https://www.npmjs.com/package/@bitbonsai/mcpvault) behind [mcp-proxy](https://github.com/sparfenyuk/mcp-proxy) |
| `ghcr.io/bbck/obsidian-headless` | [obsidian-headless](https://www.npmjs.com/package/obsidian-headless) |
| `ghcr.io/bbck/things-cloud-mcp` | [Things Cloud MCP](https://github.com/wbopan/things-cloud-mcp) |

## Tags

- `<version>`: upstream version, published from `master`
- `rolling`: latest build from `master`

Tags are mutable; pin by digest (`<version>@sha256:...`). Images are built for `linux/amd64` and `linux/arm64` and carry a build provenance attestation:

```sh
gh attestation verify --repo bbck/containers oci://ghcr.io/bbck/${APP}:${TAG}
```

## Local build

```sh
mise run local-build <app>
```

target "docker-metadata-action" {}

variable "APP" {
  default = "things-cloud-mcp"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=wbopan/things-cloud-mcp
  default = "v1.4.4"
}

variable "SOURCE" {
  default = "https://github.com/wbopan/things-cloud-mcp"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

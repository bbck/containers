target "docker-metadata-action" {}

variable "APP" {
  default = "mcpvault"
}

variable "VERSION" {
  // renovate: datasource=npm depName=@bitbonsai/mcpvault
  default = "0.16.0"
}

variable "SOURCE" {
  default = "https://github.com/bitbonsai/mcpvault"
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

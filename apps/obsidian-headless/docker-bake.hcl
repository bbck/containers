target "docker-metadata-action" {}

variable "APP" {
  default = "obsidian-headless"
}

variable "VERSION" {
  // renovate: datasource=npm depName=obsidian-headless
  default = "0.0.14"
}

variable "SOURCE" {
  default = "https://github.com/obsidianmd/obsidian-headless"
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

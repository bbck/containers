target "docker-metadata-action" {}

variable "APP" {
  default = "nfs-server"
}

variable "VERSION" {
  // renovate: datasource=repology depName=alpine_3_24/nfs-utils versioning=apk
  default = "2.6.4-r6"
}

variable "SOURCE" {
  default = "https://git.linux-nfs.org/?p=steved/nfs-utils.git"
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

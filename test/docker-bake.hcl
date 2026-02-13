# Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["github-builder:local"]
}

group "default" {
  targets = ["hello-cross"]
}

group "grp" {
  targets = ["go", "hello"]
}

variable "XX_VERSION" {
  default = null
}

target "go" {
  inherits = ["docker-metadata-action"]
  args = {
    XX_VERSION = XX_VERSION
  }
  dockerfile = "go.Dockerfile"
}

target "go-cross" {
  inherits = ["go"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "hello" {
  inherits = ["docker-metadata-action"]
  dockerfile = "hello.Dockerfile"
}

target "hello-cross" {
  inherits = ["hello"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "go-cross-with-contexts" {
  inherits = ["go-cross"]
  contexts = {
    gen = "target:generated-files"
  }
}

target "generated-files" {
  contexts = {
    generated-hello1 = "target:generated-hello1"
    generated-hello2 = "target:generated-hello2"
  }
  dockerfile-inline = <<-EOT
  FROM scratch AS generated-files
  COPY --from=generated-hello1 / /hello1
  COPY --from=generated-hello2 / /hello2
  EOT
  output = ["type=cacheonly"]
}

target "generated-hello1" {
  dockerfile = "hello.Dockerfile"
  output = ["type=cacheonly"]
}

target "generated-hello2" {
  dockerfile = "hello.Dockerfile"
  output = ["type=cacheonly"]
}

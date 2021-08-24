project = "go"

variable "image" {
  default     = "192.168.0.158:5000/go"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "tag" {
  default     = "latest"
  type        = string
  description = "Image tag for the image"
}

app "go" {
  build {
    use "pack" {}

    registry {
      use "docker" {
        image = var.image
        tag = var.tag
        insecure = true
      }
    }
  }

  deploy {
    use "docker" {}
  }
}

project = "go-gitops"

variable "image" {
  default     = "bcain.jfrog.io/default-docker-virtual/go"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "tag" {
  default     = "latest"
  type        = string
  description = "Image tag for the image"
}

variable "registry_username" {
  default     = ""
  type        = string
  description = "username for container registry"
}

variable "registry_password" {
  default     = ""
  type        = string
  description = "password for registry" // don't hack me plz
}

app "go" {
  build {
    use "pack" {}

    registry {
      use "docker" {
        image    = var.image
        tag      = var.tag
        username = var.registry_username
        password = var.registry_password
        local    = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path   = "/"
      image_secret = "regcred"
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 3000
    }
  }
}

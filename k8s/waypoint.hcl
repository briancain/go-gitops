project = "go-gitops-0"

variable "image" {
  # free tier, old container registry
  #default     = "bcain.jfrog.io/default-docker-virtual/go"
  default     = "team-waypoint-dev-docker-local.artifactory.hashicorp.engineering/go"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "tag" {
  #default     = "latest"
  default = dynamic("kubernetes", {
    name = "my-tag"
    key  = "tag"
  })
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

variable "regcred_secret" {
  default     = "regcred"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
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
      image_secret = var.regcred_secret
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 3000
    }
  }
}

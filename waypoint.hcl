project = "go"

app "go" {
  build {
    use "pack" {}

    registry {
      use "docker" {
        image = "host.docker.internal:5000/go"
        tag = "latest"
      }
    }
  }

  deploy {
    use "docker" {}
  }
}

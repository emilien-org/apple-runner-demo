terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone            = "fr-par-1"
}

resource "scaleway_apple_silicon_runner" "main" {
  name       = "my-github-runner"
  ci_provider   = "github"
  url        = "https://github.com/emilien-org"
  token      = "PASTE_THE_TOKEN"
}

data "scaleway_apple_silicon_os" "by_name" {
  name = "devos-sequoia-15.6"
}

resource scaleway_apple_silicon_server main {
  name = "TestAccServerRunner"
  type = "M2-L"
  public_bandwidth = 1000000000
  os_id = data.scaleway_apple_silicon_os.by_name.id
  runner_ids = [scaleway_apple_silicon_runner.main.id]
}

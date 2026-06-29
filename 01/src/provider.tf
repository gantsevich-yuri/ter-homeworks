terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.213.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "4.5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
  required_version = "~>1.15.0"
}

provider "yandex" {
  token     = var.TOKEN
  cloud_id  = var.CLOUD_ID
  folder_id = var.FOLDER_ID
}

provider "docker" {
  host     = "ssh://user@remote-host:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-i", "~/.ssh/ubuntu-home.pub"]
}

provider "random" {}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  token     = var.token
  cloud_id  = "b1gp4sla283e30t0hlep"
  folder_id = "b1g993vs956e0rfvt5bf"
  zone      = "ru-central1-a"
}


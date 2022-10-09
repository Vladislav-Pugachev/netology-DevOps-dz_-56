resource "yandex_compute_instance" "master1" {
  name                      = "master1"
  zone                      = "ru-central1-a"
  hostname                  = "master1.netology.kub"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd81hgrcv6lsnkremf32"
      name        = "master1-node"
      type        = "network-nvme"
      size        = "50"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "vlad:${file("./ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "worker1" {
  name                      = "worker1"
  zone                      = "ru-central1-a"
  hostname                  = "worker1.netology.kub"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd81hgrcv6lsnkremf32"
      name        = "worker1-node01"
      type        = "network-nvme"
      size        = "50"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "vlad:${file("./ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "worker2" {
  name                      = "worker2"
  zone                      = "ru-central1-a"
  hostname                  = "worker2.netology.kub"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd81hgrcv6lsnkremf32"
      name        = "worker2-node02"
      type        = "network-nvme"
      size        = "50"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "vlad:${file("./ssh/id_rsa.pub")}"
  }
}


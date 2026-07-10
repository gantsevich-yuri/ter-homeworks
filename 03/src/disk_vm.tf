resource "yandex_compute_disk" "my_disk" {
  count = 3
  name  = "disk-${count.index + 1}"
  type  = "network-hdd"
  size  = 1
  zone  = "ru-central1-a"
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  hostname    = "storage"
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.my_disk

    content {
      disk_id = secondary_disk.value.id
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadata.data.serial-port-enable
    ssh-keys           = var.metadata.data.ssh-keys
  }
}
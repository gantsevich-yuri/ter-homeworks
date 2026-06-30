resource "yandex_compute_instance" "vm" {
  boot_disk {
    initialize_params {
      name       = "disk-ubuntu-24-04-lts-1782756641407"
      type       = "network-hdd"
      size       = 10
      block_size = 4096
      image_id   = "fd8cggscje6e68lhhh80"
    }
    auto_delete = true
  }
  description        = "vm"
  folder_id          = var.FOLDER_ID
  hostname           = "vm"
  metadata = {
    user-data = "#cloud-config\ndatasource:\n Ec2:\n  strict_id: false\nssh_pwauth: no\nusers:\n- name: fox\n  sudo: ALL=(ALL) NOPASSWD:ALL\n  shell: /bin/bash\n  ssh_authorized_keys:\n  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+LINF5+lUAJf+X7ZAvaA05GqycrX2mbYB+W0g/QdKS yuri@yuri-VMware-Virtual-Platform"
    ssh-keys  = "${var.user}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+LINF5+lUAJf+X7ZAvaA05GqycrX2mbYB+W0g/QdKS yuri@yuri-VMware-Virtual-Platform"
  }
  name = "vm"
  network_interface {
    subnet_id = "e9bgrij864elca53ojvs"
    index     = 0
    nat       = true
  }
  platform_id = "standard-v3"
  resources {
    memory        = 1
    cores         = 2
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  zone = "ru-central1-a"
}

resource "docker_image" "db" {
  name = "mysql:8"
}

resource "docker_container" "db" {
  name  = "db_mysql"
  image = docker_image.db.image_id
  ports {
    internal = 3306
    ip = "127.0.0.1"
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.user_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}

resource "random_password" "user_password" {
  length           = 10
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "root_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
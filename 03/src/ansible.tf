locals {
  webservers = [
    for vm in yandex_compute_instance.web :
    {
      name              = vm.name
      hostname          = vm.hostname
      network_interface = vm.network_interface
    }
  ]

  databases = [
    for vm in yandex_compute_instance.db :
    {
      name              = vm.name
      hostname          = vm.hostname
      network_interface = vm.network_interface
    }
  ]

  storage = flatten([
    for vm in [yandex_compute_instance.storage] :
    {
      name              = vm.name
      hostname          = vm.hostname
      network_interface = vm.network_interface
    }
  ])
}

resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })

  filename = "${abspath(path.module)}/hosts.ini"

  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage
  ]
}
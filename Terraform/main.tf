terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
  }
}

backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    region     = "ru-central1-a"
    key        = "Terraform/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

resource "yandex_storage_bucket" "netology" {
     access_key = var.access_key
     secret_key = var.secret_key
    bucket = "netology1"
}


provider "yandex" {
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  service_account_key_file = "./key.json"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "jump" {
  name        = "jump"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "jump"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-1" {
  name = "nginx"
  zone                      = "ru-central1-a"
  hostname                  = "nginx"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "db01"
  zone                      = "ru-central1-a"
  hostname                  = "db01"
  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address     = "192.168.10.25"
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-3" {
  name = "db02"
  zone                      = "ru-central1-a"
  hostname                  = "db02"
  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    ip_address     = "192.168.10.34"
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-4" {
  name = "app"
  zone                      = "ru-central1-a"
  hostname                  = "app"
  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-5" {
  name = "gitlab"
  zone                      = "ru-central1-a"
  hostname                  = "gitlab"
  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
      size = 10
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-6" {
  name = "runner"
  zone                      = "ru-central1-a"
  hostname                  = "runner"
  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
      size = 10
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-7" {
  name = "monitoring"
  zone                      = "ru-central1-a"
  hostname                  = "monitoring"
  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ciuqfa001h8s9sa7i"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_dns_zone" "zone1" {
  name        = "medvedtsev"
  description = "medved"

labels = {
    label1 = "medvedtsevru"
  }

  zone             = "medvedtsev.ru."
  public           = true
  private_networks = [yandex_vpc_network.network-1.id]
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "medvedtsev.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vm-1.network_interface.0.nat_ip_address]
  }

resource "yandex_dns_recordset" "rs2" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "www.medvedtsev.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vm-1.network_interface.0.nat_ip_address]
  }

resource "yandex_dns_recordset" "rs3" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "gitlab.medvedtsev.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vm-1.network_interface.0.nat_ip_address]
  }

resource "yandex_dns_recordset" "rs4" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "grafana.medvedtsev.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vm-1.network_interface.0.nat_ip_address]
  }

resource "yandex_dns_recordset" "rs5" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "prometheus.medvedtsev.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vm-1.network_interface.0.nat_ip_address]
  }

resource "yandex_dns_recordset" "rs6" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "alertmanager.medvedtsev.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.vm-1.network_interface.0.nat_ip_address]
  }

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
# route_table_id = yandex_vpc_route_table.nat-route.id
}

# resource "yandex_vpc_gateway" "nat-gateway" {
  # name = "nat-gateway"
  # shared_egress_gateway {}
# }

# resource "yandex_vpc_route_table" "nat-route" {
  # network_id = yandex_vpc_network.network-1.id
  # name       = "nat-route"
  # static_route {
    # destination_prefix = "0.0.0.0/0"
    # gateway_id         = yandex_vpc_gateway.nat-gateway.id
  # }
# }

output "jump_host_ip" {
  value = yandex_compute_instance.jump.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.ip_address
}

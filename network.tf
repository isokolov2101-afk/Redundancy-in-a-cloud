#создаем облачную сеть
resource "yandex_vpc_network" "vpc1" {
  name = "vpc1"
}

#создаем подсеть 
resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  network_id     = yandex_vpc_network.vpc1.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.rt1.id
}

#создаем NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

#создаем сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt1" {
  name       = "rt1"
  network_id = yandex_vpc_network.vpc1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}

#создаем группы безопасности(firewall)

resource "yandex_vpc_security_group" "ssh-sg" {
  name       = "ssh-sg"
  network_id = yandex_vpc_network.vpc1.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}


resource "yandex_vpc_security_group" "LAN-sg" {
  name       = "LAN-sg"
  network_id = yandex_vpc_network.vpc1.id
  ingress {
    description    = "Allow 10.0.0.0/8"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "web-sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.vpc1.id


  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


}

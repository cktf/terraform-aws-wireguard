resource "wireguard_asymmetric_key" "server" {}

resource "wireguard_asymmetric_key" "peers" {
  count = length(var.peers)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  instance_type          = var.type
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = var.zone
  tags                   = merge(var.tags, { name = var.name })
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = templatefile("${path.module}/templates/create.sh", {
    private_key = wireguard_asymmetric_key.server.private_key
    peers = [for idx, val in var.peers : {
      name       = val
      public_key = wireguard_asymmetric_key.peers[idx].public_key
    }]
  })
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
}
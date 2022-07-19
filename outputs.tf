output "configs" {
  value = { for idx, val in var.peers : val => templatefile("${path.module}/templates/peer.conf", {
    private_key       = wireguard_asymmetric_key.peers[idx].private_key
    private_idx       = idx
    server_public_key = wireguard_asymmetric_key.server.public_key
    server_public_ip  = aws_eip.this.public_ip
  }) }
  sensitive   = false
  description = "Wireguard Configs"
}

variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Wireguard Name"
}

variable "type" {
  type        = string
  default     = "t4g.nano"
  sensitive   = false
  description = "Wireguard Type"
}

variable "zone" {
  type        = string
  default     = "us-east-1a"
  sensitive   = false
  description = "Wireguard Zone"
}

variable "tags" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Wireguard Tags"
}

variable "peers" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "Wireguard Peers"
}

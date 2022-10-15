variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
  default     = "enter your folder id"
}

variable "cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
  default     = "there is cloud id"
}

variable "password" {
  type = string
}

variable "user" {
  type = string
  default = "ubuntu"
}

variable "private_key_path" {
  description = "Path to ssh private key, which would be used to access workers"
  default     = "~/.ssh/id_rsa"
}

variable "access_key" {
  default     = "access_key"
}

variable "secret_key" {
  default     = "secret_key"
}


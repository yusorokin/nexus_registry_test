variable "project" {
  description = "Project ID"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "ubuntu-1804-bionic-v20190628"
}

variable "zone" {
  description = "Instance zone"
  default     = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "db_url" {
  description = "MongoDB server URL"
  default     = "reddit-db:27017"
}

variable "do_provision" {
  description = "If true then provisioning will go on"
  default     = true
}


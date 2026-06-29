variable "TOKEN" {
  type      = string
  sensitive = true
}

variable "CLOUD_ID" {
  type      = string
  sensitive = true
}

variable "FOLDER_ID" {
  type      = string
  sensitive = true
}

variable "user" {
  type    = string
  default = "fox"
}
variable "flow" {
  type    = string
  default = "ks-hw"
}

variable "cloud_id" {
  type    = string
  default = "b1gmh3kc59it6nbtrrsg"
}
variable "folder_id" {
  type    = string
  default = "b1gj6qi40lfe5a81mgau"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

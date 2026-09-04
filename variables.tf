variable "cloud_id" {
  type    = string
  default = "b1gu9ae0pqhvvtu8bldf"
}
variable "folder_id" {
  type    = string
  default = "b1gjqtgs5dhs9shogrde"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}


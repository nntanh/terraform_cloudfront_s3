variable "object_ownership" {
  type = string
}

variable "bucket" {
  type = list(string)
}

variable "html" {
  type = map(object({
    bucket_name = string
    folder_name = string
  }))
}

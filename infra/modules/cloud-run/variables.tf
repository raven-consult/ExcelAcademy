
variable "name" {
  description = "App's name"
}

variable "location" {
  description = "Service location"
  default     = "us-central1"
}

variable "cpu_size" {
  description = "container cpu category"
  default     = "small"
}

variable "mem_size" {
  description = "container memory category"
  default     = "small"
}

variable "http2" {
  type        = bool
  description = "http2"
}

variable "max_instances" {
  type        = number
  description = "Max number of instances"
  default     = 5
}

variable "private_vpc_access" {
  type        = bool
  description = "Should the service have access to private VPCs"
  default     = false
}

variable "always_on" {
  type        = bool
  description = "Make container have at least one instance running"
  default     = false
}

variable "port" {
  type        = string
  description = ""
}

variable "image" {
  description = "Container image"
}

variable "envs" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

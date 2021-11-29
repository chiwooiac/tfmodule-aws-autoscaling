variable "context" {
  type = object({
    name_prefix  = string # resource name prefix
    tags         = object({
      Project     = string
      Environment = string
      Team        = string
      Owner       = string
    })
  })
}


variable "lt_version" {
  type = string
  default = null
}
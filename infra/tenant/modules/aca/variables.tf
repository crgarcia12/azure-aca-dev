################################
#         Generics
################################

variable "prefix" {
  description = "prefix"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}

variable "resource_group_name" {
  description = "RG Name"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "log_analytics_workspace_id"
  type        = string
}

variable "image_name" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "tenant_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "acr_identity_id" {
  type = string
}

variable "acr_host_name" {
  type = string
}


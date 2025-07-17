variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "recovery_services_vault_resource_id" {
  type        = string
  description = "The resource id of recovery services vault to associate the resource guard with."
  nullable    = false
}

variable "resource_guard_resource_id" {
  type        = string
  description = "The resource id of the resource guard."
  nullable    = false
}

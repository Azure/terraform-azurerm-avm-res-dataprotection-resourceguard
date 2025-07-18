output "resource_guard_resource_id" {
  description = "The resource id of the resource guard."
  value       = var.resource_guard_resource_id
}

output "resource_id" {
  description = "The resource id for the association resource."
  value       = azapi_resource.recovery_services_vault_association.id
}

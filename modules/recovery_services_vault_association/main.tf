resource "azapi_resource" "recovery_services_vault_association" {
  location  = var.location
  name      = "VaultProxy" # Resource guard proxy cannot be created with any name other than the default name, `VaultProxy`.
  parent_id = var.recovery_services_vault_resource_id
  type      = "Microsoft.RecoveryServices/vaults/backupResourceGuardProxies@2025-02-01"
  body = {
    properties = {
      resourceGuardResourceId = var.resource_guard_resource_id
    }
  }
}

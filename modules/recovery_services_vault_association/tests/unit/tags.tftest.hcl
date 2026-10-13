mock_provider "azapi" {}

variables {
  location                            = "southeastasia"
  recovery_services_vault_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vault-test/providers/Microsoft.RecoveryServices/vaults/vault-test"
  resource_guard_resource_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/guard-test/providers/Microsoft.DataProtection/resourceGuards/guard-test"
}

run "default_tags" {
  command = apply
  providers = {
    azapi = azapi
  }

  assert {
    condition     = var.tags == null && !contains(keys(azapi_resource.recovery_services_vault_association.body), "tags")
    error_message = "Existing direct callers may omit tags."
  }
}

run "empty_tags" {
  command = apply
  providers = {
    azapi = azapi
  }

  variables {
    tags = {}
  }

  assert {
    condition     = azapi_resource.recovery_services_vault_association.tags != null && length(azapi_resource.recovery_services_vault_association.tags) == 0
    error_message = "An empty tags map must stay empty."
  }
}

run "association_tags" {
  command = apply
  providers = {
    azapi = azapi
  }

  variables {
    tags = {
      scenario = "Regression"
      owner    = "AVM"
    }
  }

  assert {
    condition     = azapi_resource.recovery_services_vault_association.tags == var.tags
    error_message = "Association tags must use the AzAPI top-level argument."
  }

  assert {
    condition     = azapi_resource.recovery_services_vault_association.name == "VaultProxy" && azapi_resource.recovery_services_vault_association.parent_id == var.recovery_services_vault_resource_id && azapi_resource.recovery_services_vault_association.body.properties.resourceGuardResourceId == var.resource_guard_resource_id
    error_message = "The fixed proxy name, vault parent and guard binding must be preserved."
  }
}

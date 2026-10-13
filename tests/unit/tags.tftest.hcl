mock_provider "azapi" {}
mock_provider "azurerm" {}
mock_provider "modtm" {}
mock_provider "random" {}

variables {
  location          = "southeastasia"
  name              = "guard-test"
  resource_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/guard-test"
}

run "default_tags" {
  command = apply
  providers = {
    azapi   = azapi
    azurerm = azurerm
    modtm   = modtm
    random  = random
  }

  assert {
    condition     = var.tags == null && !contains(keys(azapi_resource.resource_guard.body), "tags")
    error_message = "Omitted tags must keep the null input default without a body override."
  }
}

run "empty_tags" {
  command = apply
  providers = {
    azapi   = azapi
    azurerm = azurerm
    modtm   = modtm
    random  = random
  }

  variables {
    tags = {}
  }

  assert {
    condition     = azapi_resource.resource_guard.tags != null && length(azapi_resource.resource_guard.tags) == 0
    error_message = "An empty tags map must stay empty."
  }
}

run "tags_and_existing_scopes" {
  command = apply
  providers = {
    azapi   = azapi
    azurerm = azurerm
    modtm   = modtm
    random  = random
  }

  variables {
    tags = {
      scenario = "Regression"
      owner    = "AVM"
    }
    lock = {
      kind = "CanNotDelete"
    }
    role_assignments = {
      reader = {
        principal_id               = "00000000-0000-0000-0000-000000000001"
        role_definition_id_or_name = "Reader"
      }
    }
    recovery_servies_vault_associations = {
      vault = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vault-test/providers/Microsoft.RecoveryServices/vaults/vault-test"
      }
    }
    vault_critical_operation_exclusion_list = [
      "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems/delete"
    ]
  }

  assert {
    condition     = azapi_resource.resource_guard.tags == var.tags
    error_message = "Tags must use the AzAPI top-level argument."
  }

  assert {
    condition     = azapi_resource.resource_guard.location == var.location && !contains(keys(azapi_resource.resource_guard.body), "location") && !contains(keys(azapi_resource.resource_guard.body), "tags")
    error_message = "Location and tags must not be duplicated in the body."
  }

  assert {
    condition     = toset(azapi_resource.resource_guard.body.properties.vaultCriticalOperationExclusionList) == var.vault_critical_operation_exclusion_list
    error_message = "Critical operation exclusions must be preserved."
  }

  assert {
    condition     = azurerm_management_lock.this[0].scope == var.resource_group_id && azurerm_role_assignment.this["reader"].scope == var.resource_group_id
    error_message = "This correction must not change lock or role-assignment scope."
  }

  assert {
    condition     = module.recovery_services_vault_associations["vault"].resource_guard_resource_id == output.resource_id
    error_message = "The association must still reference the deployed guard."
  }
}

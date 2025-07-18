locals {
  location = "southeastasia"
  name     = "fixresourceguard"
  tags = {
    scenario = "Default"
    project  = "AVM"
    delete   = "yes"
  }
  vault_critical_operation_exclusion_list = [
    "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems/delete"
  ]
}

resource "azurerm_resource_group" "avmrg" {
  location = local.location
  name     = "avmrg"
}

resource "azurerm_recovery_services_vault" "rsv" {
  location            = local.location
  name                = "example-recovery-vault"
  resource_group_name = azurerm_resource_group.avmrg.name
  sku                 = "Standard"
}

module "resource_guard" {
  source = "../../"

  location          = local.location
  name              = local.name
  resource_group_id = azurerm_resource_group.avmrg.id
  recovery_servies_vault_associations = {
    assoc1 = {
      resource_id = azurerm_recovery_services_vault.rsv.id
    }
  }
  tags                                    = local.tags
  vault_critical_operation_exclusion_list = local.vault_critical_operation_exclusion_list
}

terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  #subscription_id = "09d7d81e-6d46-407a-82be-1b80d1e861d6"
  # resource_provider_registrations = "all"
}

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

module "default" {
  source                                  = "../../"
  name                                    = local.name
  location                                = local.location
  vault_critical_operation_exclusion_list = local.vault_critical_operation_exclusion_list
  resource_group_id                       = azurerm_resource_group.avmrg.id
  tags                                    = local.tags
}

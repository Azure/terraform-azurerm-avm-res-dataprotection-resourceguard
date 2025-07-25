<!-- BEGIN_TF_DOCS -->
# Associate resource guard with a recovery services vault

This is an example that creates a resource guard and a recovery services vault and associate them together.

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.0, < 5.0)

## Resources

The following resources are used by this module:

- [azurerm_recovery_services_vault.rsv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) (resource)
- [azurerm_resource_group.avmrg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_resource_guard"></a> [resource\_guard](#module\_resource\_guard)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->
# Associate recovery services vault to resource guard module

This module is used to associate an exisiting recovery services vault to an exisiting resource guard.

## Features

This module supports associating an exisiting recovery services vault to an exisiting resource guard.

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables which are **location**, **resource_guard_resource_id** and **recovery_services_vault_resource_id**.

### Example - Associate exisiting recovery services vault to exisiting resource guard module

This example shows the most basic usage of the module. It adds SOA records to an existing private DNS zone using the for_each iteration.

```terraform

module "dns_soa_record" {
  source = "Azure/avm-res-dataprotection-resourceguard/azurerm//modules/recovery_services_vault_association"

  location                            = "southeastasia"
  resource_guard_resource_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.DataProtection/ResourceGuards/example-resource-guard"
  recovery_services_vault_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.RecoveryServices/vaults/example-recovery-vault"
}

```

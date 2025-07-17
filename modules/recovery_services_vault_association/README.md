<!-- BEGIN_TF_DOCS -->
# Associate recovery services vault to resource guard module

This module is used to associate an exisiting recovery services vault to an exisiting resource guard.

## Features

This module supports associating an exisiting recovery services vault to an exisiting resource guard.

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables which are **location**, **resource\_guard\_resource\_id** and **recovery\_services\_vault\_resource\_id**.

### Example - Associate exisiting recovery services vault to exisiting resource guard module

This example shows the most basic usage of the module. It adds SOA records to an existing private DNS zone using the for\_each iteration.

```terraform

module "dns_soa_record" {
  source = "Azure/avm-res-dataprotection-resourceguard/azurerm//modules/recovery_services_vault_association"

  location                            = "southeastasia"
  resource_guard_resource_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.DataProtection/ResourceGuards/example-resource-guard"
  recovery_services_vault_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.RecoveryServices/vaults/example-recovery-vault"
}

```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>= 1.13, < 3)

## Resources

The following resources are used by this module:

- [azapi_resource.recovery_services_vault_association](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_recovery_services_vault_resource_id"></a> [recovery\_services\_vault\_resource\_id](#input\_recovery\_services\_vault\_resource\_id)

Description: The resource id of recovery services vault to associate the resource guard with.

Type: `string`

### <a name="input_resource_guard_resource_id"></a> [resource\_guard\_resource\_id](#input\_resource\_guard\_resource\_id)

Description: The resource id of the resource guard.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_resource_guard_resource_id"></a> [resource\_guard\_resource\_id](#output\_resource\_guard\_resource\_id)

Description: The resource id of the resource guard.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->
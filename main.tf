resource "azapi_resource" "resource_guard" {
  name      = var.name
  parent_id = var.resource_group_id
  type      = "Microsoft.DataProtection/ResourceGuards@2022-05-01"
  body = {
    "location" : var.location,
    "tags" : var.tags,
    "properties" : {
      "vaultCriticalOperationExclusionList" : var.vault_critical_operation_exclusion_list
    }
  }
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  timeouts {
    create = "1h30m"
    delete = "20m"
  }
}

module "recovery_services_vault_associations" {
  source   = "./modules/recovery_services_vault_association"
  for_each = var.recovery_servies_vault_associations

  location                            = var.location
  recovery_services_vault_resource_id = each.value.resource_id
  resource_guard_resource_id          = azapi_resource.resource_guard.id
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = var.resource_group_id # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

module "avm_interfaces" {
  source  = "Azure/avm-utl-interfaces/azure"
  version = "0.2.0"

  lock = var.lock
}

resource "azapi_resource" "lock" {
  count = var.lock != null ? 1 : 0

  name           = module.avm_interfaces.lock_azapi.name != null ? module.avm_interfaces.lock_azapi.name : "lock-${azapi_resource.private_dns_zone.name}"
  parent_id      = azapi_resource.private_dns_zone.id
  type           = module.avm_interfaces.lock_azapi.type
  body           = module.avm_interfaces.lock_azapi.body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  depends_on = [time_sleep.wait_for_resource_destroy]
}


# Delay destroy to avoid race with management lock removal.
# Without this pause, Terraform attempts to delete locked resources
# immediately after the lock is deleted, causing destroy to fail.
resource "time_sleep" "wait_for_resource_destroy" {
  destroy_duration = "20s"

  depends_on = [azapi_resource.private_dns_zone]
}

# variable "backend_config" {
#     type = object({
#         resource_group_name = string
#         storage_account_name = string
#         container_name       = string
#         key                  = string
#     })

#     default = {
#         resource_group_name = "backendResourceGroup"
#         storage_account_name = "backendStorageAccount"
#         container_name       = "backendContainer"
#         key                  = "backend.tfstate"
#     }
# }

variable "client_id" {
  description = "The ID of the Azure Client"
  type        = string
}

variable "client_secret" {
  description = "client_secret of Azure Client"
  type        = string
}

variable "tenant_id" {
  description = "tenant_id of the Azure Client"
  type        = string
}

variable "subscription_id" {
  description = "subscription_id of the Azure subscription"
  type        = string
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.10.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "TerraformBackend"
    storage_account_name = "terraformpocbackend"
    container_name = "backend-container"
    key = "backendConfig.tfstate"
  }

    required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  client_id = "0dacc793-78f6-442b-832b-f6160295b19b"
  client_secret = var.client_secret
  tenant_id = "8ac76c91-e7f1-41ff-a89c-3553b2da2c17"
  subscription_id = "c4b0529f-c67d-491f-bbb4-137663eeb04c"
}

data "azurerm_client_config" "current" {}

module "ContainerApp_ResourceGroup" {
    source = "https://github.com/Ajay-Shrivastava_wkl/terraform-modules.git/Azure_Resource_Group"
    resource_group_name = "TerraformPoc-App"
    resource_group_location = "East US"
}

module "ACR_ResourceGroup" {
    depends_on = [ module.ContainerApp_ResourceGroup ]
    source = "https://github.com/Ajay-Shrivastava_wkl/terraform-modules.git/Azure_Resource_Group"
    resource_group_name = "TerraformPoc-ACR"
    resource_group_location = "East US"
}

resource "azurerm_container_registry" "acr" {
  depends_on = [ module.ACR_ResourceGroup ]
  name                     = "mycontainerregistry"
  resource_group_name      = module.ACR_ResourceGroup.resource_group_name
  location                 = module.ACR_ResourceGroup.resource_group_location
  sku                      = "Basic"
  admin_enabled            = true
}

module "ContainerApp" {
    depends_on = [ azurerm_container_registry.acr ]
    source = "https://github.com/Ajay-Shrivastava_wkl/terraform-modules.git/CONTAINER_APP"
    container_app_environment_name = "mycontainerappenv"
    environment = "dev"
    container_app_name = "mycontainerapp"
    resource_group_name = "myResourceGroup"
    location = "East US"
    revision_mode = "Single"
    DOCKER_REGISTRY_SERVER_URL = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
}
terraform {
  backend "azurerm" {
      resource_group_name  = "kamil-streamx-commerce-accelerator"
      storage_account_name = "tfstatef5i67"
      container_name       = "kamil-test"
      key                  = "terraform.tfstate"
  }
}

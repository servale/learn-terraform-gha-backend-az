# Example tfvars file for development environment
# Copy and rename to terraform.dev.tfvars, then update with your values

subscription_id = "YOUR_SUBSCRIPTION_ID"

environment  = "dev"
location     = "East US"
project_name = "myapp"

resource_group_name = "rg-myapp-dev"
storage_account_name = "storagecyapp001"

blob_container_name = "app-data"
blob_access_type    = "Private"

storage_account_tier    = "Standard"
storage_replication_type = "LRS"

application_config = {
  name    = "MyApplication"
  version = "1.0.0"
  tier    = "basic"
}

environment_variables = {
  APP_ENV          = "development"
  LOG_LEVEL        = "debug"
  API_TIMEOUT      = "30"
  DATABASE_TIMEOUT = "60"
}

tags = {
  managed_by  = "terraform"
  cost_center = "engineering"
  owner       = "platform-team"
}

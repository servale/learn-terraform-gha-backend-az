# Example shell script for setting environment variables and running Terraform
# Copy and rename to .prod.sh or .dev.sh (etc), then update with your values after creatign service principal

# set the susbcription
export ARM_SUBSCRIPTION_ID="subscription_id"

# set the service principal
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"

# set the environment
export TF_VAR_environment_name="<environment_name>"

# run terraform
terraform init
   
terraform $*

# clean up local cache
rm -rf .terraform


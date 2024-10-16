# Set environment variables for Terraform
$env:TF_VAR_resource_group_name = "crgar-aca-demo-rg"
$env:TF_VAR_location = "swedencentral"
$env:TF_VAR_container_name = "mycontainer"

# Output the variables to verify
# Iterate over all environment variables that start with TF
Get-ChildItem env:TF_VAR_* | ForEach-Object {
    Write-Output "$($_.Name): $($_.Value)"
}
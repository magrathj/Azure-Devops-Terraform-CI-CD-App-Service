# Azure-Devops-Terraform-CI-CD-App-Service
Building out an Azure CI/CD pipeline to create disposable test environments and run automated tests on a published Web App

[![Build Status](https://dev.azure.com/EnsureQualityReleases/EnsureQualityReleases/_apis/build/status/magrathj.Azure-Devops-Terraform-CI-CD-App-Service?branchName=main)](https://dev.azure.com/EnsureQualityReleases/EnsureQualityReleases/_build/latest?definitionId=1&branchName=main)

Set subscription 
```bash
    $ az account set --subscription="SUBSCRIPTION_ID" 
```

Create service principle with Contributor access 
```bash
    $ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```


Create the storage account
```bash
    $ ./cicd/terraform/terraform_configure_storage_account.sh
```
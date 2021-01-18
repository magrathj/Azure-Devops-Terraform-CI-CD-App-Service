# Azure-Devops-Terraform-CI-CD-App-Service



[![Build Status](https://dev.azure.com/EnsureQualityReleases/EnsureQualityReleases/_apis/build/status/magrathj.Azure-Devops-Terraform-CI-CD-App-Service%20(1)?branchName=main)](https://dev.azure.com/EnsureQualityReleases/EnsureQualityReleases/_build/latest?definitionId=3&branchName=main)

## Introduction

This is my submission for the 'Ensuring Quality Releases' project as part of the 'DevOps Engineer for Microsoft Azure' nanodegree program from Udacity. It contains code for an azure devops CI/CD pipeline that does the following:

    * Create a resource group and storage account in azure to store a terraform statefile.
    * Publish a package called FakeRestAPI as an artifact.
    * Build the following azure resources using terraform
    * Deploy FakeRestAPI as an azure app service.
    * Run postman/newman data validation tests against the http://dummy.restapiexample.com API (not the API created above).
    * Publish a selenium script (written in python) as an artifact.
    * Install selenium on the VM and use it to run functional tests against the https://www.saucedemo.com website (not a website I deploy here).
    * Runs JMeter endurance and load test on the App service
    * Set up email alerting for the app service (manual step in azure portal).
    * Set up custom logging in log analytics to gather selenium logs from the VM (maunal step in azure portal).



## Instructions
Create the service principal


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

Test terraform locally
```bash
    $ cd /terraform/environments/test/
    $ terraform init
```

Generate ssh token
```bash
    $ ssh-keygen -l -f ~/.ssh/id_rsa.pub
```


Create and run the pipeline

Sign in to azure devops and create a new project.

Go to Project Settings > Service Connections > New Service Connection > Azure Resource Manager > Next > Service Principal (Automatic) > Next > Subscription. Choose your subscription and give the service connection the same name as your subscription.

Create a pipeline connected to github and select this repo.

Set up email alerts

In the azure portal go to the app service > Alerts > New Alert Rule. Add an HTTP 404 condition and add a threshold value of 1. This will create an alert if there are two or more consecutive 404 alerts. Click Done. Then create an action group with notification type Email/SMS message/Push/Voice and choose the email option. Set the alert rule name and severity. Wait ten minutes for the alert to take effect. If you then visit the URL of the app service and try to go to a non-existent page more than once it should trigger the email alert.

Set up log analytics

Go to the app service > Diagnostic Settings > + Add Diagnostic Setting. Tick AppServiceHTTPLogs and Send to Log Analytics Workspace. Select a workspace (can be an existing default workspace) > Save. Go back to the app service > App Service Logs. Turn on Detailed Error Messages and Failed Request Tracing > Save. Restart the app service.

Go to the log analytics workspace > Logs. Run the following query:

Operation
| where TimeGenerated > ago(2h)
| summarize count() by TimeGenerated, OperationStatus, Detail

This should show some log results (though it may take an hour or so before they appear).

Set up custom logging

In the log analytics workspace go to Advanced Settings > Data > Custom Logs > Add + > Choose File. Select the file selenium.log > Next > Next. Put in the following paths as type Linux:

    /var/log/selenium/selenium.log
    /var/log/selenium
    /var/log/selenium/*.log

Give it a name and click Done. Tick the box Apply below configuration to my linux machines.

Go back to the log analytics workspace > Virtual Machines. Click your VM > Connect. This will install the agent on the VM, allowing azure to collect logs from it.

Go back to the log analytics workspace > Logs. From the Custom Logs dropdown double-click the custom log just created and run the query. You should see the selenium logs. However, the agent might only collect logs if the timestamp on the log file was updated after the agent was installed. Also, the VM might require a reboot, or you might just need to wait a while, before the logs appear.
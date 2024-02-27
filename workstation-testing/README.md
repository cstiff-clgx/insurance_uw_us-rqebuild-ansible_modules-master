## DEV and QA workstation Deployment Manual

*This is a small instruction how to easily repave, create and destroy 
dev/qa workstation using Terraform/Ansible*


### General resources you interact with
Resource Name | Resource URL | Comment
--- | --- | ---
**Jenkins Core** | https://jenkins.solutions.corelogic.com/insurance-uw-us/job/rqebuild-platform/job/nonprd/job/iac-workstation-service/job/master/ | Main tool to provision application topology, deploy application, repave VM hosts when required
**Pipeline Code** | https://github.com/corelogic/insurance_uw_us-rqebuild-iac/tree/master/workstation | Holds CI/CD code
**Pipeline Vars** | https://github.com/corelogic/insurance_uw_us-rqebuild-pipeline-iac | Holds Vars for CI/CD
**GCP Console** | https://console.cloud.google.com/compute/instances?cloudshell=false&project=clgx-rqebuild-app-dev-1898 | Used to overview application topology , see resources details like IP addresses of VMs or balancers etc

## Repaving

    For security reason, each VM should be recreated using latest OS image. 
    This procedure will be repeated each 45 days for Windows VMs and 90 days for Linux.   

* Go to **Jenkins core** 
* Select:
  * ENV (dev or uat)
  * HOST (example 'bbetov-dev')
  * TERRAFORM_COMMAND - apply
  * ANSIBLE_COMMAND - apply
* Press *Build* (It will detect the changes and recreate the VM for you) 
---
Before pushing **Proceed**, go to **Console Output** and analyze **Terraform Plan** for changes.

The **successful scenario** will mention that **only VMs are being destroyed**.

**Other scenarios include the following:**
* Error in Terraform apply. Possible reason - serious changes in Terraform modules. Solution -Destroy  VMs only using extra parameters.
* Terraform plan suggests changing modules, other than VMs. Solution - Destroy VMs only with extra parameters before Apply.
* Terraform plan shows No changes, up to date. Solution - check when the VMs were created in GCP Console. If 90 days, in case of Linux machines (or 45 days in case of Windows machines accordingly), haven't passed from the date of their creation, force Destroy job using extra parameters.

## Creating

    For creating VM for new developer or QA we need to update pipeline code
    in several places before running Jenkins job

### Precondition:
1. New item in Jenkins job dropdown list
    * Edit file - https://github.com/corelogic/insurance_uw_us-rqebuild-pipeline-iac/blob/master/vars/workstation.groovy
    * Modify **choiceParam** list in **job_parameters**
2. Creating new var file with custom parameters
    * create file (example bbetov-dev.tfvars) in this folder - https://github.com/corelogic/insurance_uw_us-rqebuild-iac/tree/master/workstation/terraform/env/dev
    * populate data there using other custom files as an example

### Creating new VM

* Go to **Jenkins core** 
* Select:
  * ENV (dev or uat)
  * HOST (example 'bbetov-dev')
  * TERRAFORM_COMMAND - apply
  * ANSIBLE_COMMAND - apply
* Press *Build* (It will detect the changes and recreate the VM for you) 

Before pushing **Proceed**, go to **Console Output** and analyze **Terraform Plan** for changes.

## Destroy

    If we need to remove useless VM or we have an issue in Terraform apply plan,
    We should destroy VM with or without attached disk

### Precondition:
if we need to leave attached disk - we should use **TERRAFORM_EXTRA_ARGS** field

### Destroying VM

* Go to **Jenkins core** 
* Select:
  * ENV (dev or uat)
  * HOST (example 'bbetov-dev')
  * TERRAFORM_COMMAND - destroy
  * TERRAFORM_EXTRA_ARGS - '-target=module.workstation'
* Press *Build* (It will detect the changes and recreate the VM for you) 

Before pushing **Proceed**, go to **Console Output** and analyze **Terraform Plan** for changes.


# DevBoxPoC

The scope of the PoC will include
* Intial System Checks (DevBox deployment using IaC - Bicep)
* DevBox deployment manually (without IaC)

## Initial System Checks (DevBox deployment using IaC - Bicep)
For an initial system check, instead of creating all the DevBox required resources manually, let's use IaC to help create those.

The below section is inspired from this [Source](https://github.com/Azure-Samples/Devcenter). 

Go to the [Azure Portal](https://portal.azure.com/) and on the top bar, open the `Cloud Shell` (it'll prompt you to create a Storage Account if not already present) and then select `Bash`. If you prefer to use PowerShell, slight modifications are required on the below code.

### Clone the repository

    git clone https://github.com/Azure-Samples/Devcenter.git
    cd Devcenter

### Deploy the common infrastructure

    RG=devcenter
  
    #Get the deploying users id for RBAC assignments
    DEPLOYINGUSERID=$(az ad signed-in-user show --query id -o tsv)
    
    #Create resource group
    az group create -n $RG -l westeurope
    
    #Create devcenter common components
    DCNAME=$(az deployment group create -g $RG -f bicep/common.bicep -p nameseed=devbox devboxProjectUser=$DEPLOYINGUSERID --query 'properties.outputs.devcenterName.value' -o tsv)

![image](https://github.com/kcodeg123/DevBoxPoC/assets/3813135/28ef5b80-5c76-4eba-b0bb-3b8b8d3dfe9a)

### Create a Dev Box
Your Developers will access Dev Box resources through a dedicated portal; https://aka.ms/devbox-portal

### Cleanup resources

To delete multiple resource groups at the same time,  you can tag all the RGs to be deleted as `delete`.  After that, open the `Azure Cloud Shell` and run this `bash` script.

    az group list --tag delete --query [].name -o tsv | xargs -otl az group delete --no-wait  -n

Check this [tutorial](https://blog.jongallant.com/2020/05/azure-delete-multiple-resource-groups/) for more guidance if needed.

## DevBox deployment manually (without IaC)

Follow the steps [here](https://github.com/danielstocker/devboxlab) for Lab1, Lab2 & Lab3.

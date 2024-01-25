# Dev Box PoC - Scope

TBD:

**Questions**:
* What are the developer scenarios to cover? OR are there custom VM image requirements or do we build a PoC with the standard VS/Windows images only?
   * Developer Tools
   * Libraries
   * Access to products (ADO, Azure Portal, etc)

The **scope** of the PoC will include
* Intial System Checks (DevBox deployment using IaC - Bicep)
* DevBox deployment manually (without IaC)
* Test Onboarding Process for a new developer
* Monitoring

Out of scope / Topics for follow up sessions:
* VM Image Builder for creating custom VM Images

# Prerequisites

The main [prerequisites](https://learn.microsoft.com/en-us/azure/dev-box/quickstart-configure-dev-box-service#prerequisites) from an IT admin perspective will be as follows:

* **Subscription** - You need an Azure subscription
    * This can be a dev or test subscription 
* **Users** - Ensure there are **_at least_** 3 Entra ID users with the required licenses (see the following point for licenses):
    * `1 Global Admin` - **This is very important**.
        * A user with global admin rights on the **Azure** subscription (ideally with admin access to the **M365** & **Intune** Admin Portal).
        * Without a global admin who has full rights on the azure subscription, we might face additional permission issues.
        * The global admin should ideally also have access to Intune Admin Portal in case additional users need to be created and assigned E3/E5 licenses.
    * Other `2 Entra ID` users will play the role of `Tech Lead` and `Developer`.
        * We just need the Entra ID users with the following licenses assigned to them to begin. Permissions will be added by the Global Admin during the PoC.
* **Licenses** - These users must be licensed for Windows 10/11 Enterprise, Microsoft Intune and Entra ID P1/P2.
    * If you have available E3 or E5 licenses for example, then those licenses could be assigned to these users. These licenses are available independently and are included in the following subscriptions:
        * Microsoft 365 F3
        * Microsoft 365 E3, Microsoft 365 E5
        * Microsoft 365 A3, Microsoft 365 A5
        * Microsoft 365 Business Premium
        * Microsoft 365 Education Student Use Benefit
    * You don't need to create new users necessarily. If you have already have a existing users in the azure subscription that we will use, we can reuse those users.
    * I do suggest a spare license (like E3/E5) to create and assign to a new user to test the flow of how it works when a new developer joins the team.
    * Microsoft **Intune automatic enrollment** must be enabled. Check [here](https://learn.microsoft.com/en-us/mem/intune/enrollment/quickstart-setup-auto-enrollment#set-up-automatic-enrollment) for more information.
* **Networking** - If your organization routes egress traffic through a firewall, open the appropriate ports. For more information, see [Network requirements](https://learn.microsoft.com/en-us/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent).
    * If you are using an Azure Network Connection, then you can review the [Health Checks](https://learn.microsoft.com/en-us/windows-365/enterprise/health-checks) in the `ANC Resource > Overview > Status tab` to review the . More on this, when we start with the PoC.


# Initial System Checks (DevBox deployment using IaC - Bicep)

> Roles required: 1 Global Admin, 1 Developer

For an initial system check, instead of creating all the DevBox required resources manually, let's use IaC to help create those. You need to login to the Azure Portal as an administrator.

The below section is inspired from this [Source](https://github.com/Azure-Samples/Devcenter). 

Go to the [Azure Portal](https://portal.azure.com/) and on the top bar, open the `Cloud Shell` (it'll prompt you to create a Storage Account if not already present) and then select `Bash`. If you prefer to use PowerShell, slight modifications are required on the below code.

## Clone the repository

    git clone https://github.com/Azure-Samples/Devcenter.git
    cd Devcenter

## Deploy the common infrastructure

    RG=devcenter
  
    #Get the deploying users id for RBAC assignments
    DEPLOYINGUSERID=$(az ad signed-in-user show --query id -o tsv)
    
    #Create resource group
    az group create -n $RG -l westeurope
    
    #Create devcenter common components
    DCNAME=$(az deployment group create -g $RG -f bicep/common.bicep -p nameseed=devbox devboxProjectUser=$DEPLOYINGUSERID --query 'properties.outputs.devcenterName.value' -o tsv)

![image](https://github.com/kcodeg123/DevBoxPoC/assets/3813135/28ef5b80-5c76-4eba-b0bb-3b8b8d3dfe9a)

## Create a Dev Box
The Developer now must log in to the [Developer Portal](https://devportal.microsoft.com/) and perform the following steps:
* Create a new Dev Box
* Connect to the Dev Box
* Open the browser and log in to the Azure Portal
* Open VS Code and run `az login` to test the Azure CLI
* Test access to other portals like Azure DevOps

## Cleanup resources

To delete multiple resource groups at the same time,  you can tag all the RGs to be deleted as `delete`.  After that, open the `Azure Cloud Shell` and run this `bash` script.

    az group list --tag delete --query [].name -o tsv | xargs -otl az group delete --no-wait  -n

Check this [tutorial](https://blog.jongallant.com/2020/05/azure-delete-multiple-resource-groups/) for more guidance if needed.

# Scenario 1: Project Lead manages assigned Projects with Microsoft hosted Network & built-in VM Images

## IT Admin actions
* Create user on M365 admin center
* Create the Dev Center
* Create a dev box definition with built-in VM
* Create a Project
* Give Project access to the Project Lead
  * For this PoC, we will consider Owner permissions on the Project

> Decide the level of access to give to the Project Lead. For more information, check [here](https://learn.microsoft.com/en-us/azure/dev-box/how-to-manage-dev-box-projects#permissions).
> Things to consider:
> * Does the Project Lead need to create new Projects? (Requires Owner permissions on the Dev Center)
> * Does the Project Lead need to assign new developers access to the projects? (Requires Owner permissions on the Project)
> * Or is it okay if the Project Leads only create dev box pools? (Requires the minimum DevCenter Project Admin permissions)

## Project Lead actions
* Create a dev box pool
  * Choose the dev box definition created earlier
  * Choose a Microsoft hosted network
* Give Project access to a Developer

## Developer actions
* Create dev boxes
* Connect to a dev box

# Scenario 2: Project Lead manages assigned Projects with Self-hosted Network & built-in VM Images

## IT Admin actions
* Create a virtual network
* Create a network connection
* Attach the network connection to Dev Center
* Create a Dev Box definition with a built-in VM image
* Create a new Project and give access to the Project Lead

## Project Lead actions
* Create a Dev Box pool
  * Choose the dev box definition created earlier
  * Choose the self-hosted network created earlier
* Give Project access to a Developer

## Developer actions
* Create dev boxes
* Connect to a dev box

# Scenario 3: Project Lead manages assigned Projects with Self-hosted Network & custom VM Images

* Prepare a custom Dev Box image (can be automated with VM Image Builder)
* Create a Dev Box definition with a custom VM image

## Developer actions
* Create dev boxes
* Connect to a dev box

# Scenario 4: Test the onboarding experience of a new developer

* **IT Admin** to add a new user with proper licenses on the admin.microsoft.com portal
* **Project lead** to give access to an existing project
* **New developer** to test login

## Scenario 5: SDLC within a Dev Box

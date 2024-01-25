# Microsoft Dev Box Proof of Concept Guide

## Scoping call - Review
* Review prerequisites
* Scenarios to cover - review below scope
* What to include in the custom VM Image (scenario 3)
   * Developer Tools
   * Libraries
   * Access to products (ADO, Azure Portal, etc)
* Rollout - How many developers to roll out to and what [SKUs](https://azure.microsoft.com/en-us/pricing/details/dev-box/)?
* Theory - FAQs (anything else?)

## Out of scope / Topics for follow up session (March/April):
* Azure Deployment Environments?
* [Use Azure VM Image Builder for creating custom VM Images for Microsoft Dev Box](https://learn.microsoft.com/en-us/azure/dev-box/how-to-customize-devbox-azure-image-builder)
* [Optimize the Visual Studio experience on Microsoft Dev Box with Visual Studio caches](https://learn.microsoft.com/en-us/azure/dev-box/how-to-generate-visual-studio-caches)

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

# Start Fresh - Cleanup resources

If you would like to delete multiple resource groups at the same time,  you can tag all the RGs to be deleted as `delete`.  After that, open the `Azure Cloud Shell` and run this `bash` script.

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
  
# Scenario 4: Use a remote desktop client to connect to a dev box

https://learn.microsoft.com/en-us/azure/dev-box/tutorial-connect-to-dev-box-with-remote-desktop-app?tabs=windows

# Scenario 5: Test the onboarding experience of a new developer

* **IT Admin** to add a new user with proper licenses on the admin.microsoft.com portal
* **Project lead** to give access to an existing project
* **New developer** to test login

# Scenario 6: Deploy to Azure from within Dev Box
* Create and publish sample web app from VS2022 within DevBox to Azure

# Scenario 7: Manage & Troubleshoot Dev Boxes

* Shut down, restart, or hibernate a dev box
* Get information about a dev box
* Delete a dev box
* [Run Troubleshoot & repair](https://learn.microsoft.com/en-us/azure/dev-box/how-to-troubleshoot-repair-dev-box#run-troubleshoot--repair)

# Scenario 8: Restrict access to dev boxes by using conditional access policies in Microsoft Intune

https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-intune-conditional-access-policies 

# Scenario 9: Cost Management & Quotas

## Cost Analysis
You can go to the `Subscription` > `Cost Management (Cost Analysis)` > Select the `Resource Group` to see the associated costs per:
* Project
  * Dev Box Pool
    * Dev Box

![image](https://github.com/kcodeg123/DevBoxPoC/assets/3813135/2426f472-7823-4f7d-993b-7ac53b29abac)

> Tip: You can grant the built-in role of 'Cost Management Reader' to the Project Leads so that they can view the costs associated with their projects. Note that they will have access to costs associated with all the resources in the subscription with this built-in role. You can choose to build a custom role if you want to customize the permissions.

## Dev Box Quotas

To ensure that resources are available for customers, Microsoft Dev Box has a limit on the number of each type of resource that can be used in a subscription. This limit is called a quota. There are different types of quotas related to Dev Box that you might see in the Developer portal and Azure portal, such as quota for Dev Box vCPU for box creation as well as resource limits for Dev Centers, network connections, and Dev Box Definitions.

For more information, check the official [documentation](https://learn.microsoft.com/en-us/azure/dev-box/how-to-determine-your-quota-usage).
If needed, you can [request a quota limit increase](https://learn.microsoft.com/en-us/azure/dev-box/how-to-request-quota-increase).

# Scenario 10: Deploy using Infrastructure as Code

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

# Next Steps

* Discuss rollout plan for developers
* Follow up session with more topics
* Design initial strategy for organizing Dev Centers

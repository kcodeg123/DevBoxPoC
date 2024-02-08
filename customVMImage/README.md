# Core Concepts

For this PoC, we will choose to create the custom VM Images using VM Image Builder.

## Azure Compute Gallery

[Souce](https://learn.microsoft.com/en-us/azure/virtual-machines/image-version?tabs=portal%2Ccli2)

An Azure Compute Gallery (formerly known as Shared Image Gallery) simplifies custom image sharing across your organization. Custom images are like marketplace images, but you create them yourself. Images can be created from a VM, VHD, snapshot, managed image, or another image version.

The Azure Compute Gallery feature has multiple resource types:

![image](https://github.com/kcodeg123/DevBoxPoC/assets/3813135/e98cdb7a-6c92-48f2-8ff2-c6fec771d6b0)

----

# Step by step guide

## Step 0 - Create a new RG & Dev Center

* Create a new Resource Group
  * Create a new Dev Center

## Step 1 - Check your provider registrations

To use VM Image Builder, you need to register the features.

Check your provider registrations. Make sure each command returns Registered for the specified feature.


    Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages | Format-table -Property ResourceTypes,RegistrationState 
    Get-AzResourceProvider -ProviderNamespace Microsoft.Storage | Format-table -Property ResourceTypes,RegistrationState  
    Get-AzResourceProvider -ProviderNamespace Microsoft.Compute | Format-table -Property ResourceTypes,RegistrationState 
    Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault | Format-table -Property ResourceTypes,RegistrationState 
    Get-AzResourceProvider -ProviderNamespace Microsoft.Network | Format-table -Property ResourceTypes,RegistrationState

If the provider registrations don't return `Registered`, register the providers by running the following commands:

    Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages  
    Register-AzResourceProvider -ProviderNamespace Microsoft.Storage  
    Register-AzResourceProvider -ProviderNamespace Microsoft.Compute  
    Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault  
    Register-AzResourceProvider -ProviderNamespace Microsoft.Network

## Step 2 - Create a Managed Identity

This step creates a user-assigned identity with a custom role definition and set permissions on the resource group.

* Firstly, update the contents in [base.ps1](base.ps1) with the appropriate values for Resource Group, Location and identityName.
* Open the `Cloud Shell` on the Azure Portal
* Select `PowerShell`
* Create a new file in the current (or desired) directory. You can use `nano base.ps1`
* Copy and paste the code in [base.ps1](base.ps1)
* Click on `{}` (*Open Editor*) to see the created file with the code in it.
* Run the PowerShell script `./base.ps1`
* Note the name of the managed identity you just created which will be shown in the output.

> VM Image Builder uses the provided user identity to inject the image into Azure Compute Gallery. The included script creates an Azure role definition with specific actions for distributing the image. The role definition is then assigned to the user identity.

```
You may need to add Additional permissions on the managed identity. If you get a "LinkedAuthorizationFailed" error, then it could be because your service principal does not have the required permissions to assign a user-assigned identity to a virtual machine. To fix this issue, you need to grant the service principal the role of Managed Identity Operator on the user-assigned identity resource. You can do this by following these steps:
* Navigate to the Azure portal and sign in with your account.
* Search for User-assigned identities in the search box and select the service from the results.
* Select the user-assigned identity that is mentioned in the error message (logista-uid1707142946).
* Click on Access control (IAM) from the left menu.
* Click on Add and select Add role assignment from the drop-down menu.
* In the Add role assignment pane, select Managed Identity Operator as the role, and search for the service principal that is mentioned in the error message (the Managed Identity).
* Select the service principal from the results and click Save.
```

## Step 3 - Create Image Template

Note - If you face issues seeing the managed identity from the Image Template resource, try to create the Image Template resource on `preview.portal.azure.com`

On the Azure Portal > Create an `Image Templates` resource.

### Compute Gallery Image Requirements

[Source](https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements)

A gallery used to configure dev box definitions must have at least one image definition and one image version.

When you create a virtual machine (VM) image, select an image from the Azure Marketplace that's compatible with Microsoft Dev Box. The following are examples of compatible images:

[Visual Studio 2019](https://azuremarketplace.microsoft.com/en/marketplace/apps/microsoftvisualstudio.visualstudio2019plustools?tab=Overview)
[Visual Studio 2022](https://azuremarketplace.microsoft.com/en/marketplace/apps/microsoftvisualstudio.visualstudioplustools?tab=Overview)

The image version must meet the following requirements:
* Generation 2
* Hyper-V v2
* Windows OS
  * Windows 10 Enterprise version 20H2 or later
  * Windows 11 Enterprise 21H2 or later

* Generalized VM image
* Single-session VM images (Multiple-session VM images aren't supported)
* No recovery partition For information about how to remove a recovery partition, see the [Windows Server command: delete partition](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/delete-partition).
* Default 64-GB OS disk size The OS disk size is automatically adjusted to the size specified in the SKU description of the Windows 365 license.
* The image definition must have [trusted launch enabled](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch) as the security type

## Step 4 - Start build

In the created Image Template, click on `Start Build`.

You can `Refresh` the status and wait until the `Build run state` shows complete. This step will take some time to complete as it builds a version of the image from the template.

Wait for the build to complete before moving to the next steps.

## Step 5 - Add the Compute Gallery to the Dev Center

[Source](https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#provide-permissions-for-services-to-access-a-gallery)

Galleries cannot be added until an identity has been assigned to the Dev Center.

> When you use an Azure Compute Gallery image to create a dev box definition, the Windows 365 service validates the image to ensure that it meets the requirements to be provisioned for a dev box. Microsoft Dev Box replicates the image to the regions specified in the attached network connections, so the images are present in the region required for dev box creation.
> To allow the services to perform these actions, you must provide permissions to your gallery as follows.

* Create a new User Managed Identity
* Add a User Managed Identity to the Dev Center
  * In the Settings blader of the Dev Center resource, go to `Identity`> `User assigned` and add a user assigned managed identity.
* Attach the gallery to the dev center


> Microsoft Dev Box behaves differently depending how you attach your gallery:
> * When you use the Azure portal to attach the gallery to your dev center, the Dev Box service creates the necessary role assignments automatically after you attach the gallery. This is the option chosen for this PoC.
> * When you use the Azure CLI to attach the gallery to your dev center, you must manually create the Windows 365 service principal and the dev center's managed identity role assignments before you attach the gallery. More details [here](https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#assign-roles).

## Step 6 - Create the Dev Box Definition & Project

* Create a Dev Box definition with the new Image.
* Create a new Project
* Create a new Dev Box Pool
* Assign the project to the developer persona

## Step 7

The Developer can now log into the Developer Portal and test creating the dev box and logging in to it.

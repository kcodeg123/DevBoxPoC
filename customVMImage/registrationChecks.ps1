# To use VM Image Builder, you need to register the features.
# Check your provider registrations. Make sure each command returns Registered for the specified feature.

Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages | Format-table -Property ResourceTypes,RegistrationState 
   Get-AzResourceProvider -ProviderNamespace Microsoft.Storage | Format-table -Property ResourceTypes,RegistrationState  
   Get-AzResourceProvider -ProviderNamespace Microsoft.Compute | Format-table -Property ResourceTypes,RegistrationState 
   Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault | Format-table -Property ResourceTypes,RegistrationState 
   Get-AzResourceProvider -ProviderNamespace Microsoft.Network | Format-table -Property ResourceTypes,RegistrationState

<#

# If the provider registrations don't return Registered, register the providers by running the following commands:

Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages  
   Register-AzResourceProvider -ProviderNamespace Microsoft.Storage  
   Register-AzResourceProvider -ProviderNamespace Microsoft.Compute  
   Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault  
   Register-AzResourceProvider -ProviderNamespace Microsoft.Network

#>
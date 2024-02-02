# VM Images to create for this PoC

## Common to all images:

* Git
* Docker Desktop
* Postman (latest)
* SoapUI (latest)

## Image 1
Windows 11 + Visual Studio 2022 + SQL Management Studio (latest)

## Image 2
Windows 11 + Visual Studio Code (latest) + Android Studio (latest) + Flutter Addon for VSCode (latest)

## Image 3
Ubuntu (latest) + VSCode Latest + Eclipse (Latest)

# Core Concepts

For this PoC, we will choose to create the custom VM Images using VM Image Builder.

## Azure Compute Gallery

[Souce](https://learn.microsoft.com/en-us/azure/virtual-machines/image-version?tabs=portal%2Ccli2)

An Azure Compute Gallery (formerly known as Shared Image Gallery) simplifies custom image sharing across your organization. Custom images are like marketplace images, but you create them yourself. Images can be created from a VM, VHD, snapshot, managed image, or another image version.

The Azure Compute Gallery feature has multiple resource types:

![image](https://github.com/kcodeg123/DevBoxPoC/assets/3813135/e98cdb7a-6c92-48f2-8ff2-c6fec771d6b0)

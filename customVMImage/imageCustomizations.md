## Common to all images:

* Chocolatey Package Manager
* Git
* Docker Desktop
* Postman (latest)
* SoapUI (latest)

### Chocolatey Package Manager
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

### Git

This should be pre-installed if you are using a Dev Box compatible image. If not, you can add the following code.

    choco install -y git

[Git package](https://community.chocolatey.org/packages/git)

### Docker Desktop

This should be pre-installed if you are using a Dev Box compatible image. If not, you can add the following code.

    choco install -y docker-desktop

[Docker desktop package](https://community.chocolatey.org/packages/docker-desktop)

### Postman

    choco install -y postman

[Postman package](https://community.chocolatey.org/packages/postman)

### SoapUI

    choco install -y soapui

[SoapUI package](https://community.chocolatey.org/packages/soapui)

## Image 1 - Additional Customizations
* Windows 11 (part of base image)
* Visual Studio 2022
* SQL Management Studio (latest)

### VS Code
    choco install -y vscode
    
[Visual Studio Code package](https://community.chocolatey.org/packages/vscode)


### SQL Management Studio (latest)
    choco install -y sql-server-management-studio

[SQL Management Studio package](https://community.chocolatey.org/packages/sql-server-management-studio)

## Image 2
* Windows 11 (part of base image)
* Visual Studio Code (latest)
* Android Studio (latest)
* Flutter Addon for VSCode (latest)

### VS Code
    choco install -y vscode
    
[Visual Studio Code package](https://community.chocolatey.org/packages/vscode)

### Android Studio

    choco install -y androidstudio

[Android Studio on Chocolatey](https://community.chocolatey.org/packages/AndroidStudio)

### Flutter Addon for VSCode
We will install the Flutter extension to VS Code using PowerShell:

    Start-Process "C:\Program Files\Microsoft VS Code\bin\code.cmd" -ArgumentList "--install-extension","Dart-Code.flutter","--force" -wait

This will install the Flutter extension and its dependency, the Dart extension, for Visual Studio Code.

## Image 3
* Ubuntu (latest) - Part of WSL
* VSCode Latest
* Eclipse (Latest)

### VS Code
    choco install -y vscode
    
[Visual Studio Code package](https://community.chocolatey.org/packages/vscode)
### Eclipse

    choco install -y eclipse

[Eclipse package](https://community.chocolatey.org/packages/eclipse)

### Ubuntu

WSL is enabled by default as part of the dev box compatible images. You can use WSL to install Ubuntu. This will download and install Ubuntu from the Microsoft Store.

    wsl --install -d Ubuntu
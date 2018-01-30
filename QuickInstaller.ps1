##################################
#### DSCManangerInstaller.ps1
#### Author: Thomas Maurer
#### Web: www.thomasmaurer.ch
#### itnetX DSC Manager http://itnetx.ch/products/dsc-manager/
#### Version 0.1
#### Description: This script helps to quickly install the itnetX DSC Manager for a lab and test environment
###################################


# Install IIS Web Server
Install-WindowsFeature Web-Server, Web-Mgmt-Tools

# Download and Install .NET Core Web Hosting 2.0 
Invoke-WebRequest -Uri "https://aka.ms/dotnetcore.2.0.0-windowshosting" -OutFile .\DotNetCore.2.0.5-WindowsHosting.exe
.\DotNetCore.2.0.5-WindowsHosting.exe /install /passive

# Download and Install .NET Core Runtime
Invoke-WebRequest -Uri "https://download.microsoft.com/download/6/F/B/6FB4F9D2-699B-4A40-A674-B7FF41E0E4D2/dotnet-win-x64.1.1.4.exe" -OutFile .\dotnet-win-x64.1.1.4.exe
.\dotnet-win-x64.1.1.4.exe /install /passive

# Restart IIS
iisreset

# Unpack itnetX DSC Manager
Expand-Archive -path ".\DSCManager_0.2.1.zip" -DestinationPath "C:\inetpub\wwwroot\"

# Configure Default App Pool
Set-ItemProperty -Path IIS:\AppPools\DefaultAppPool -Name managedRuntimeVersion -Value ''
$appPool = Get-ItemProperty -Path IIS:\AppPools\DefaultAppPool
$appPool.processModel.identityType = "LocalSystem"
$appPool | Set-Item

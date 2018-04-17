# Sample Dockerfile

# Indicates that the windowsservercore image will be used as the base image.
FROM microsoft/windowsservercore

# Metadata indicating an image maintainer.
MAINTAINER daniel.mcdermott@avanade.com

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \

    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force ; \
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted ;\
    # Get AzureStack tools
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; \
	Invoke-WebRequest -Method Get -Uri https://github.com/Azure/AzureStack-Tools/archive/master.zip -Timeoutsec 600 -OutFile c:\master.zip ; \
 	Expand-Archive -Path c:\master.zip -DestinationPath c:\ ; \
 	Remove-Item c:\master.zip -Force ; \ 
    # Get Azure Stack PoSH Modules
    Install-Module -Name 'AzureRm.Bootstrapper' ; \
    Install-AzureRmProfile -profile '2017-03-09-profile' -Force ; \
    Install-Module -Name AzureStack -RequiredVersion 1.2.11 ; \
    cd c:\AzureStack-Tools-master ; \
    # Import the modules
    Import-Module .\ComputeAdmin\AzureStack.ComputeAdmin.psm1; \
    Import-Module .\Registration\RegisterWithAzure.psm1

# Sets a command or process that will run each time a container is run from the new image.
CMD [ "powershell" ]
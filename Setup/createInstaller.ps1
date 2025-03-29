# filepath: /ps-to-exe-project/ps-to-exe-project/src/createInstaller.ps1

# This script creates the installer for the QStackPlugin PS2EXE.

$sourceScript = ".\Setup\QStackInstall.ps1"
$destinationExe = "QStackInstall.exe"

if (-Not (Get-Module -ListAvailable -Name PS2EXE)) {
    Write-Host "PS2EXE module is not installed. Please install it using the following command:"
    Write-Host "Install-Module -Name PS2EXE -Scope CurrentUser"
    exit 1
}

try {
    Invoke-Expression "ps2exe -inputFile `"$sourceScript`" -outputFile `"$destinationExe`" -IconFile `"Setup\config\QStackLogo.ico`" -noConsole"
    Write-Host "Conversion complete: $destinationExe"
} catch {
    Write-Host "Failed to convert script: $_"
}
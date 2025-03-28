# filepath: /ps-to-exe-project/ps-to-exe-project/src/convert.ps1

# This script converts the QStackInstall.ps1 PowerShell script into an executable using PS2EXE.

$sourceScript = "QStackInstall.ps1"  # Update this path to the actual location of QStackInstall.ps1
$destinationExe = "QStackInstall.exe"  # Update this path for the output executable

# Check if the PS2EXE module is installed
if (-Not (Get-Module -ListAvailable -Name PS2EXE)) {
    Write-Host "PS2EXE module is not installed. Please install it using the following command:"
    Write-Host "Install-Module -Name PS2EXE -Scope CurrentUser"
    exit 1
}

# Convert the PowerShell script to an executable
try {
    Invoke-Expression "ps2exe -inputFile `"$sourceScript`" -outputFile `"$destinationExe`" -IconFile `"config\QStackLogo.ico`" -noConsole"
    Write-Host "Conversion complete: $destinationExe"
} catch {
    Write-Host "Failed to convert script: $_"
}
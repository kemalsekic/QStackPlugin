# filepath: powershell-installation-script/QStackInstall.ps1

# This script transfers all files from the root of the current workspace to the cmder root directory.

$sourceDir = Get-Location
$destinationDir = "C:\Program Files\cmder\config"
if (-Not (Test-Path $destinationDir)) {
    Write-Host "Destination directory does not exist: $destinationDir"
    exit 1
}
$files = Get-ChildItem -Path $sourceDir -File
foreach ($file in $files) {
    $destinationPath = Join-Path -Path $destinationDir -ChildPath $file.Name
    try {
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
    } catch {
        Write-Host "Failed to copy: $($file.Name) - $_"
    }
}

Write-Host "File transfer complete. Check the cmder root directory for the files."
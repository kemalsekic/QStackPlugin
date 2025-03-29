# This script copies the entire QStackPlugin folder to the cmder config directory

# Disable standard output to prevent message boxes when run as EXE
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# Function to log to a file instead of screen
function Write-Log {
    param (
        [string]$Message,
        [string]$LogLevel = "INFO"
    )
    
    $logFile = Join-Path -Path $env:TEMP -ChildPath "QStackInstall.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [$LogLevel] $Message" | Out-File -FilePath $logFile -Append
}

# Get the location of the script or executable
function Get-ScriptDirectory {
    # For .ps1 script
    if ($PSCommandPath) {
        Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    }
    # For compiled executable
    elseif ($MyInvocation.MyCommand.Path) {
        Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    # If running in memory (e.g., ISE)
    elseif ($PSScriptRoot) {
        Split-Path -Parent $PSScriptRoot
    }
    # Last resort - current directory
    else {
        Get-Location
    }
}

# Define source and destination paths
$sourceDir = Get-ScriptDirectory
Write-Log "Detected source directory: $sourceDir"

# Handle the case when the EXE is inside the extracted ZIP (different folder structure)
$qstackPluginFolder = Join-Path -Path $sourceDir -ChildPath "QStackPlugin"
if (-not (Test-Path $qstackPluginFolder)) {
    # Try one level up
    $sourceDir = Split-Path -Parent $sourceDir
    $qstackPluginFolder = Join-Path -Path $sourceDir -ChildPath "QStackPlugin"
    
    # If still not found, check if we're already inside the QStackPlugin folder
    if (-not (Test-Path $qstackPluginFolder)) {
        if ((Split-Path -Leaf $sourceDir) -eq "QStackPlugin") {
            $qstackPluginFolder = $sourceDir
        }
    }
    
    Write-Log "Adjusted source directory: $sourceDir"
}

$destinationDir = "C:\Program Files\cmder\config"
$destinationPluginFolder = Join-Path -Path $destinationDir -ChildPath "QStackPlugin"

# Check if source QStackPlugin folder exists
if (-Not (Test-Path $qstackPluginFolder)) {
    Write-Log "ERROR: Source QStackPlugin folder not found at: $qstackPluginFolder" -LogLevel "ERROR"
    exit 1
}

# Check if destination directory exists
if (-Not (Test-Path $destinationDir)) {
    Write-Log "ERROR: Destination cmder config directory does not exist: $destinationDir" -LogLevel "ERROR"
    exit 1
}

# Create destination folder if it doesn't exist
if (-Not (Test-Path $destinationPluginFolder)) {
    try {
        New-Item -Path $destinationPluginFolder -ItemType Directory -Force | Out-Null
        Write-Log "Created QStackPlugin folder in cmder config directory."
    }
    catch {
        Write-Log "ERROR: Failed to create QStackPlugin folder - $_" -LogLevel "ERROR"
        exit 1
    }
}

# Check if there are files to copy
$filesInSource = Get-ChildItem -Path $qstackPluginFolder -Recurse -File
if ($filesInSource.Count -eq 0) {
    Write-Log "ERROR: No files found in source directory: $qstackPluginFolder" -LogLevel "ERROR"
    exit 1
}

# Copy the entire QStackPlugin folder
try {
    Write-Log "Copying QStackPlugin folder to cmder config directory..."
    Write-Log "Source: $qstackPluginFolder"
    Write-Log "Destination: $destinationPluginFolder"
    
    # Get count of files to copy
    $totalFiles = $filesInSource.Count
    $copiedFiles = 0
    
    # Copy files
    Get-ChildItem -Path $qstackPluginFolder -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Substring($qstackPluginFolder.Length)
        $destination = Join-Path -Path $destinationPluginFolder -ChildPath $relativePath
        
        if ($_.PSIsContainer) {
            if (-not (Test-Path $destination)) {
                New-Item -Path $destination -ItemType Directory -Force | Out-Null
            }
        }
        else {
            Copy-Item -Path $_.FullName -Destination $destination -Force
            $copiedFiles++
        }
    }
    
    # Verify files were actually copied
    $copiedFileCount = (Get-ChildItem -Path $destinationPluginFolder -Recurse -File).Count
    if ($copiedFileCount -eq 0) {
        Write-Log "WARNING: No files were copied to the destination. Something went wrong." -LogLevel "WARNING"
    }
    else {
        Write-Log "Successfully copied $copiedFiles of $totalFiles files to $destinationPluginFolder"
    }
}
catch {
    Write-Log "ERROR: Failed to copy QStackPlugin folder - $_" -LogLevel "ERROR"
    exit 1
}

# Show a minimal completion notification using Windows notification
try {
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
    $notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.SystemIcons]::Information
    $notification.BalloonTipTitle = "QStack Plugin"
    $notification.BalloonTipText = "Installation completed successfully"
    $notification.Visible = $true
    $notification.ShowBalloonTip(3000)
    Start-Sleep -Seconds 1
    $notification.Dispose()
}
catch {
    # Silent fail - just exit normally if notification fails
    Write-Log "Could not display notification - $_" -LogLevel "WARNING"
}

# Exit silently
exit 0
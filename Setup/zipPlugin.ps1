# Define source directory
$sourceDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
Write-Host "Source directory: $sourceDir" -ForegroundColor Cyan

# Create distribution ZIP file with exclusions
function New-DistributionZip {
    param (
        [string]$sourceFolder,
        [string]$outputZipFile,
        [string[]]$excludeFiles,
        [string[]]$excludeFolders
    )
    
    # Validate parameters
    if (-not (Test-Path -Path $sourceFolder)) {
        Write-Error "Source folder does not exist: $sourceFolder"
        return $false
    }
    
    # Create a temporary directory to stage files
    $stagingDir = Join-Path -Path $env:TEMP -ChildPath "QStackPlugin_Staging_$(Get-Random)"
    New-Item -Path $stagingDir -ItemType Directory -Force | Out-Null
    Write-Host "Created staging directory: $stagingDir" -ForegroundColor Cyan
    
    # Counter for excluded files
    $excludedCount = 0
    $includedCount = 0
    
    # First, check if each direct subfolder should be excluded
    $excludedTopFolders = @()
    Get-ChildItem -Path $sourceFolder -Directory | ForEach-Object {
        $folderName = $_.Name
        if ($excludeFolders -contains $folderName) {
            $excludedTopFolders += $folderName
            Write-Host "`tExcluding top-level folder: $folderName" -ForegroundColor Yellow
            $excludedCount++
        }
    }
    
    # Copy all items to staging, excluding those that match exclusion patterns
    Get-ChildItem -Path $sourceFolder -Recurse | ForEach-Object {
        # Skip the item if it's in an excluded top folder
        $shouldProcess = $true
        foreach ($excludedFolder in $excludedTopFolders) {
            if ($_.FullName.StartsWith("$sourceFolder\$excludedFolder\", [StringComparison]::OrdinalIgnoreCase) -or 
                $_.FullName -eq "$sourceFolder\$excludedFolder") {
                $shouldProcess = $false
                break
            }
        }
        
        if ($shouldProcess) {
            $relativePath = $_.FullName.Substring($sourceFolder.Length + 1)
            $destinationPath = Join-Path -Path $stagingDir -ChildPath $relativePath
            
            # Check if item should be excluded
            $exclude = $false
            $excludeReason = ""
            
            # Skip the check if it's a top-level folder (already handled)
            if ($_.PSIsContainer -and ($_.Parent.FullName -eq $sourceFolder) -and ($excludeFolders -contains $_.Name)) {
                $exclude = $true
                $excludeReason = "Top-level excluded folder"
            } 
            # Check file exclusions
            elseif ($_.PSIsContainer -eq $false) {
                foreach ($pattern in $excludeFiles) {
                    if ($_.Name -like $pattern) {
                        $exclude = $true
                        $excludeReason = "Matched file pattern: $pattern"
                        break
                    }
                }
            }
            # Check folder exclusions for non-top-level folders
            elseif ($_.PSIsContainer -eq $true -and $_.Parent.FullName -ne $sourceFolder) {
                foreach ($pattern in $excludeFolders) {
                    if ($_.Name -like $pattern) {
                        $exclude = $true
                        $excludeReason = "Matched folder pattern: $pattern"
                        break
                    }
                }
            }
            
            # If file path contains any excluded folders, exclude it
            if (-not $exclude) {
                foreach ($pattern in $excludeFolders) {
                    if ($relativePath -like "*\$pattern\*" -or $relativePath -like "$pattern\*") {
                        $exclude = $true
                        $excludeReason = "Inside excluded folder: $pattern"
                        break
                    }
                }
            }
            
            # Copy if not excluded
            if (-not $exclude) {
                if ($_.PSIsContainer) {
                    if (-not (Test-Path -Path $destinationPath)) {
                        New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
                    }
                } else {
                    $parentFolder = Split-Path -Path $destinationPath -Parent
                    if (-not (Test-Path -Path $parentFolder)) {
                        New-Item -Path $parentFolder -ItemType Directory -Force | Out-Null
                    }
                    Copy-Item -Path $_.FullName -Destination $destinationPath -Force
                    $includedCount++
                }
            } else {
                Write-Host "`tExcluding: $relativePath ($excludeReason)" -ForegroundColor Yellow
                $excludedCount++
            }
        }
    }
    
    Write-Host "Included $includedCount files, excluded $excludedCount items" -ForegroundColor Cyan
    
    # Create the ZIP file from the staging directory
    try {
        Compress-Archive -Path "$stagingDir\*" -DestinationPath $outputZipFile -Force
        
        # Check ZIP file was created but DON'T output a message here
        if (Test-Path -Path $outputZipFile) {
            $script:zipSize = (Get-Item -Path $outputZipFile).Length / 1MB
            return $true
        } else {
            Write-Error "Failed to create ZIP file at: $outputZipFile"
            return $false
        }
    }
    catch {
        Write-Error "Error creating ZIP file: $_"
        return $false
    }
    finally {
        # Clean up staging directory
        Remove-Item -Path $stagingDir -Recurse -Force
        Write-Host "Removed staging directory" -ForegroundColor Cyan
    }
    
    return $true
}

# Define your exclusions
$filesToExclude = @(
    "transferFilesToRepo.ps1", 
    "custom2.cmd", 
    "aliases copy.json",
    "*.bak",
    "*.tmp",
    "*.log",
    "kemals_aliases.cmd",
    ".gitignore"
    "build.cmd"
)

$foldersToExclude = @(
    ".git", 
    "tmp", 
    "Temp", 
    "cache",
    ".vscode",
    "Setup"  # This should be excluded
)

# Ensure source directory exists
if (-not $sourceDir -or -not (Test-Path -Path $sourceDir)) {
    Write-Error "Source directory could not be determined or doesn't exist."
    exit 1
}

# Set the plugin folder to the source directory itself
$pluginFolder = $sourceDir
$outputZip = Join-Path -Path $sourceDir -ChildPath "QStackPlugin.zip"

Write-Host "Plugin folder: $pluginFolder" -ForegroundColor Cyan
Write-Host "Output ZIP: $outputZip" -ForegroundColor Cyan

# Check if plugin folder exists
if (-not (Test-Path -Path $pluginFolder)) {
    Write-Error "Plugin folder not found: $pluginFolder"
    Write-Host "Current directory is: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

# Use the standard function without preserveTopFolder switch
$result = New-DistributionZip -sourceFolder $pluginFolder -outputZipFile $outputZip -excludeFiles $filesToExclude -excludeFolders $foldersToExclude

# After the existing result handling code
if ($result) {
    # Display completion information
    Write-Host "`nDistribution package created successfully!" -ForegroundColor Green
    Write-Host "ZIP File: $outputZip" -ForegroundColor Green
    Write-Host "ZIP file size: $($zipSize.ToString('0.00')) MB" -ForegroundColor Green
    
    # Cleanup function to remove EXE files
    try {
        $exePath = Join-Path -Path $sourceDir -ChildPath "QStackInstall.exe"
        if (Test-Path -Path $exePath) {
            Remove-Item -Path $exePath -Force
            Write-Host "Cleaned up: Removed QStackInstall.exe" -ForegroundColor Green
        } else {
            Write-Host "No QStackInstall.exe file found to clean up" -ForegroundColor Yellow
        }
        
        # Check for any other EXE files that might need cleaning (optional)
        $otherExeFiles = Get-ChildItem -Path $sourceDir -Filter "*.exe" | Where-Object { $_.Name -ne "QStackPlugin.exe" }
        foreach ($file in $otherExeFiles) {
            Remove-Item -Path $file.FullName -Force
            Write-Host "Cleaned up additional executable: $($file.Name)" -ForegroundColor Green
        }

        # Copy the ZIP file path to clipboard
        try {
            # Check if Set-Clipboard is available (PowerShell 5.0+)
            if (Get-Command -Name Set-Clipboard -ErrorAction SilentlyContinue) {
                $outputZip | Set-Clipboard
                Write-Host "`n- ZIP file path copied to clipboard! -" -ForegroundColor Green
            }
            else {
                # Alternative method for older PowerShell versions using clip.exe
                $outputZip | clip
                Write-Host "`nZIP file path copied to clipboard using clip.exe!" -ForegroundColor Green
            }
        }
        catch {
            Write-Warning "Could not copy path to clipboard: $_"
        }
    }
    catch {
        Write-Warning "Error during cleanup: $_"
    }
}
else {
    Write-Host "Failed to create distribution package." -ForegroundColor Red
    exit 1
}
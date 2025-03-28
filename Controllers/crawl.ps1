param(
    [Parameter(Mandatory=$true)]
    [string]$RootDirectory,
    
    [Parameter(Mandatory=$false)]
    [string]$MaxDepth = 3,
    
    [Parameter(Mandatory=$false)]
    [string]$Category = "qstack"
)

# Ensure CMDER_ROOT is set
if (-not $env:CMDER_ROOT) {
    Write-Host "CMDER_ROOT environment variable is not set." -ForegroundColor Red
    exit 1
}

# File paths
$aliasFile = Join-Path $env:CMDER_ROOT "config\QStackPlugin\qStackCustom_aliases.cmd"
$descFile = Join-Path $env:CMDER_ROOT "config\QStackPlugin\Controllers\data\aliases.json"

# Check if files exist
if (-Not (Test-Path $aliasFile)) {
    Write-Host "Alias file not found: $aliasFile" -ForegroundColor Red
    exit 1
}

if (-Not (Test-Path $descFile)) {
    Write-Host "Descriptions file not found: $descFile" -ForegroundColor Red
    exit 1
}

# Read the aliases JSON
$jsonData = Get-Content $descFile | ConvertFrom-Json

# Ensure the category exists
if (-Not $jsonData.PSObject.Properties.Name.Contains($Category)) {
    $jsonData | Add-Member -MemberType NoteProperty -Name $Category -Value @{ }
}

# Temp storage for new aliases
$newAliases = @()
$newDescriptions = @{}

Write-Host "Scanning $RootDirectory for solution files (max depth: $MaxDepth)..." -ForegroundColor Cyan

# Find all .sln files recursively
$solutionFiles = Get-ChildItem -Path $RootDirectory -Filter "*.sln" -Recurse -Depth $MaxDepth

Write-Host "Found $($solutionFiles.Count) solution files." -ForegroundColor Green
Write-Host "Creating navigation aliases for solution directories and open aliases for solution files." -ForegroundColor Yellow

# Process solution files
foreach ($file in $solutionFiles) {
    $dirName = Split-Path -Path $file.Directory -Leaf
    $baseName = $file.BaseName

    # Create aliases with sanitized names
    $cdAliasName = "cd-$($dirName.ToLower() -replace '[^a-z0-9]', '')"
    $openAliasName = "st-$($baseName.ToLower() -replace '[^a-z0-9]', '')"
    
    # Create doskey commands - keep cd and start OUTSIDE the quotes
    $cdCommand = "doskey $cdAliasName=cd `"$($file.Directory)`""
    $openCommand = "doskey $openAliasName=start `""" `"$($file.FullName)`""
    
    # Create aliases
    $cdDesc = "Navigate to $dirName directory"
    $openDesc = "Open $baseName solution"
    
    # Add to collections
    $newAliases += $cdCommand
    $newAliases += $openCommand
    $newDescriptions[$cdAliasName] = $cdDesc
    $newDescriptions[$openAliasName] = $openDesc
}

# Append aliases to file
if ($newAliases.Count -gt 0) {
    Add-Content -Path $aliasFile -Value "`r`n::"
    Add-Content -Path $aliasFile -Value "`r`n:: Auto-generated project aliases from crawler.`r`n"
    Add-Content -Path $aliasFile -Value $newAliases
    
    # Add aliases to JSON
    foreach ($key in $newDescriptions.Keys) {
        $jsonData.$Category | Add-Member -MemberType NoteProperty -Name $key -Value $newDescriptions[$key] -Force
    }
    
    # Save JSON
    $jsonOutput = $jsonData | ConvertTo-Json -Depth 10
    Set-Content -Path $descFile -Value $jsonOutput
    
    Write-Host "Added $($newAliases.Count) new aliases." -ForegroundColor Green
    Write-Host "Restart Cmder to apply the changes." -ForegroundColor Yellow
} else {
    Write-Host "No new aliases were added." -ForegroundColor Yellow
}
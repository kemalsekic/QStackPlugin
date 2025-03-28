param(
    [string]$Category = "qstack"  # default custom category; adjust or prompt if needed
)

# Prompt for alias details
$aliasName = Read-Host "Enter alias name (e.g., myalias)"
$aliasCommand = Read-Host "Enter alias command (e.g., dir /w)"
$aliasDescription = Read-Host "Enter alias description"

# Update qStackCustom_aliases.cmd by appending a doskey command,
# enclosing the command portion in quotes so that it is preserved correctly.
$qStackCustomFile = Join-Path $env:CMDER_ROOT "config\QStackPlugin\qStackCustom_aliases.cmd"
$doskeyLine = "doskey $aliasName=`"$aliasCommand $*`""
Add-Content -Path $qStackCustomFile -Value $doskeyLine

# Update aliases.json
$descFile = Join-Path $env:CMDER_ROOT "config\QStackPlugin\Controllers\data\aliases.json"
if (-Not (Test-Path $descFile)) {
    Write-Host "Descriptions file not found: $descFile" -ForegroundColor Red
    exit 1
}

# Read and update JSON
$jsonData = Get-Content $descFile | ConvertFrom-Json

# If the category doesn't exist yet, create an empty object for it.
if (-Not $jsonData.PSObject.Properties.Name.Contains($Category)) {
    $jsonData | Add-Member -MemberType NoteProperty -Name $Category -Value @{ }
}

# Add new alias and description under the chosen category.
$jsonData.$Category | Add-Member -MemberType NoteProperty -Name $aliasName -Value $aliasDescription -Force

# Convert back to JSON and save.
$jsonOutput = $jsonData | ConvertTo-Json -Depth 10
Set-Content -Path $descFile -Value $jsonOutput

Write-Host "Custom alias '$aliasName' added successfully." -ForegroundColor Green
Write-Host "Cmder needs to restart to load the new aliases." -ForegroundColor Cyan
Write-Host "Restarting terminal in 4 seconds..." -ForegroundColor Cyan
Start-Sleep -Seconds 4

# Launch a new Cmder instance
Start-Process "$env:CMDER_ROOT\Cmder.exe" -ArgumentList '/TASK {cmd::Cmder}'

# Force close the current terminal
Stop-Process -Id $PID -Force
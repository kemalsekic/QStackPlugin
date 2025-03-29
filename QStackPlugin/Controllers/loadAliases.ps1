param ()

function Show-Blue-Divider {
    Write-Host("====================================================================================================") -ForegroundColor Blue
}

function Show-Yellow-Divider {
    Write-Host("====================================================================================================") -ForegroundColor Yellow
}

function ShowStartEnd {
    param (
        [string]$startOrEnd = ""
    )
    if ($startOrEnd -eq "Start") {
        Write-Host("                                   LOADING CUSTOM CMDER FILES") -ForegroundColor Yellow
    }
    elseif ($startOrEnd -eq "End") {
        Write-Host("                                        SETUP COMPLETE") -ForegroundColor Yellow
    }
}

function Show-Title {
    Clear-Host
    Show-Blue-Divider
    Write-Host("==========================================") -ForegroundColor Yellow -NoNewline
    Write-Host("|    QStack    |") -ForegroundColor Blue -NoNewline
    Write-Host("==========================================") -ForegroundColor Yellow
    Show-Blue-Divider
    Write-Host("")
    ShowStartEnd "Start"
}

function LoadFiles{
    # Ensure CMDER_ROOT is set
    if (-not $env:CMDER_ROOT) {
        Write-Host "CMDER_ROOT environment variable is not set." -ForegroundColor Red
        exit 1
    }

    $cmderRoot = $env:CMDER_ROOT
    $categories = @("GIT", "NAVIGATION", "CUSTOM")
    $results = @()
    
    # Collect loading results
    foreach ($cat in $categories) {
        $aliasFile = Join-Path $cmderRoot "config\QStackPlugin\$($cat)_aliases.cmd"
        if (Test-Path $aliasFile) {
            # Call the CMD alias file using cmd.exe
            cmd.exe /c "call `"$aliasFile`""
            $results += [PSCustomObject]@{
                Category = $cat
                Status = "LOADED"
                StatusColor = "Green"
            }
        }
        else {
            $results += [PSCustomObject]@{
                Category = $cat
                Status = "NOT FOUND"
                StatusColor = "Red"
            }
        }
    }
    
    # Display results in a table
    $idWidth = 4 # Width for ID column
    $catWidth = ($results | ForEach-Object { $_.Category.Length } | Measure-Object -Maximum).Maximum
    if ($catWidth -lt "CATEGORY".Length) { $catWidth = "CATEGORY".Length }
    
    $statusWidth = ($results | ForEach-Object { $_.Status.Length } | Measure-Object -Maximum).Maximum
    if ($statusWidth -lt "STATUS".Length) { $statusWidth = "STATUS".Length }
    
    # Calculate table width and centering padding
    $tableWidth = 9 + $idWidth + $catWidth + $statusWidth # 9 is for borders and spaces
    $titleWidth = 106 # Width of the title line with QStack
    $padding = [Math]::Max(0, [Math]::Floor(($titleWidth - $tableWidth) / 2))
    $paddingString = " " * $padding
    
    # Create border line
    function Get-BorderLine {
        return $paddingString + "+------+-" + ("-" * $catWidth) + "-+-" + ("-" * $statusWidth) + "-+"
    }
    
    $border = Get-BorderLine
    
    # Print header
    Write-Host ""
    Write-Host $border -ForegroundColor White
    
    Write-Host -NoNewline $paddingString -ForegroundColor White
    Write-Host -NoNewline "| " -ForegroundColor White
    Write-Host -NoNewline "ID".PadRight(4) -ForegroundColor Blue
    Write-Host -NoNewline " | " -ForegroundColor White
    Write-Host -NoNewline "CATEGORY".PadRight($catWidth) -ForegroundColor Blue
    Write-Host -NoNewline " | " -ForegroundColor White
    Write-Host "STATUS".PadRight($statusWidth) -ForegroundColor Blue
    
    Write-Host $border -ForegroundColor White
    
    # Print each row
    for ($i = 0; $i -lt $results.Count; $i++) {
        $row = $results[$i]
        
        Write-Host -NoNewline $paddingString -ForegroundColor White
        Write-Host -NoNewline "| " -ForegroundColor White
        Write-Host -NoNewline ($i+1).ToString().PadRight(4) -ForegroundColor Yellow
        Write-Host -NoNewline " | " -ForegroundColor White
        Write-Host -NoNewline $row.Category.PadRight($catWidth) -ForegroundColor Yellow
        Write-Host -NoNewline " | " -ForegroundColor White
        Write-Host $row.Status.PadRight($statusWidth) -ForegroundColor $row.StatusColor
        
        Write-Host $border -ForegroundColor White
    }
    Write-Host ""
}

Show-Title
LoadFiles
ShowStartEnd "End"
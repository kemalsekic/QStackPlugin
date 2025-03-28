param(
    [Parameter(Mandatory=$true)]
    [string]$Category,
    
    [Parameter(Mandatory=$false)]
    [string]$Search = ""
)

$descPath = Join-Path $env:CMDER_ROOT "config\QStackPlugin\Controllers\data\aliases.json"

if (-Not (Test-Path $descPath)) {
    Write-Host "Descriptions file not found: $descPath" -ForegroundColor Red
    exit 1
}

$data = Get-Content $descPath | ConvertFrom-Json

if (-Not $data.PSObject.Properties.Name.Contains($Category)) {
    Write-Host "Category '$Category' not found in aliases file." -ForegroundColor Yellow
    exit 1
}

$allResults = $data.$Category.PSObject.Properties | Sort-Object Name | ForEach-Object {
    [PSCustomObject]@{
        Alias       = $_.Name
        Description = $_.Value
    }
}

# Function to display results with the given search term
function Show-FilteredResults {
    param (
        [string]$SearchTerm
    )
    
    Clear-Host
    
    # Calculate results based on search term
    $filteredResults = $allResults
    if ($SearchTerm -ne "") {
        $searchTerms = $SearchTerm.ToLower().Split(" ", [StringSplitOptions]::RemoveEmptyEntries)
        
        # Filter results that match all search terms (in either alias or description)
        $filteredResults = $allResults | Where-Object {
            $alias = $_.Alias.ToLower()
            $desc = $_.Description.ToLower()
            
            $matchesAllTerms = $true
            foreach ($term in $searchTerms) {
                if (-not ($alias.Contains($term) -or $desc.Contains($term))) {
                    $matchesAllTerms = $false
                    break
                }
            }
            return $matchesAllTerms
        }
    }
    
    # Add an ID to each row
    $idWidth = ([string]($filteredResults.Count)).Length
    if ($idWidth -lt "ID".Length) { $idWidth = "ID".Length }

    $headerID    = "ID"
    $headerAlias = "Alias"
    $headerDesc  = "Description"

    # Calculate maximum widths for the Alias and Description columns
    $aliasWidth = ($filteredResults | ForEach-Object { $_.Alias.Length } | Measure-Object -Maximum).Maximum
    if ($aliasWidth -lt $headerAlias.Length) { $aliasWidth = $headerAlias.Length }

    $descWidth = ($filteredResults | ForEach-Object { $_.Description.Length } | Measure-Object -Maximum).Maximum
    if ($descWidth -lt $headerDesc.Length) { $descWidth = $headerDesc.Length }

    # Function to create a horizontal border line for three columns
    function Get-BorderLine {
        param(
            [int]$width1,
            [int]$width2,
            [int]$width3
        )
        return "+-" + ("-" * $width1) + "-+-" + ("-" * $width2) + "-+-" + ("-" * $width3) + "-+"
    }

    $border = Get-BorderLine -width1 $idWidth -width2 $aliasWidth -width3 $descWidth

    # Function to print a table row with colored cells (yellow) and white borders.
    function Write-TableRow {
        param (
            [string]$col1,
            [string]$col2,
            [string]$col3,
            [int]$width1,
            [int]$width2,
            [int]$width3
        )
        Write-Host -NoNewline "| " -ForegroundColor White
        Write-Host -NoNewline $col1.PadRight($width1) -ForegroundColor Yellow
        Write-Host -NoNewline " | " -ForegroundColor White
        Write-Host -NoNewline $col2.PadRight($width2) -ForegroundColor Yellow
        Write-Host -NoNewline " | " -ForegroundColor White
        Write-Host $col3.PadRight($width3) -ForegroundColor Yellow
    }

    # Print search status if search was performed
    Write-Host "Category: " -NoNewline -ForegroundColor White
    Write-Host $Category.ToUpper() -ForegroundColor Green
    
    if ($SearchTerm -ne "") {
        Write-Host "Search results for: " -NoNewline -ForegroundColor White
        Write-Host "'$SearchTerm'" -ForegroundColor Cyan
        Write-Host "Found $($filteredResults.Count) of $($allResults.Count) aliases" -ForegroundColor White
    } else {
        Write-Host "Showing all $($allResults.Count) aliases" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "Type a search term to filter results or press Enter to exit search mode" -ForegroundColor DarkGray
    Write-Host ""

    # Print the table
    Write-Host $border -ForegroundColor White

    # Print header row (values in blue)
    Write-Host -NoNewline "| " -ForegroundColor White
    Write-Host -NoNewline $headerID.PadRight($idWidth) -ForegroundColor Blue
    Write-Host -NoNewline " | " -ForegroundColor White
    Write-Host -NoNewline $headerAlias.PadRight($aliasWidth) -ForegroundColor Blue
    Write-Host -NoNewline " | " -ForegroundColor White
    Write-Host $headerDesc.PadRight($descWidth) -ForegroundColor Blue

    Write-Host $border -ForegroundColor White

    # Print each data row with an incremental ID and a border between rows
    if ($filteredResults.Count -eq 0) {
        Write-Host "| " -NoNewline -ForegroundColor White
        Write-Host "No matching aliases found".PadRight($idWidth + $aliasWidth + $descWidth + 4) -ForegroundColor Red
        Write-Host $border -ForegroundColor White
    } else {
        $rowId = 1
        foreach ($row in $filteredResults) {
            Write-TableRow -col1 ([string]$rowId) -col2 $row.Alias -col3 $row.Description -width1 $idWidth -width2 $aliasWidth -width3 $descWidth
            Write-Host $border -ForegroundColor White
            $rowId++
        }
    }
}

# Initial display with the parameter-based search (if provided)
Show-FilteredResults -SearchTerm $Search

# Interactive search loop
while ($true) {
    Write-Host "Search: " -NoNewline -ForegroundColor Cyan
    $userSearch = Read-Host
    
    # Exit the search loop if user presses Enter without a search term
    if ($userSearch -eq "") {
        break
    }
    
    # Display filtered results based on user input
    Show-FilteredResults -SearchTerm $userSearch
}
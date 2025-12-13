<#
 * Project Name : New PowerShell Template File
 * File Name    : 00PS-TemplateFile.ps1
 * Author       : Sydnie Barnes
 * Created Date : 2025-12-13
 * Last Updated : 2025-12-13
 * Version      : v1.0.0
 * Description  : Creates a new PowerShell script file with a standard header and body template
 * Dependencies : N/A
 * Notes        : Adjust the directory, author, project name, and version as needed
#>

function New-PSTemplateFile {
    param (

        [Parameter(Mandatory=$true)]
        [string]$FileName,

        [Parameter(Mandatory=$true)]
        [string]$DestinationPath,

        [ValidateSet($true, $false)]
        [bool]$AddHeader


    )

    # Create the template file
    $createdFile = New-Item -Path $DestinationPath -Name "$FileName.ps1" -ItemType File -Force


    # Add the header to the file if specified
    if ($AddHeader) {
        $author = Get-LocalUser $env:USERNAME | Select-Object -ExpandProperty FullName
        $projectName = "New PowerShell Project"
        $version = "v1.0.0"
        $filePath    = $createdFile.FullName
        $fileName    = $createdFile.Name
        $createdDate = $createdFile.CreationTime.ToString("yyyy-MM-dd")
        $lastUpdated = (Get-Date).ToString("yyyy-MM-dd")

        # Build header
        $header = @"
<#
* Project Name : $projectName
* File Name    : $fileName
* Author       : $author
* Created Date : $createdDate
* Last Updated : $lastUpdated
* Version      : $version
* Description  : [Brief description of what this file does]
* Dependencies : [List any external libraries or modules]
* Notes        : [Any special considerations or instructions]
#>

"@

        # Insert header at the top
        $newContent = $header + "`r`n" + ($content -join "`r`n")
        Set-Content -Path $filePath -Value $newContent
        Write-Host "Header added to $fileName" -ForegroundColor Cyan
    }

    # Build the body text
    $bodyText = @"
# Import Modules

# Define Paths
`$inputPath = ""
`$outputPath = ""
`$date = Get-Date -Format "yyyy-MM-dd"
`$fileName = ""

# Define Variables


# Main Script Logic
"@

# Add the body text to the file
Add-Content -Path $createdFile.FullName -Value $bodyText

# Write Output
Write-Host "Template file '$FileName' created at '$DestinationPath'." -ForegroundColor Green

}
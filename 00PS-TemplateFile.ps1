<#
 * Project Name : New PowerShell Template File
 * File Name    : 00PS-TemplateFile.ps1
 * Author       : Sydnie Barnes
 * Created Date : 2025-12-13
 * Last Updated : 2025-12-16
 * Version      : v1.1.0
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

    # Get author name
    $authorName = Get-LocalUser $env:USERNAME -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -ErrorAction SilentlyContinue


    # Add the header to the file if specified
    if ($AddHeader) {
        $author = if ($authorName) {
            $authorName
        } else {
            [System.Security.Principal.WindowsIdentity]::GetCurrent().Name -replace '^.*\\', ''
        }
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


# Define defaults
$defaultDestinationPath = "H:\Users\sydnie.barnes\OneDrive - OC Tanner\Documents\00-Projects\PowershellScripts"

# Create a new project
$FileName = Read-Host "Enter a name for the project (without .ps1)"
$DestinationPath = Read-Host "Enter the path for the file. If no path is specified, $defaultDestinationPath is used."

# Assign destination path if no input is received
if ([string]::IsNullOrWhiteSpace($DestinationPath)) {
    $DestinationPath = $defaultDestinationPath
}

# Check for a valid path
if (Test-Path $DestinationPath) {
    do {
        $AddHeader = Read-Host "Add header? (Y/N)"
        switch ($AddHeader.ToUpper()) {
            "Y" {
                New-PSTemplateFile -FileName $FileName -DestinationPath $DestinationPath -AddHeader $true
            }
            "N" {
                New-PSTemplateFile -FileName $FileName -DestinationPath $DestinationPath -AddHeader $false
            }
            Default {
                Write-Host "Please make a valid header selection. (Y/N)" -ForegroundColor Red
            }
        }
    } until ($AddHeader -in @("Y","N"))
} else {
    Write-Host "Invalid path: $DestinationPath" -ForegroundColor Red
    Break
}

# Write output
$createdFile = Get-ChildItem -Path $DestinationPath -File "$FileName.ps1"
$openFile = Read-Host "File has been created at $($createdFile.FullName). Open the file in VScode? (Y/N)"

switch ($openFile) {
    "Y" {
        Invoke-Command -ScriptBlock {
            code "$($createdFile.FullName)"
        }
      }
    "N" {
        Write-host "Not opening the file."
    }
    Default {
        Write-Host "Not opening the file."
    }
}


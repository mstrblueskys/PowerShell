<#

Readme: This script uses a SharePoint document library as a deposit site
to host .xls files for conversion to .xlsx files and using metadata,
redistributes files to their eventual destinations.

Dependencies: SharePoint site with document library that has 2 custom
metadata columns called "Destination" and "DocLibraryPath". Also, the user
running this script needs read/write permissions on any "Destination" site.

Format for Destination data: https://[yourorg].sharepoint.com/sites/[site]/
Format for DocLibraryPath data: [DocLib Name]/[folderpath]

#>


# Set SharePoint Variables
$SiteURL = "https://[yourorg].sharepoint.com/sites/[conversionhostsite]"
$DocLibrary = "[doc library name]"

# Set Local Variables 
$Download = "Download"
$Upload = "Upload"
# Path
$FolderPath = "C:\Convert\"
# Folder that hosts the files to copy
$SourceDocs = $FolderPath + $Download  
# Local output folder 
$Converted   =  $FolderPath + $Upload 

# Check local file locations - create if they don't exist
If(!(Test-Path $SourceDocs)){
    New-Item -ItemType Directory -Path $FolderPath -Name $Download
}
If(!(Test-Path $Converted)){
    New-Item -ItemType Directory -Path $FolderPath -Name $Upload
}


# Connect to SharePoint 
Connect-PnPOnline -Url $SiteUrl -Interactive

# Get File Contents
$Files = Get-PnPListItem -List $DocLibrary

# Get excel libraries
Add-Type -AssemblyName Microsoft.Office.Interop.Excel
$ModernFormat = [Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbook

# Open GUI-less instance of Excel
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false 

ForEach ($File in $Files){
    
    # Grab details on the file and save it locally
    $Filename = $File.FieldValues["FileLeafRef"]
    $NewFilename = $Filename.Replace(".xls",".xlsx")
    $Destination = $File.FieldValues["Destination"]
    $DestPath = $File.FieldValues["DocLibraryPath"]
    Get-PnPFile -Url $File.FieldValues["FileRef"] -AsFile -Path $SourceDocs -filename $Filename
    $LocalFile = $SourceDocs + "\" + $Filename
    $NewFile = $Converted +"\"+ $NewFilename # Join-Path -Path $Converted -ChildPath $NewFilename
    Remove-PnPFile -ServerRelativeUrl $File.FieldValues["FileRef"] -Recycle -Force

    # Open file to be converted
    $workbook = $excel.Workbooks.Open($LocalFile)
        
    # Save as new workbook in new location

    $workbook.SaveAs($NewFile, $ModernFormat)
    $workbook.Close()

    Connect-PnPOnline -url $Destination -Interactive

    $FullPath = $Destination+"/"+$DestPath
    $RelativePath = $FullPath.Replace("https://[yourorg].sharepoint.com","")

    Add-PnPFile -Path $NewFile -Folder $DestPath
                
    # Remove old file
    Remove-Item -Path $LocalFile -Force
    Remove-Item -Path $NewFile -Force
}

$null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook)
$null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
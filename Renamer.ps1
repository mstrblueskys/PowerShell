####################################
#
#  Change Enhanced-NR to Developed
#        Matt 2-24-2025
#
#  Built with love for Tim
# 
#####################################

<# 

To use this, navigate to the folder where your photos live, copy the address,
and paste into the prompt. 

#>
$fPath = Read-Host "Where are your photos?"

Get-ChildItem -Path $fPath -Recurse | ForEach-Object {
    $bName = $_.Name.Replace("Enhanced-NR","Developed")
    Rename-Item -Path $_.FullName -NewName $bName
}
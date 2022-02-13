######################################################################
#
#  Written as a proof of concept should anyone need to scrub files
#  from a website. Set parameters for URL, MaxPage, and Crop number to 
#  correctly apply this to other sites.
#
#####################################################################

# Set vars

$URL = "https://www.thingiverse.com/thing:"
$Extension = "/zip"
$CropVar = 7
$Page = 1
$Filename = ""
$MaxPage = 9999999
$Zeros = "000000"

# Test Filepath
If(!(Test-Path "C:\ThingiverseDownload\")){
    New-Item -ItemType Directory -Path "C:\" -Name "ThingiverseDownload"
}

While ($Page -lt $MaxPage){
    # Build URL
    $ZerosPage = $Zeros + $Page
    $CropTo = $ZerosPage.Length - $CropVar
    $URLEnd = $ZerosPage.Substring($CropTo,$CropVar)
    $ThingPage = $URL + $URLEnd
    $Full = $URL + $URLEnd + $Extension
    $Full
    # Get Filename
    Try {$GetMetadata = Invoke-WebRequest $ThingPage}
    Catch {$exists = $false}
    finally {
    If($exists){
    $GetMetadata.Content -match "<title>(?<title>.*)</title>" | out-null
    $Filename = $matches['title']
    $Filename
    # Get File
    $OutFile = "C:\ThingiverseDownload\" + $Filename + ".zip"
    Invoke-WebRequest $Full -OutFile $OutFile
    }}
    $Filename = ""
    $exists = $true
    $Page ++ 
}

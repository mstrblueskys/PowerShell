$URL = "https://yb.cmcdn.com/yearbooks/6/6/8/3/6683bef625a7c508a2c9d85dd27a21dc/1100/"
$Extension = ".jpg"
$Page = 1
$MaxPage = 217
$Zeros = "0000"
While ($Page -lt $MaxPage){
    $ZerosPage = $Zeros + $Page
    $CropTo = $ZerosPage.Length -4
    $URLEnd = $ZerosPage.Substring($CropTo,4)
    $Full = $URL + $URLEnd + $Extension
    $OutFile = "C:\Yearbook\" + $Page + $Extension
    Invoke-WebRequest $Full -OutFile $OutFile
    $Page ++
}

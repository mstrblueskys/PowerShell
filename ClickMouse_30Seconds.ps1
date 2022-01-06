$ClickGo=1 

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$signature=@' 

[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)] 

public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo); 

'@  

$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 

While ($ClickGo = 1){ 

    $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0); 

    $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0); 

    Start-Sleep -Seconds 30

} 

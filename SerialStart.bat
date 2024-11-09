
@echo off
setlocal enabledelayedexpansion

del /q temp.ps1

set ARG_C=
set ARG_B=
set ARG_L=
set ARG_E=

set FLAG_NEXT=
for %%i in (%*) do (
    if /i "%%i"=="/c" (
        set FLAG_NEXT=C
    ) else if /i "%%i"=="/b" (
        set FLAG_NEXT=B
    ) else if /i "%%i"=="/l" (
        set FLAG_NEXT=L
    ) else if /i "%%i"=="/e" (
        set FLAG_NEXT=E
    ) else if defined FLAG_NEXT (
        set ARG_!FLAG_NEXT!=%%i
        set FLAG_NEXT=
    )
)


echo $c = New-Object System.IO.Ports.SerialPort "COM%ARG_C%", %ARG_B%, ([System.IO.Ports.Parity]::None)>temp.ps1
echo $c.NewLine = "`%ARG_L%">>temp.ps1
echo $c.Encoding=[System.Text.Encoding]::GetEncoding("%ARG_E%")>>temp.ps1
echo $d = Register-ObjectEvent -InputObject $c -EventName "DataReceived" `>>temp.ps1
echo    -Action {param([System.IO.Ports.SerialPort]$sender, [System.EventArgs]$e) `>>temp.ps1
echo        Write-Host -NoNewline $sender.ReadExisting()}>>temp.ps1
echo $c.Open()>>temp.ps1
echo for(;;){if([Console]::KeyAvailable){$c.Write(([Console]::ReadKey($true)).KeyChar)}}>>temp.ps1

powershell -NoProfile -ExecutionPolicy Unrestricted .\temp.ps1

endlocal
exit /b
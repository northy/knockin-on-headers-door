
# Set up MSVC environment
$vsPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional"

# https://stackoverflow.com/questions/2124753/how-can-i-use-powershell-with-the-visual-studio-command-prompt
Push-Location "$vsPath\Common7\Tools"
cmd /c "VsDevCmd.bat&set" |
ForEach-Object {
  if ($_ -match "=") {
    $v = $_.split("=", 2); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])" 
  }
}
Pop-Location

function AverageRuntime {
    param ([string]$Command)

    $Repetitions=5
    
    # Warmup
    Invoke-Expression "$Command"
    
    Write-Host -NoNewline "Running '$Command', $Repetitions times: "

    $sw = [Diagnostics.Stopwatch]::StartNew()
    for ($i = 1; $i -le $Repetitions; $i++) {
        Invoke-Expression "$Command" 2> $null 1> $null
    }
    $sw.Stop()
    $avg = $sw.Elapsed.TotalMilliseconds / $Repetitions
    $avg = [math]::round($avg, 1)
    
    Write-Host "took $avg milliseconds on average."
}

$cl = "cl.exe /std:c++latest /EHsc /nologo"
$iostream_ifc = "/headerUnit:angle iostream=iostream.ifc"
$stdcpp_ifc = "/headerUnit:quote stdcpp.h=stdcpp.h.ifc"
$headers_to_ifc = 'iostream','map','vector','algorithm','chrono','random','memory','cmath','thread'

$necessary_ifc = ''

foreach ($header in $headers_to_ifc)
{
    $necessary_ifc = "$necessary_ifc /headerUnit:angle $header=$header.ifc"
}

Write-Host "Building header units"

Invoke-Expression "$cl /c `"$env:VCToolsInstallDir\modules\std.ixx`""
Invoke-Expression "$cl /exportHeader /headerName:quote stdcpp.h"

foreach ($header in $headers_to_ifc)
{
    Invoke-Expression "$cl /exportHeader /headerName:angle $header"
}

Write-Host "Header units done, running benchmark"

AverageRuntime -Command "$cl /c include_necessary/hello_world.cpp"
AverageRuntime -Command "$cl /I. /c include_stdcpp_h/hello_world.cpp"
AverageRuntime -Command "$cl $iostream_ifc /c import_necessary/hello_world.cpp"
AverageRuntime -Command "$cl $stdcpp_ifc /c import_stdcpp_h/hello_world.cpp"
AverageRuntime -Command "$cl /c import_std/hello_world.cpp"


AverageRuntime -Command "$cl /c include_necessary/mix.cpp"
AverageRuntime -Command "$cl /I. /c include_stdcpp_h/mix.cpp"
AverageRuntime -Command "$cl $necessary_ifc /c import_necessary/mix.cpp"
AverageRuntime -Command "$cl $stdcpp_ifc /c import_stdcpp_h/mix.cpp"
AverageRuntime -Command "$cl /c import_std/mix.cpp"


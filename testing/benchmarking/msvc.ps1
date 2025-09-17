
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
    Invoke-Expression "$Command" 2> $null 1> $null
    
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

$cl = "cl.exe /std:c++latest /EHsc"


AverageRuntime -Command "$cl /c include_necessary/hello_world.cpp"
AverageRuntime -Command "$cl /I. /c include_all/hello_world.cpp"
AverageRuntime -Command "$cl /c import_necessary/hello_world.cpp"
AverageRuntime -Command "$cl /I. /c import_all/hello_world.cpp"
AverageRuntime -Command "$cl /c import_std/hello_world.cpp"


AverageRuntime -Command "$cl /c include_necessary/mix.cpp"
AverageRuntime -Command "$cl /I. /c include_all/mix.cpp"
AverageRuntime -Command "$cl /c import_necessary/mix.cpp"
AverageRuntime -Command "$cl /I. /c import_all/mix.cpp"
AverageRuntime -Command "$cl /c import_std/mix.cpp"


$VCToolsInstallDir = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207"
cl /nologo /EHsc /std:c++latest /c "$VCToolsInstallDir\modules\std.ixx"

cl /nologo /EHsc /std:c++latest /interface /TP private_dep\Private.cppm /c
lib /nologo Private.obj /out:Private.lib

cl /nologo /EHsc /std:c++latest /interface /TP UserFacing.cppm /c
lib /nologo UserFacing.obj /out:UserFacing.lib

Remove-Item Private.ifc

cl /nologo /EHsc /std:c++latest main.cpp UserFacing.lib Private.lib std.obj

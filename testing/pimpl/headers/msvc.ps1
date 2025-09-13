cl /nologo /EHsc /std:c++latest /I private_dep /c UserFacing.cpp

cl /nologo /EHsc /std:c++latest main.cpp UserFacing.obj

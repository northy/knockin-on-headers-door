cl /std:c++latest /nologo /EHsc /exportHeader /Fo /MP stdcpp.h
cl /std:c++latest /nologo /EHsc import_stdcpp.cpp /headerUnit stdcpp.h=stdcpp.h.ifc stdcpp.obj

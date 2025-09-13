## MSVC v143 (cl.exe version 19.44.35213)

```txt
third_party/pointlib/point.h(3): error C2011: 'Point': 'struct' type redefinition
third_party/mathlib/third_party/pointlib/point.h(3): note: see declaration of 'Point'
.\main.cpp(6): error C2079: 'p1' uses undefined struct 'Point'
.\main.cpp(7): error C2079: 'p2' uses undefined struct 'Point'
```

## clang version 20.1.8

```txt
In file included from main.cpp:2:
./third_party/pointlib/point.h:3:8: error: redefinition of 'Point'
    3 | struct Point
      |        ^
./third_party/mathlib/third_party/pointlib/point.h:3:8: note: previous definition is here
    3 | struct Point
      |        ^
1 error generated.
```

## g++ (GCC) 15.2.1 20250813

Ok.

#!/usr/bin/env sh

if [ ! -f std.pcm ]; then
    echo "Compiling std module..."
    /usr/bin/clang++ -std=c++23 -stdlib=libc++ -O3 /usr/share/libc++/v1/std.cppm -Wno-reserved-module-identifier --precompile
fi

if [ ! -f stdcpp.pcm ]; then
    echo "Compiling stdcpp module..."
    /usr/bin/clang++ -std=c++23 -fmodule-header stdcpp.h
fi

stlHeaders=(
    'iostream'
    'map'
    'vector'
    'algorithm'
    'chrono'
    'random'
    'memory'
    'cmath'
    'thread'
)

for header in "${stlHeaders[@]}"
do
    if [ ! -f "$header".pcm ]; then
        echo "Compiling $header module..."
        /usr/bin/clang++ -stdlib=libc++ -std=c++23 -xc++-system-header --precompile "$header" -o "${header}.pcm" -Wno-user-defined-literals -Wno-pragma-system-header-outside-header
    fi
done

hyperfine --warmup 5 -N \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 include_necessary/hello_world.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -I. include_stdcpp_h/hello_world.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -fmodule-file=iostream.pcm import_necessary/hello_world.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -I. -fmodule-file=stdcpp.pcm import_stdcpp_h/hello_world.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -fmodule-file=std=std.pcm import_std/hello_world.cpp'

hyperfine --warmup 5 -N \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 include_necessary/mix.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -I. include_stdcpp_h/mix.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -I. -fmodule-file=stdcpp.pcm import_stdcpp_h/mix.cpp' \
    '/usr/bin/clang++ -c -stdlib=libc++ -std=c++23 -fmodule-file=std=std.pcm import_std/mix.cpp'

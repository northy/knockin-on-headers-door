#!/usr/bin/env sh

if [ ! -f gcm.cache/std.gcm ]; then
    echo "Compiling std module..."
    /usr/bin/g++ -std=c++23 -O3 -fmodules -fsearch-include-path bits/std.cc -c
fi

if [ ! -f gcm.cache/,/stdcpp.h.gcm ]; then
    echo "Compiling stdcpp module..."
    /usr/bin/g++ -std=c++23 -fmodules -fmodule-header stdcpp.h
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
    if [ ! -f "gcm.cache/usr/include/c++/15/$header".gcm ]; then
        echo "Compiling $header module..."
        /usr/bin/g++ -std=c++23 -fmodules-ts -x c++-system-header "$header"
    fi
done

hyperfine --warmup 5 -N \
    '/usr/bin/g++ -c -std=c++23 include_necessary/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -I. include_all/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_necessary/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules -I. import_all/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_std/hello_world.cpp'

hyperfine --warmup 5 -N \
    '/usr/bin/g++ -c -std=c++23 include_necessary/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -I. include_all/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_necessary/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules -I. import_all/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_std/mix.cpp'

#!/usr/bin/env sh

if [ ! -f gcm.cache/std.gcm ]; then
    echo "Compiling std module..."
    /usr/bin/g++ -std=c++23 -O3 -fmodules -fsearch-include-path bits/std.cc -c
fi

if [ ! -f gcm.cache/,/stdcpp.h.gcm ]; then
    echo "Compiling stdcpp header unit..."
    /usr/bin/g++ -std=c++23 -fmodules -fmodule-header stdcpp.h
fi

stlHeaders=(
    'algorithm'
    'any'
    'array'
    'atomic'
    'barrier'
    'bit'
    'bitset'
    'charconv'
    'chrono'
    'cmath'
    'codecvt'
    'compare'
    'complex'
    'concepts'
    'condition_variable'
    'deque'
    'exception'
    'expected'
    'filesystem'
    'format'
    'forward_list'
    'fstream'
    'functional'
    'future'
    'initializer_list'
    'iomanip'
    'ios'
    'iosfwd'
    'iostream'
    'istream'
    'iterator'
    'latch'
    'limits'
    'list'
    'locale'
    'map'
    'memory'
    'memory_resource'
    'mutex'
    'new'
    'numbers'
    'numeric'
    'optional'
    'ostream'
    'print'
    'queue'
    'random'
    'ranges'
    'ratio'
    'regex'
    'scoped_allocator'
    'semaphore'
    'set'
    'shared_mutex'
    'source_location'
    'span'
    'sstream'
    'stack'
    'stdexcept'
    'stop_token'
    'streambuf'
    'string'
    'string_view'
    'syncstream'
    'system_error'
    'thread'
    'tuple'
    'type_traits'
    'typeindex'
    'typeinfo'
    'unordered_map'
    'unordered_set'
    'utility'
    'valarray'
    'variant'
    'vector'
    'version'
)

for header in "${stlHeaders[@]}"
do
    if [ ! -f "gcm.cache/usr/include/c++/15/$header".gcm ]; then
        echo "Compiling $header header unit..."
        /usr/bin/g++ -std=c++23 -fmodules-ts -x c++-system-header "$header"
    fi
done

hyperfine --warmup 5 -N \
    '/usr/bin/g++ -c -std=c++23 include_necessary/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 include_all/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -I. include_stdcpp_h/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_necessary/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_all/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules -I. import_stdcpp_h/hello_world.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_std/hello_world.cpp'

hyperfine --warmup 5 -N \
    '/usr/bin/g++ -c -std=c++23 include_necessary/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 include_all/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -I. include_stdcpp_h/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_necessary/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_all/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules -I. import_stdcpp_h/mix.cpp' \
    '/usr/bin/g++ -c -std=c++23 -fmodules import_std/mix.cpp'

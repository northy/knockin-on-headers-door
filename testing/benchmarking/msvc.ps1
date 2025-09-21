$cl = "cl.exe /std:c++latest /EHsc /nologo"

if (-not (Test-Path -Path 'std.ifc')) {
    Invoke-Expression "$cl /c `"$env:VCToolsInstallDir\modules\std.ixx`""
}

if (-not (Test-Path -Path 'stdcpp.h.ifc')) {
    Invoke-Expression "$cl /exportHeader /headerName:quote stdcpp.h"
}
$stdcpp_ifc = '/headerUnit:quote stdcpp.h=stdcpp.h.ifc'

$stl_headers = @(
    'algorithm',
    'any',
    'array',
    'atomic',
    'barrier',
    'bit',
    'bitset',
    'charconv',
    'chrono',
    'cmath',
    'codecvt',
    'compare',
    'complex',
    'concepts',
    'condition_variable',
    'deque',
    'exception',
    'expected',
    'filesystem',
    'format',
    'forward_list',
    'fstream',
    'functional',
    'future',
    'initializer_list',
    'iomanip',
    'ios',
    'iosfwd',
    'iostream',
    'istream',
    'iterator',
    'latch',
    'limits',
    'list',
    'locale',
    'map',
    'memory',
    'memory_resource',
    'mutex',
    'new',
    'numbers',
    'numeric',
    'optional',
    'ostream',
    'print',
    'queue',
    'random',
    'ranges',
    'ratio',
    'regex',
    'scoped_allocator',
    'semaphore',
    'set',
    'shared_mutex',
    'source_location',
    'span',
    'sstream',
    'stack',
    'stdexcept',
    'stop_token',
    'streambuf',
    'string',
    'string_view',
    'syncstream',
    'system_error',
    'thread',
    'tuple',
    'type_traits',
    'typeindex',
    'typeinfo',
    'unordered_map',
    'unordered_set',
    'utility',
    'valarray',
    'variant',
    'vector',
    'version'
)

$all_ifc_options = ""

ForEach ($header in $stl_headers) {
    if (-not (Test-Path -Path "$header.ifc")) {
        Invoke-Expression "$cl /exportHeader /headerName:angle /Fo /MP $header"
    }
    $all_ifc_options += ' /headerUnit:angle'
    $all_ifc_options += " $header=$header.ifc"
}

$hello_world_ifcs = '/headerUnit:angle iostream=iostream.ifc'
$mix_ifcs = '/headerUnit:angle iostream=iostream.ifc /headerUnit:angle map=map.ifc /headerUnit:angle vector=vector.ifc /headerUnit:angle algorithm=algorithm.ifc /headerUnit:angle chrono=chrono.ifc /headerUnit:angle random=random.ifc /headerUnit:angle memory=memory.ifc /headerUnit:angle cmath=cmath.ifc /headerUnit:angle thread=thread.ifc'

hyperfine --warmup 5 -N `
    "$cl /c include_necessary/hello_world.cpp" `
    "$cl /I. /c include_all/hello_world.cpp" `
    "$cl /I. /c include_stdcpp_h/hello_world.cpp" `
    "$cl $hello_world_ifcs /c import_necessary/hello_world.cpp" `
    "$cl $all_ifc_options /c import_all/hello_world.cpp" `
    "$cl $stdcpp_ifc /c import_stdcpp_h/hello_world.cpp" `
    "$cl /c import_std/hello_world.cpp"

hyperfine --warmup 5 -N `
    "$cl /c include_necessary/mix.cpp" `
    "$cl /c include_all/mix.cpp" `
    "$cl /I. /c include_stdcpp_h/mix.cpp" `
    "$cl $mix_ifcs /c import_necessary/mix.cpp" `
    "$cl $all_ifc_options /c import_all/mix.cpp" `
    "$cl $stdcpp_ifc /c import_stdcpp_h/mix.cpp" `
    "$cl /c import_std/mix.cpp"

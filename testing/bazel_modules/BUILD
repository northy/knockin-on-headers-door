load("@rules_cpp23_modules//cc_module:defs.bzl", "cc_module", "cc_module_binary", "cc_compiled_module")

cc_compiled_module(
    name="std",
    cmi="std.pcm"
)

cc_module(
    name = "lib",
    src = "lib.cppm",
    impl_srcs = ["lib.impl.cpp",],
    deps = [":std"],
    copts = ["-fmodule-file=std=std.pcm", "-std=c++23", "-stdlib=libc++"],
)

cc_module_binary(
    name = "main",
    srcs = ["main.cpp",],
    deps = [":lib", ":std"],
    copts = ["-fmodule-file=std=std.pcm", "-std=c++23"],
    linkopts = ["-stdlib=libc++"],
)

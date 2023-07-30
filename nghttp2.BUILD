load("@rules_foreign_cc//foreign_cc:cmake.bzl", "cmake")

filegroup(
    name = "all",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

cmake(
    name = "nghttp2",
    cache_entries = select({
        "//conditions:default": {
            "ENABLE_LIB_ONLY": "on",
            "ENABLE_SHARED_LIB": "off",
            "ENABLE_STATIC_LIB": "on",
            "CMAKE_INSTALL_LIBDIR": "lib",
            "CMAKE_CXX_COMPILER_FORCED": "on",
        },
    }),
    defines = ["NGHTTP2_STATICLIB"],
    generate_args = ["-GNinja"],
    lib_source = "//:all",
    out_static_libs = select({
        "//conditions:default": ["libnghttp2.a"],
    }),
    targets = [
        "",
        "install",
    ],
    visibility = ["//visibility:public"],
)

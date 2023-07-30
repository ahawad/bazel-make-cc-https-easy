alias(
    name = "curl",
    actual = select({
        # macOS: bundles libcurl, and includes it as part of its API, even if it's not documented
        # See: https://developer.apple.com/forums/thread/93624
        # Other Apple platforms do not bundle libcurl, as per that post. You can also check by running
        # ls /Applications/Xcode.app/Contents/Developer/Platforms/***/curl.h
        # (*** follows symlinks)
        "@platforms//os:macos": ":system",
        # Linux: Libcurl is usually preinstalled--though one needs to install headers to compile,
        # e.g. sudo apt-get install libcurl4-openssl-dev
        # For more install instructions, see libcurl in  https://everything.curl.dev/get/linux
        # More generally, even for deps that aren't preinstalled, Linux, unlike most other platforms, usually has a functional package management system built in, so we should be linking to pre-installed libraries--and sharing them across the system--rather than bundling everything.
        "@platforms//os:linux": ":source",
        # iOS: you might be concerned about cURL using BSD sockets, and old references in the docs to that not waking the cellular modem. That seems to not have been an issue since push notifications. See https://developer.apple.com/forums/thread/48996
        # Android:
        # Doesn't appear to bundle libcurl.
        # ls external/androidndk/ndk/***/*curl*
        # Someday there might be a prefab AAR version that's official/widely enough used that we should depend on it via Maven, but that day is not today. The only one I currently see is https://github.com/vvb2060/curl-android, and I think I'd need to see something a bit more official to switch.
        # Windows: started bundling curl.exe in a release of Windows 10, but not in older versions. I don't know if they bundle libcurl, but regardless, we should bundle it to support older versions of Windows
        "//conditions:default": ":source",
    }),
    visibility = ["//visibility:public"],
)

# For OSs that bundle libcurl
cc_library(
    name = "system",
    linkopts = ["-lcurl"],
)

# Defines need updates to match https://github.com/curl/curl/commits/master/CMakeLists.txt
# Done up to (but not including) 7/26/23 for 8.2.1 -- awaiting next release
# Flag sets fetched originally from CURL's ./configure. See https://curl.se/docs/install.html. The easiest way is to download the release archives rather than pure source, getting a pre-generated configure script, but you could also generate it for yourself with the instructions in GIT-INFO.
# For Android, you can generate boringssl's libssl & libcrypto from the bazel-generated archives using:
# $ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-ar -rs bazel-out/android-arm64-v8a-opt/bin/external/boringssl/_objs/crypto/libcrypto.a bazel-out/android-arm64-v8a-opt/bin/external/boringssl/_objs/crypto/*.o
# $ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-ar -rs bazel-out/android-arm64-v8a-opt/bin/external/boringssl/_objs/ssl/libssl.a bazel-out/android-arm64-v8a-opt/bin/external/boringssl/_objs/ssl/*.o
# Went through manually, diffing, and adding by category if the define looked like it could actually be used in lib for HTTP.
# As a file filter to use for seeing if a define was used, include `lib, include` and exclude `lib/curl_config*.h*, config-*.h`
# Tensorflow has a file. It's not the cleanest, and it has some real issues (https://github.com/tensorflow/tensorflow/issues/58018)...but it's a decent reference: https://github.com/tensorflow/tensorflow/blob/master/third_party/curl.BUILD
cc_library(
    name = "source",
    srcs = glob([
        "lib/**/*.c",
        "lib/**/*.h",
    ]),
    hdrs = glob([
        "include/curl/*.h",
    ]),
    copts = [
        # Suppress curl warnings, figuring it's a popular enough dependency that the user will treat it as a black box.
        # If find you can remove these without getting warnings, then do so.
        "-Wno-deprecated-declarations",
        "-Wno-pointer-bool-conversion",
        # Because there's no local_includes attribute. CS filed at https://github.com/bazelbuild/bazel/issues/16472
        "-Iexternal/curl/lib",
    ],
    includes = ["include"],
    linkopts = ["-lz"],  # Android and Apple OSs bundle zlib. For Windows, see if we can reuse Boost's, but should have a flag to control whether it's bundled. It's less of a no brainer when the OS doesn't provide it. See also discussion in https://github.com/nelhage/rules_boost/issues/274
    local_defines = [
        "BUILDING_LIBCURL",
        "USE_NGHTTP2",
        "ENABLE_IPV6",
        "CURL_DISABLE_NTLM",  # Proprietary Microsoft auth you almost certainly don't need.
        # Generally, disabling features didn't seem to reduce library size much. Tried proxy, progress, auth. Reductions were only ~10kb, so we'll leave them in.
        "USE_THREADS_POSIX",
        "USE_UNIX_SOCKETS",
        "CURL_SA_FAMILY_T=sa_family_t",
        # Could replace these with a header that has __has_include, if we ever wanted. Tensorflow's file has an example of injecting a header like that.
        "STDC_HEADERS",
        "HAVE_ALARM",
        "HAVE_ARC4RANDOM",
        "HAVE_ARPA_INET_H",
        "HAVE_ARPA_TFTP_H",
        "HAVE_ATOMIC",
        "HAVE_BASENAME",
        "HAVE_BOOL_T",
        "HAVE_BROTLI",
        "HAVE_BROTLI_DECODE_H",
        "HAVE_CLOCK_GETTIME_MONOTONIC",
        "HAVE_CLOCK_GETTIME_MONOTONIC_RAW",
        "HAVE_CONNECT",
        "HAVE_DECL_GETPWUID_R",
        "HAVE_DLFCN_H",
        "HAVE_FCHMOD",
        "HAVE_FCNTL",
        "HAVE_FCNTL_H",
        "HAVE_FCNTL_O_NONBLOCK",
        "HAVE_FNMATCH",
        "HAVE_FORK",
        "HAVE_FREEADDRINFO",
        "HAVE_FSETXATTR",
        "HAVE_FSETXATTR_5",
        "HAVE_FTRUNCATE",
        "HAVE_GETADDRINFO",
        "HAVE_GETADDRINFO_THREADSAFE",
        "HAVE_GETEUID",
        "HAVE_GETHOSTBYNAME",
        "HAVE_GETHOSTBYNAME_R",
        "HAVE_GETHOSTBYNAME_R_6",
        "HAVE_GETHOSTNAME",
        "HAVE_GETIFADDRS",
        "HAVE_GETPEERNAME",
        "HAVE_GETPPID",
        "HAVE_GETPWUID",
        "HAVE_GETPWUID_R",
        "HAVE_GETRLIMIT",
        "HAVE_GETSOCKNAME",
        "HAVE_GETTIMEOFDAY",
        "HAVE_GMTIME_R",
        "HAVE_IDN2_H",
        "HAVE_IFADDRS_H",
        "HAVE_IF_NAMETOINDEX",
        "HAVE_INET_NTOP",
        "HAVE_INET_PTON",
        "HAVE_INTTYPES_H",
        "HAVE_LBER_H",
        "HAVE_LDAP_H",
        "HAVE_LDAP_INIT_FD",
        "HAVE_LDAP_SSL",
        "HAVE_LDAP_URL_PARSE",
        "HAVE_LIBBROTLIDEC",
        "HAVE_LIBGEN_H",
        "HAVE_LIBIDN2",
        "HAVE_LIBRTMP_RTMP_H",
        "HAVE_LIBZ",
        "HAVE_LIBZSTD",
        "HAVE_LINUX_TCP_H",
        "HAVE_LOCALE_H",
        "HAVE_LONGLONG",
        "HAVE_MSG_NOSIGNAL",
        "HAVE_NETDB_H",
        "HAVE_NET_IF_H",
        "HAVE_NETINET_IN_H",
        "HAVE_NETINET_TCP_H",
        "HAVE_NETINET_UDP_H",
        "HAVE_NGHTTP2_NGHTTP2_H",
        "HAVE_PIPE",
        "HAVE_POLL_FINE",
        "HAVE_POLL_H",
        "HAVE_POSIX_STRERROR_R",
        "HAVE_PTHREAD_H",
        "HAVE_PWD_H",
        "HAVE_RECV",
        "HAVE_SCHED_YIELD",
        "HAVE_SELECT",
        "HAVE_SEND",
        "HAVE_SENDMSG",
        "HAVE_SETJMP_H",
        "HAVE_SETLOCALE",
        "HAVE_SETRLIMIT",
        "HAVE_SIGACTION",
        "HAVE_SIGINTERRUPT",
        "HAVE_SIGNAL",
        "HAVE_SIGNAL_H",
        "HAVE_SIGSETJMP",
        "HAVE_SNPRINTF",
        "HAVE_SOCKADDR_IN6_SIN6_SCOPE_ID",
        "HAVE_SOCKET",
        "HAVE_SOCKETPAIR",
        "HAVE_STDATOMIC_H",
        "HAVE_STDBOOL_H",
        "HAVE_STDINT_H",
        "HAVE_STDIO_H",
        "HAVE_STDLIB_H",
        "HAVE_STRCASECMP",
        "HAVE_STRDUP",
        "HAVE_STRERROR_R",
        "HAVE_STRING_H",
        "HAVE_STRINGS_H",
        "HAVE_STRTOK_R",
        "HAVE_STRTOLL",
        "HAVE_STRUCT_SOCKADDR_STORAGE",
        "HAVE_STRUCT_TIMEVAL",
        "HAVE_SUSECONDS_T",
        "HAVE_SYS_IOCTL_H",
        "HAVE_SYS_PARAM_H",
        "HAVE_SYS_POLL_H",
        "HAVE_SYS_RESOURCE_H",
        "HAVE_SYS_SELECT_H",
        "HAVE_SYS_SOCKET_H",
        "HAVE_SYS_STAT_H",
        "HAVE_SYS_TIME_H",
        "HAVE_SYS_TYPES_H",
        "HAVE_SYS_UIO_H",
        "HAVE_SYS_UN_H",
        "HAVE_SYS_WAIT_H",
        "HAVE_SYS_XATTR_H",
        "HAVE_TERMIO_H",
        "HAVE_TERMIOS_H",
        "HAVE_UNISTD_H",
        "HAVE_UTIME_H",
        "HAVE_UTIMES",
        "HAVE_VARIADIC_MACROS_C99",
        "HAVE_VARIADIC_MACROS_GCC",
        "HAVE_WRITABLE_ARGV",
        "HAVE_ZSTD_H",
    ] + select({
        "@platforms//cpu:arm64": [
            "SIZEOF_LONG=8",
            "SIZEOF_SIZE_T=8",
            "SIZEOF_TIME_T=8",
            "SIZEOF_CURL_SOCKET_T=8",
        ],
        "@platforms//cpu:armv7": [
            "SIZEOF_LONG=4",
            "SIZEOF_SIZE_T=4",
            "SIZEOF_TIME_T=4",
            "SIZEOF_CURL_SOCKET_T=4",
        ],
        "@platforms//cpu:x86_64": [
            "SIZEOF_LONG=8",
            "SIZEOF_SIZE_T=8",
            "SIZEOF_TIME_T=8",
            "SIZEOF_CURL_SOCKET_T=8",
        ],
        "@platforms//cpu:x86_32": [
            "SIZEOF_LONG=4",
            "SIZEOF_SIZE_T=4",
            "SIZEOF_TIME_T=4",
            "SIZEOF_CURL_SOCKET_T=4",
        ],
    }) + select({
        "@platforms//os:android": [
            "USE_OPENSSL",
            "HAVE_BORINGSSL",
            "CURL_CA_PATH=\\\"/system/etc/security/cacerts\\\"",
            "HAVE_LINUX_TCP_H",
            "HAVE_NETINET_IN6_H",
            "HAVE_POLL_FINE",
            "HAVE_RAND_EGD",
        ],
        "@platforms//os:linux": [
            "USE_OPENSSL",
            "HAVE_BORINGSSL",
            "CURL_CA_PATH=\\\"/system/etc/security/cacerts\\\"",
            "HAVE_CLOCK_GETTIME_MONOTONIC",
            "HAVE_GETHOSTBYNAME_R",
            "HAVE_GETHOSTBYNAME_R_6",
            "HAVE_GETIFADDRS",
            "HAVE_LINUX_TCP_H",
            "HAVE_MEMRCHR",
            # "HAVE_NETINET_IN6_H",
            "HAVE_POLL_FINE",
            "HAVE_RAND_EGD",
        ],
        # Merge these together if/when https://github.com/bazelbuild/platforms/issues/37 is resolved.
        "@platforms//os:macos": [
            "USE_SECTRANSP",
            "HAVE_GETIFADDRS",
            "HAVE_MACH_ABSOLUTE_TIME",
            "HAVE_SYS_SOCKIO_H",
        ],
        "@platforms//os:ios": [
            "USE_SECTRANSP",
            "HAVE_GETIFADDRS",
            "HAVE_MACH_ABSOLUTE_TIME",
            "HAVE_SYS_SOCKIO_H",
        ],
        "@platforms//os:tvos": [
            "USE_SECTRANSP",
            "HAVE_GETIFADDRS",
            "HAVE_MACH_ABSOLUTE_TIME",
            "HAVE_SYS_SOCKIO_H",
        ],
        "@platforms//os:watchos": [
            "USE_SECTRANSP",
            "HAVE_GETIFADDRS",
            "HAVE_MACH_ABSOLUTE_TIME",
            "HAVE_SYS_SOCKIO_H",
        ],
        # WinSSL windows USE_SCHANNEL
    }) + [
        "HAVE_LIBZ",
        # See https://github.com/hedronvision/bazel-make-cc-https-easy/issues/2 if you're looking for more compression libraries
    ],
    deps = select({
        "@platforms//os:linux": [
            "@boringssl//:ssl",
            "@nghttp2",
        ],
        "@platforms//os:android": ["@boringssl//:ssl"],
        # Merge these together if/when https://github.com/bazelbuild/platforms/issues/37 is resolved.
        "@platforms//os:macos": [":Apple"],
        "@platforms//os:ios": [":Apple"],
        "@platforms//os:tvos": [":Apple"],
        "@platforms//os:watchos": [":Apple"],
    }),
)

objc_library(
    name = "Apple",
    sdk_frameworks = [
        "CoreFoundation",
        "Security",
    ],
)

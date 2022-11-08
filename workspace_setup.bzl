# Do not change the filename; it is part of the user interface.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def hedron_make_cc_https_easy():
    """Setup a WORKSPACE so you can easily make https requests from C++.

    Ensures you have CPR, whose interface you want to use...
    ... and its dependncies: curl and boringssl.
    """

    # Unified setup for users' WORKSPACES and this workspace when used standalone.
    # See invocations in:
    #     README.md (for users)
    #     WORKSPACE (for working on this repo standalone)

    maybe(
        http_archive,
        name = "cpr",
        patches = ["@hedron_make_cc_https_easy//:cpr.patch"], # Minor. Just removes version-define header from unbrella header <cpr/cpr.h>, since it's generated by cmake and we don't need it. If needed, could hack it in like https://github.com/curoky/tame/blob/c8926a2cd569848137ebb971a95057cb117055c3/recipes/c/cpr/default/BUILD
        build_file = "@hedron_make_cc_https_easy//:cpr.BUILD",
        url = "https://github.com/libcpr/cpr/archive/1.9.2.tar.gz",
        sha256 = "3bfbffb22c51f322780d10d3ca8f79424190d7ac4b5ad6ad896de08dbd06bf31",
        strip_prefix = "cpr-1.9.2",
    )

    # CPR wraps libcurl
    # Note: libcurl updates are auto-PRd but not auto-merged, because the defines required to build it change frequently enough that you need to manually keep curl.BUILD in sync with https://github.com/curl/curl/commits/master/CMakeLists.txt. @cpsauer is responsible.
    maybe(
        http_archive,
        name = "curl",
        build_file = "@hedron_make_cc_https_easy//:curl.BUILD",
        url = "https://github.com/curl/curl/archive/curl-7_86_0.tar.gz",
        sha256 = "8085bfc250ffa6f3b5b1b05bea42b368a0361ede004f7c2b9edf102a59e8efb4",
        strip_prefix = "curl-curl-7_86_0",
    )

    # libcurl needs to bundle an SSL library on Android. We're using boringssl because it has easy Bazel support. Despite it's Google-only orientation, it's also used in, e.g., Envoy. But if LibreSSL had Bazel wrappings, we'd probably consider it.
    # We're pointing our own mirror of google/boringssl:master-with-bazel to get Renovate auto-update. Otherwise, Renovate will keep moving us back to master, which doesn't support Bazel. See https://github.com/renovatebot/renovate/issues/18492
    maybe(
        http_archive,
        name = "boringssl",
        url = "https://github.com/hedronvision/boringssl/archive/71d6b947ba65b64da75425d319b16b43b26feced.tar.gz",
        sha256 = "d88ce5f69555587294b76d79675ffb6f7ad752b14904acd359c267b94f2b89de",
        strip_prefix = "boringssl-71d6b947ba65b64da75425d319b16b43b26feced",
    )

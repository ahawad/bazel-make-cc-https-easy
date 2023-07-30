# This file existed originally to enable quick local development via local_repository.
    # See ./ImplementationReadme.md for details on local development.
    # Why? local_repository didn't work without a WORKSPACE, and new_local_repository required overwriting the BUILD file (as of Bazel 5.0).

workspace(name = "hedron_make_cc_https_easy")

http_archive(
    name = "rules_foreign_cc",
    sha256 = "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
    strip_prefix = "rules_foreign_cc-0.9.0",
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.9.0.tar.gz",
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")


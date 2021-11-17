load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def shlib_rules_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_starlib",
        sha256 = "1f5c6b13243a1a6f79742a8a0e883f7f4591f7890a388f87c8323f4242dc718d",
        strip_prefix = "bazel-starlib-0.1.0",
        urls = ["https://github.com/cgrindel/bazel-starlib/archive/v0.1.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bzlformat",
        sha256 = "b45b392613092b42c4ee94051be104b990e3c8651dea17410dfd63b98957cd57",
        strip_prefix = "rules_bzlformat-0.1.0",
        urls = ["https://github.com/cgrindel/rules_bzlformat/archive/v0.1.0.tar.gz"],
    )

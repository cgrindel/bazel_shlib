# Shlib 

Shlib is a library of Bash shell functions that are useful when implementing shell binaries, libraries, and tests.


## Quickstart

The following provides a quick introduction on how to get started using the libraries in this
repository.

###  Workspace Configuration

Add the following to your `WORKSPACE` file.

```python
# TODO: Add http_archive command after release.

load("//:deps.bzl", "shlib_rules_dependencies")

shlib_rules_dependencies()

load("@cgrindel_rules_bzlformat//bzlformat:deps.bzl", "bzlformat_rules_dependencies")

bzlformat_rules_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@cgrindel_bazel_starlib//:deps.bzl", "bazel_starlib_dependencies")

bazel_starlib_dependencies()

load("@cgrindel_rules_updatesrc//updatesrc:deps.bzl", "updatesrc_rules_dependencies")

updatesrc_rules_dependencies()
```

### Reference Libraries As Dependencies

Add the desired library and the Bazel runfiles as a dependency to your shell binary, library, or
test declaration. In this example, the
[sh_binary](https://docs.bazel.build/versions/main/be/shell.html#sh_binary) has a dependeny on the
`paths.sh` library.

```python
sh_binary(
    name = "foo",
    srcs = ["foo.sh"],
    deps = [
        "@bazel_tools//tools/bash/runfiles",
        "@cgrindel_bazel_shlib//lib:paths",
    ],
)
```

### Source The Library And Use It

In your shell script, add the following to source the library. 

```sh
# Load the library file
paths_lib="$(rlocation cgrindel_bazel_shlib/lib/paths.sh)"
source "${paths_lib}"

# ...

# Use the library functions
foo_path="$(normalize_path "${foo_path}")"
```

If you want to avoid sourcing a library that has already been loaded, the following code will check
if the library is already loaded.

```sh
# Load the library file, it it is not already loaded.
if [[ $(type -t cgrindel_bazel_shlib_lib_paths_loaded) != function ]]; then
  paths_lib="$(rlocation cgrindel_bazel_shlib/lib/paths.sh)"
  source "${paths_lib}"
fi
```

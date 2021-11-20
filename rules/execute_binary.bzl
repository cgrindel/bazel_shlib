# def execute_binary(name, binary, args = []):
#     native.sh_binary(
#         name = name,
#         srcs = ["@cgrindel_bazel_shlib//rules:execute_binary.sh"],
#         data = [binary],
#         args = ["--binary", "$(location " + binary + ")"] + args,
#         deps = [
#             "@cgrindel_bazel_shlib//lib:messages",
#             "@bazel_tools//tools/bash/runfiles",
#         ],
#     )

def _execute_binary_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
    bin_path = ctx.executable.binary.short_path

    ctx.actions.write(
        output = out,
        is_executable = True,
        content = """\
#!/usr/bin/env bash

args=()
""" + "\n".join([
            """args+=( "{arg}" )""".format(arg = arg)
            for arg in ctx.attr.args
        ]) + """
if [[ ${#args[@]} > 0 ]]; then
""" + """\
"{binary}" "${{args[@]}}"
else
"{binary}"
fi
""".format(binary = bin_path),
    )
    runfiles = ctx.runfiles()
    runfiles = runfiles.merge(ctx.attr.binary[DefaultInfo].default_runfiles)

    return DefaultInfo(executable = out, runfiles = runfiles)

execute_binary = rule(
    implementation = _execute_binary_impl,
    attrs = {
        "binary": attr.label(
            executable = True,
            mandatory = True,
            cfg = "target",
            doc = "The binary to be executed.",
        ),
    },
    doc = "",
    executable = True,
)

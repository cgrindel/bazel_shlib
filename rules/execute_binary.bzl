def _execute_binary_impl(ctx):
    bin_path = ctx.executable.binary.short_path
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
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
    doc = """\
This rule executes a binary target with the specified arguments. It generates
a Bash script that contains a call to the binary with the arguments embedded
in the script. This is useful when one wants to embed a call to a binary
target with a set of arguments in another rule.
""",
    executable = True,
)

def _execute_binary_impl(ctx):
    bin_path = ctx.executable.binary.short_path
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
        output = out,
        is_executable = True,
        content = """\
#!/usr/bin/env bash

# Set the RUNFILES_DIR. If an embedded binary is a sh_binary, it has trouble 
# finding the runfiles directory. So, we help.
[[ -f "${PWD}/../MANIFEST" ]] && export RUNFILES_DIR="${PWD}/.."

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

    # DEBUG BEGIN
    print("*** CHUCK runfiles.files.to_list(): ", runfiles.files.to_list())
    # DEBUG END

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
This rule executes a binary target with the specified arguments. It generates \
a Bash script that contains a call to the binary with the arguments embedded \
in the script. This is useful in the following situations:

1. If one wants to embed a call to a binary target with a set of arguments in \
another rule.

2. If you define a binary target that has a number of dependencies and other \
configuration values and you do not want to replicate it elsewhere.

Why Not Use A Macro?

You can use a macro which encapsulates the details of the xxx_binary \
declaration. However, the dependencies for the xxx_binary declaration must be \
visible anywhere the macro is used.
""",
    executable = True,
)

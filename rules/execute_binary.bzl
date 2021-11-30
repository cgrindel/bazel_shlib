def _execute_binary_impl(ctx):
    bin_path = ctx.executable.binary.short_path
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
        output = out,
        is_executable = True,
        content = """\
#!/usr/bin/env bash

set -euo pipefail

# Set the RUNFILES_DIR. If an embedded binary is a sh_binary, it has trouble 
# finding the runfiles directory. So, we help.
[[ -f "${PWD}/../MANIFEST" ]] && export RUNFILES_DIR="${PWD}/.."

args=()
""" + "\n".join([
            # Do not quote the arg. The values are already quoted. Adding the
            # quotes here will ruin the Bash substitution.
            """args+=( {arg} )""".format(arg = arg)
            for arg in ctx.attr.args
        ]) + """
# DEBUG BEGIN
echo >&2 "*** CHUCK execute_binary before args:"
for (( i = 0; i < ${#args[@]}; i++ )); do
  echo >&2 "*** CHUCK   ${i}: ${args[${i}]}"
done
# DEBUG END
[[ $# > 0 ]] && args+=( "${@}" )
if [[ ${#args[@]} > 0 ]]; then
""" + """\
  # DEBUG BEGIN
  echo >&2 "*** CHUCK execute_binary after args:"
  for (( i = 0; i < ${{#args[@]}}; i++ )); do
    echo >&2 "*** CHUCK   ${{i}}: ${{args[${{i}}]}}"
  done
  set -x
  # DEBUG END
  "{binary}" "${{args[@]}}"
  # "{binary}" "\"${{args[@]}}\""
  # "{binary}" "'${{args[@]}}'"
  # "{binary}" "${{args[@]@Q}}"
  # "{binary}" $(printf ' %q' "${{args[@]}}")
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

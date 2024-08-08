import sdk/cli
import sdk/clitools/filesystem

import std/[os, parseopt]

const
  templateroot = "workspace/template"
  `.gitignore` = staticRead templateroot/".gitignore"
  `bootstrap.nim` = staticRead templateroot/"bootstrap.nim"
  `bootstrapconf.nims` = staticRead templateroot/"bootstrapconf.nims"
  `config.nims` = staticRead templateroot/"config.nims"

proc new_workspace*(name = default Directory): 0..1 =
  var cli = CliContext(wizard: "wizard new-workspace*")
  cli.info "new-workspace is activated"

  if fileExists("project.godot"):
    cli.info "project.godot found"
  else:
    cli.failure "project.godot not found. Go project directory and retry."
    quit 1

  var workspace = string argcomplete_dialog(name, "workspace name")

  createDir workspace
  cli.success "create directory " & workspace

  writeFileWithDialog(workspace/"bootstrapconf.nims", `bootstrapconf.nims`)
  writeFileWithDialog(workspace/".gitignore", `.gitignore`)
  writeFileWithDialog(workspace/"config.nims", `config.nims`)
  writeFileWithDialog(workspace/"bootstrap.nim", `bootstrap.nim`)

  createDir workspace/"src"

proc dispatch_new_workspace*(opt: var OptParser) =
  next opt
  while true:
    case opt.kind
    of cmdLongOption, cmdShortOption:
      discard
    of cmdArgument:
      quit new_workspace(Directory opt.key)
    of cmdEnd:
      quit new_workspace()
    next opt
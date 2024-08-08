import std/os
import std/strutils
import std/parseopt

import sdk/opttools

import subcommands/library
import subcommands/workspace


let help = """
gdextwiz - CLI Godot&Nim game development assistant

Usage:

  gdextwiz [subcmd]

  subcmd:

    # library
    install
      : Install all dependencies to develop Godot GDExtension.
    uninstall
      : Uninstall all dependencies that installed through gdextwiz.
    upgrade
      : Uninstall current implementation and re-install latest.

    # workspace
    new-workspace (<name>)
      : Setup new workspace; then you could start development immediately.

    # iteration
    build (nim-option...) (<at=$PWD>)
      : Search bootstrap.nim from <at> to '/' and compile it.
      : If project.godot is found before bootstrap.nim,
      : build-all is called instead.
    build-all (nim-option...) (<at=$PWD>) (--depth:<depth=int.high>)
      : Search project.godot from <at> to '/' and compile all
      : bootstrap.nim under it.
      : This search for compile may recursive up to <depth>

Extention:

  Place "gdextwiz_COMMAND" executable on valid path to extend the command.
  For example, if "gdextwiz-launch" command is available on ~/.nimble/bin,
  you can execute it with type "gdextwiz plugin launch" or "gdextwiz launch".
"""


proc optnormalize(str: string): string =
  str.normalize.replace("-", "")

proc err_invalidOpt(p: var OptParser) =
  stderr.writeLine reverseOpt(p) & " is invalid."
  stdout.writeLine help
  quit 1

proc dispatch_addon(opt: var OptParser) =
  let subcmd = opt.key
  next opt

  var args: seq[string]
  while opt.kind != cmdEnd:
    args.add reverseOpt opt
    next opt

  if findExe("gdextwiz-" & subcmd) != "":
    quit execShellCmd("gdextwiz-" & subcmd & " " & args.join(" "))
  if findExe("gdextwiz_" & subcmd) != "":
    quit execShellCmd("gdextwiz-" & subcmd & " " & args.join(" "))

proc dispatch_subcmd(opt: var OptParser) =
  while true:
    case opt.kind
    of cmdLongOption, cmdShortOption:
      err_invalidOpt opt
    of cmdArgument:
      case opt.key.optnormalize
      of "install":
        dispatch_install(opt)
      of "uninstall":
        dispatch_uninstall(opt)
      of "upgrade":
        dispatch_upgrade(opt)
      of "build":
        discard
      of "buildall":
        discard
      of "newworkspace":
        dispatch_new_workspace(opt)
      else:
        dispatch_addon(opt)
    of cmdEnd:
      echo help
      quit 0
    next opt

when isMainModule:
  var opt = initOptParser()
  next opt

  dispatch_subcmd(opt)

import cloths

import std/parseopt
import std/os
import std/tables

import sdk
import subcommands/check/check

var commandtable: Table[string, tuple[command: proc(args: ArgList): int {.nimcall.}; help: proc(): string {.nimcall.}]]
commandtable["check"] = (check.main, check.help)

proc help: int =
  echo:
    weave Margin(thickness: 1):
      "Usage: minister subcommand [cmdopts]"
      weave multiline:
        "Subcommands:"
        weave indent2:
          for subs, (command, help) in commandtable:
            subs & "\t: " & help()
      weave multiline:
        "Function Extension"
        weave indent2:
          "Place \"minister_COMMAND\" executable on valid path or \"minister_COMMAND.nims\" on "
          "current directory to extend the command."
          "For example, \"minister_launch\" command is available on $HOME/.nimble/bin, "
          "you can execute it with type \"minister launch\"."

  1

proc route*(args: ArgList): tuple[subcommand: string; args: ArgList] =
  if args.len == 0:
    quit help()
  case args[0].kind
  of cmdArgument:
    result.subcommand = args[0].key
  else:
    quit help()
  result.args = args[1..^1]


when isMainModule:
  let (subcommand, args) = route getargs()

  try:
    quit commandtable[subcommand].command(args)
  except:
    if findExe("minister_" & subcommand) != "":
      quit execShellCmd("minister_" & subcommand & " " & $args)
    elif fileExists("minister_" & subcommand & ".nims"):
      quit execShellCmd("nim e minister_" & subcommand & ".nims " & $args)
    else:
      quit help()

import std/os
import std/tables

import sdk/cligentypes

import subcommands/library
import subcommands/workspace

when isMainModule:
  import cligen

  proc mergeParams(cmdNames: seq[string]; cmdLine = commandLineParams()): seq[string] = #{.raises: [], tags: [], forbids: [].} =
    result = cligen.mergeParams(cmdNames, cmdLine)
    if cmdNames == @["multi"]:
      let subcommand = cmdline[0]
      let args = cmdline[1..^1]
      if findExe("gdextwiz-" & subcommand) != "":
        quit execShellCmd("gdextwiz-" & subcommand & " " & args.join(" "))

  dispatchmulti(
    [ "multi",
      usage = """
$command - CLI Godot&Nim game development assistant

Usage:
  $command {SUBCMD}  [sub-command options & parameters]

where {SUBCMD} is one of:
$subcmds
$command {-h|--help} or with no args at all prints this message.
$command --help-syntax gives general cligen syntax help.
Run "$command {help SUBCMD|SUBCMD --help}" to see help for just SUBCMD.
Run "$command help" to get *comprehensive* help.${ifVersion}

Extention:
  Place "gdextwiz_COMMAND" executable on valid path to extend the command.
  For example, if "gdextwiz-launch" command is available on ~/.nimble/bin,
  you can execute it with type "gdextwiz plugin launch" or "gdextwiz launch"."""
    ],
    [library.install, help= library.HELP install],
    [library.uninstall, help= library.HELP uninstall],
    [workspace.new_workspace],
  )
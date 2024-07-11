import cloths

import std/os
import std/tables

import sdk
import subcommands/nimble
import subcommands/library

builtin_apps.add "help"

when isMainModule:
  import cligen
  import std/sequtils

  proc mergeParams(cmdNames: seq[string]; cmdLine = commandLineParams()): seq[string] = #{.raises: [], tags: [], forbids: [].} =
    result = cligen.mergeParams(cmdNames, cmdLine)
    if cmdNames == @["multi"]:
      let builtin_apps = builtin_apps.mapIt(optionNormalize(it))
      if result.len > 0 and optionNormalize(result[0]) notin builtin_apps:
        let subcommand = cmdline[0]
        let args = cmdline[1..^1]
        if findExe("minister-" & subcommand) != "":
          quit execShellCmd("minister-" & subcommand & " " & args.join(" "))

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
  Place "minister_COMMAND" executable on valid path to extend the command.
  For example, if "minister-launch" command is available on ~/.nimble/bin,
  you can execute it with type "minister plugin launch" or "minister launch"."""
    ],
    [nimble.check],
    [library.install, help= library.HELP install],
    [library.uninstall, help= library.HELP uninstall],
  )
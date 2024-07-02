import std/os

import sdk

proc help*: string =
  "execute \"nimble check\""


proc main*(args: ArgList): int =
  execShellCmd("nimble check")

when isMainModule:
  quit main(getargs())
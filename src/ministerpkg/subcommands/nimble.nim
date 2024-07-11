import std/os


import sdk

builtin_apps.add "check"

proc check*(): int =
  ## execute "nimble check"
  execShellCmd("nimble check")

when isMainModule:
  import cligen
  dispatch check
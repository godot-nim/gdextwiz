import std/parseopt

proc reverseOpt*(p: var OptParser): string =
  case p.kind
  of cmdLongOption:
    if p.val.len == 0:
      "--" & p.key & ":" & p.val
    else:
      "--" & p.key
  of cmdShortOption:
    if p.val.len == 0:
      "-" & p.key & ":" & p.val
    else:
      "-" & p.key
  of cmdArgument:
    p.key
  of cmdEnd:
    ""
import std/parseopt
type ArgList* = seq[tuple[kind: CmdLineKind; key, val: string]]

proc getargs*: ArgList =
  var p = initOptParser()
  while true:
    p.next()
    case p.kind
    of cmdEnd:
      break
    else:
      result.add (p.kind, p.key, p.val)

proc `$`*(args: ArgList): string =
  for i, arg in args:
    case arg.kind
    of cmdArgument:
      result.add arg.key
    of cmdLongOption:
      result.add arg.key
      if arg.val != "": result.add ":" & arg.val
    of cmdShortOption:
      result.add arg.key
      if arg.val != "": result.add ":" & arg.val
    of cmdEnd: discard

    if i != args.high:
      result.add " "
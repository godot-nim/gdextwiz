
import cligen

type Directory* = distinct string
proc argHelp*(dfl: Directory; a: var ArgcvtParams): seq[string] =
  result = dfl.string.argHelp(a)
  result[1] = $Directory
proc argParse*(dst: var Directory; dfl: Directory; a: var ArgcvtParams): bool =
  result = dst.string.argParse(dfl.string, a)
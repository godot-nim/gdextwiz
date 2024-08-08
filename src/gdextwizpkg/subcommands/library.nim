import std/os
import std/strformat

const path = (
  gdext: "https://github.com/godot-nim/gdext-nim",
)

proc install*(): 0..1 =
  ## Install all dependencies to develop Godot GDExtension
  execShellCmd &"nimble install {path.gdext}"

proc uninstall*(self= false): 0..1 =
  ## Uninstall all dependencies that installed through gdextwiz.
  var pkglist = @["gdext", "gdextgen", "gdextcore"]
  if self: pkglist.add ["gdextwiz"]

  for pkg in pkglist:
    while execShellCmd(&"nimble uninstall -y {pkg}") == 0: discard

proc upgrade*(self= false): 0..1 =
  ## uninstall current libraries and re-install it.
  uninstall(self= self) and install()

template HELP*(pro: proc): untyped =
  when pro == install: { }
  elif pro == uninstall: { "self": "includes gdextwiz itself"}
  elif pro == upgrade: { "self": "includes gdextwiz itself"}
  else: { }


when isMainModule:
  import cligen
  dispatch install
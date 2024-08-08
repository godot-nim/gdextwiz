import std/os
import std/strformat
import std/strutils

const path = (
  gdext: "https://github.com/godot-nim/gdext-nim",
)

proc install*(): 0..1 =
  ## Install all dependencies to develop Godot GDExtension
  execShellCmd &"nimble install {path.gdext}"

proc uninstall*(): 0..1 =
  ## Uninstall all dependencies that installed through gdextwiz.

  let pkglist = @[
    "gdext",
    "gdextgen",
    "gdextcore",
    "gdextwiz",
    ]
  let pkg = pkglist.join(" ")

  execShellCmd(&"nimble uninstall -i {pkg}")

proc upgrade*(): 0..1 =
  ## uninstall current libraries and re-install it.
  uninstall() and install()

template HELP*(pro: proc): untyped =
  when pro == install: { }
  elif pro == uninstall: { }
  elif pro == upgrade: { }
  else: { }


when isMainModule:
  import cligen
  dispatch install
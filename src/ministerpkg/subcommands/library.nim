import std/os
import std/strformat

import sdk

const path = (
  coronation: "https://github.com/godot-nim/coronation",
  gdextcore: "https://github.com/godot-nim/gdextcore",
  gdext: "https://github.com/godot-nim/gdextshell",
)

builtin_apps.add "library"

proc uninstall*(): 0..1 =
  ## Uninstall all dependencies that installed through minister.
  execShellCmd &"""
nimble uninstall -y coronation
nimble uninstall -y gdext
nimble uninstall -y gdextgen
nimble uninstall -y gdextcore
"""

proc install*(godotbin: string = "godot"): 0..1 =
  ## Install all dependencies to use godot.
  execShellCmd &"""
{godotbin} --dump-extension-api
nimble install {path.coronation}
coronation --apisource:extension_api.json --outdir:. --package:gdextgen --version-control:off
nimble install {path.gdextcore}
cd gdextgen && nimble install && cd -
nimble install {path.gdext}
rm -rf gdextgen extension_api.json
"""

template HELP*(pro: proc): untyped =
  when pro == install: { }
  elif pro == uninstall: { }
  else: { }


when isMainModule:
  import cligen
  dispatch install
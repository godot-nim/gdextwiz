import std/os
import std/strformat

import sdk

const path = (
  coronation: "https://github.com/godot-nim/coronation",
  godotcore: "https://github.com/godot-nim/godotcore",
  godot: "https://github.com/godot-nim/godot",
)

builtin_apps.add "library"

proc uninstall*(): 0..1 =
  ## Uninstall all dependencies that installed through minister.
  execShellCmd &"""
nimble uninstall -y coronation
nimble uninstall -y godot
nimble uninstall -y godotgen
nimble uninstall -y godotcore
"""

proc install*(godotbin: string = "godot"): 0..1 =
  ## Install all dependencies to use godot.
  execShellCmd &"""
{godotbin} --dump-extension-api
nimble install {path.coronation}
coronation --apisource:extension_api.json --outdir:. --package:godotgen --version-control:off
nimble install {path.godotcore}
cd godotgen && nimble install && cd -
nimble install {path.godot}
rm -rf godotgen extension_api.json
"""

template HELP*(pro: proc): untyped =
  when pro == install: { }
  elif pro == uninstall: { }
  else: { }


when isMainModule:
  import cligen
  dispatch install
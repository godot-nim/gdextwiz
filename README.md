# godot-nim/gdextwiz

CLI Godot&Nim game development assistant

## Install

```bash
nimble install https://github.com/godot-nim/gdextwiz
```

## Commands

### gdextwiz install

Install all dependencies to use godot.

### gdextwiz uninstall

Uninstall all dependencies that installed through gdextwiz.

### gdextwiz new-workspace

Generate a workspace template, run it in the same directory as project.godot and follow the wizard's directions.

A workspace is the smallest unit of build of an extension.
Each Nim extension belongs to  workspaces.
By editing workspace/bootstrap.nim, you can decide how to handle extensions and classes.  
For detailed usage, please refer to the [demo](https://github.com/godot-nim/demo) or the corresponding [wiki](https://github.com/godot-nim/docs/wiki) page.
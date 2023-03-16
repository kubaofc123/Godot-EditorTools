# Godot-EditorTools
Compatible with Godot 4.x

## Description
This adds `Editor Mode` in the bottom panel, which will contain different editor modes for helping in editing scenes.

![image](https://user-images.githubusercontent.com/17231482/225731162-14b013e4-fc29-4643-ab0a-e89d0daee1d9.png)

## How to install
- Clone repository to your `{project-path}/addons/{name-this-plugin-somehow}` and activate the plugin in `Project->Project Settings->Plugins->Editor Extenstions`, then restart the editor

or
- Download zip and extract it to `{project-path}/addons/` and activate the plugin in `Project->Project Settings->Plugins->Editor Extenstions`, then restart the editor

## How to use
- `Mesh Placer` - Select any `Node3D` type-derived object in Scene tab. This will be the parent for added scenes by this mode. In object path copy path to the scene you need to spawn. In this mode you cannot select any objects in the viewport.

## Limitations

#### Mesh Placer mode
- Currently only tracing for `3D Physics` -> `Layer1`
- `Continous` mode not working
- `Align to normal` option not working
- Random rotation options not working
- When creating a new scene, which has no root node set, `Mesh Placer` does not work until root node is set, scene saved and editor switched to another scene and back
## Roadmap

#### Mesh Placer mode
- Add support and widget for bitmasking all `3D Physics` layers
- Add support for broken toggle options

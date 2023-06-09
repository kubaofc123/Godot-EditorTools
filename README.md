# Godot-EditorTools
Compatible with Godot 4.x

## Description
This adds `Editor Mode` in the bottom panel, which will contain different editor modes for helping in editing scenes.

![image](https://user-images.githubusercontent.com/17231482/225731162-14b013e4-fc29-4643-ab0a-e89d0daee1d9.png)

Currently supported modes:
- `Regular` - no change to editor
- `Mesh Placer` - allows for quick, repeatable object placement in the world using mouse
![image](https://user-images.githubusercontent.com/17231482/225785870-f1077d34-007b-4da4-abbe-1c2a49944ddc.png)


## How to install
- Clone repository to your `{project-path}/addons/{name-this-plugin-somehow}` and activate the plugin in `Project->Project Settings->Plugins->Editor Extenstions`, then restart the editor

or
- Download zip and extract it to `{project-path}/addons/` and activate the plugin in `Project->Project Settings->Plugins->Editor Extenstions`, then restart the editor

If you use Git, you can add this repository as a submodule in order to receive automatic updates

## How to use
- `Mesh Placer` - Select any `Node3D` type-derived object in Scene tab. This will be the parent for added scenes by this mode. In `Object path` copy path to the scene you need to spawn. In this mode you cannot select any objects in the viewport while an object in `Scene` is already selected.

## Limitations

#### Mesh Placer mode
- Currently only tracing for `3D Physics` -> `Layer1`
- When creating a new scene, which has no root node set, `Mesh Placer` does not work until root node is set, scene saved and editor switched to another scene and back
- Not working with Undo/Redo system yet
- Scenes are not marked as "dirty" when adding meshes

## Roadmap

#### Mesh Placer mode
- Add support and widget for bitmasking all `3D Physics` layers
- Add area paint tool with adjustable area size
- Support for list of items to spawn, which are chosen at random at defined ratios
- Add Undo/Redo actions to History tab

Feel free to add suggestions for new modes!

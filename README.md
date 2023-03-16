# Godot-EditorTools
Compatible with Godot 4.x

## Description
This adds `Editor Mode` in the bottom panel, which will contain different editor modes for helping in editing scenes.

![image](https://user-images.githubusercontent.com/17231482/225731162-14b013e4-fc29-4643-ab0a-e89d0daee1d9.png)

## How to install
Clone repository to your `{project-path}/addons/{this-plugin-name}` and activate the plugin in `Project->Project Settings->Plugins->Editor Extenstions`

## How to use
- `Mesh Placer` - Select any Node3D type-derived object in Scene tab. This will be the parent for added scenes by this mode. In object path copy path to the scene you need to spawn. In this mode you cannot select any objects in the viewport.

## Limitations

- `Mesh Placer` - currently only tracing for `3D Physics` -> `Layer1`

## To-Do

- `Mesh Placer` - add support and widget for bitmasking all `3D Physics` layers

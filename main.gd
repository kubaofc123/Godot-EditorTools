@tool
extends EditorPlugin

var toolbar = null
var selectedObject = null
var currentRoot
var eds = get_editor_interface().get_selection()
var selected_node

func _enter_tree():
	print("Editor Mode: _enter_tree()")
	var toolbar_ref = load("res://addons/editor_extensions/toolbar.tscn")
	toolbar = toolbar_ref.instantiate()
	add_control_to_bottom_panel(toolbar, "Editor Mode")
	scene_changed.connect(_on_scene_changed)
	eds.selection_changed.connect(_on_selection_changed)

func _exit_tree():
	print("Editor Mode: _exit_tree()")
	#remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, toolbar)
	remove_control_from_bottom_panel(toolbar)
	toolbar.queue_free()

func _make_visible(visible : bool):
	return
	print("Editor Mode: _make_visible() : ", visible)
	if visible:
		toolbar.visible = true
	else:
		toolbar.visible = false

func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int:
	if toolbar.get_editor_mode() != 0:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var hitResult = ray_trace(viewport_camera)
				if hitResult.is_empty():
					return EditorPlugin.AFTER_GUI_INPUT_PASS
				print (toolbar.objectRef)
				var newObjectInstance = toolbar.objectRef.instantiate()
				if is_instance_valid(newObjectInstance):
					print("Editor Mode: newObjectInstance is valid: ", newObjectInstance)
				get_tree().get_edited_scene_root().add_child(newObjectInstance)
				#selected_node.add_child(newObjectInstance)
				print("Editor Mode: Setting instance owner to: ", get_tree().get_edited_scene_root())
				newObjectInstance.set_owner(get_tree().get_edited_scene_root())
				newObjectInstance.set_owner(selected_node)
				newObjectInstance.global_transform.origin = hitResult.position
				EditorPlugin.AFTER_GUI_INPUT_STOP
				#else:
				#	print("Editor Mode: objectRef is not valid")
				print("Editor Mode: Input: Stop")
		return EditorPlugin.AFTER_GUI_INPUT_PASS
	return EditorPlugin.AFTER_GUI_INPUT_PASS

func _handles(object):
	var castObject = object as Node3D
	if is_instance_valid(castObject):
		return true
	return false

func _on_scene_changed(node : Node):
	print("Editor Mode: _on_scene_changed: ", node)
	currentRoot = node

func ray_trace(viewport_camera: Camera3D) -> Dictionary:
	var sceneRoot = get_tree().get_edited_scene_root() as Node3D
	if !is_instance_valid(sceneRoot):
		return Dictionary()
	var mousePos = get_viewport().get_mouse_position()
	var rayLength = 1000
	var from = viewport_camera.project_ray_origin(mousePos)
	var to = from + viewport_camera.project_ray_normal(mousePos) * rayLength
	var space = sceneRoot.get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayQuery.collision_mask = 1
	var hitResult = space.intersect_ray(rayQuery)
	return hitResult

func _on_selection_changed():
	# Returns an array of selected nodes
	var selected = eds.get_selected_nodes() 
	
	if not selected.is_empty():
		# Always pick first node in selection
		var selected_node = selected[0]
		print("Editor Mode: Selected node: ", selected_node)
	else:
		selected_node = null

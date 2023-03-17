@tool
extends EditorPlugin

var toolbar = null
var selectedObject = null
var currentRoot
var eds = get_editor_interface().get_selection()
var selected_node
var LMB_down : bool = false
var rng

func _enter_tree():
	# Exit conditions
	if !Engine.is_editor_hint():
		return
		
	var toolbarString = self.get_script().get_path().get_base_dir() + "/toolbar.tscn"
	var toolbarScript = load(self.get_script().get_path().get_base_dir() + "/toolbar.gd")
	var toolbar_ref = load(toolbarString)
	toolbar = toolbar_ref.instantiate()
	toolbar.set_script(toolbarScript)
	add_control_to_bottom_panel(toolbar, "Editor Mode")
	
	# Handle toolbar script and signals
	scene_changed.connect(_on_scene_changed)
	eds.selection_changed.connect(_on_selection_changed)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer/HBoxContainer2/CB_RandX").toggled.connect(toolbar._on_randX_toggled)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer/HBoxContainer3/CB_RandY").toggled.connect(toolbar._on_randY_toggled)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer/HBoxContainer4/CB_RandZ").toggled.connect(toolbar._on_randZ_toggled)
	toolbar.get_node("Modes/Mode_MeshPlacer/HBoxContainer/CB_Align").toggled.connect(toolbar._on_align_to_normal_toggled)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer2/HBoxContainer/OptionButton_PlaceMode").item_selected.connect(toolbar._on_mesh_placer_place_mode_selected)
	# Create RNG
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _exit_tree():		
	remove_control_from_bottom_panel(toolbar)
	toolbar.queue_free()

func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int:	
	# Exit conditions
	if !Engine.is_editor_hint():
		return EditorPlugin.AFTER_GUI_INPUT_PASS

	# MESH PLACER Mode
	if toolbar.currentEditorMode == toolbar.EditorModeEnum.MESH_PLACER:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				var hitResult = ray_trace(viewport_camera)
				if hitResult.is_empty():
					return EditorPlugin.AFTER_GUI_INPUT_PASS
				spawn_object(hitResult)
				return EditorPlugin.AFTER_GUI_INPUT_STOP
		return EditorPlugin.AFTER_GUI_INPUT_PASS
	
	return EditorPlugin.AFTER_GUI_INPUT_PASS

func _handles(object):
	# Exit conditions
	if !Engine.is_editor_hint():
		return false
		
	var castObject = object as Node3D
	if is_instance_valid(castObject):
		return true
	return false

func _on_scene_changed(node : Node):
	# Exit conditions
	if !Engine.is_editor_hint():
		return
		
	#print("Editor Mode: _on_scene_changed: ", node)
	currentRoot = node

func ray_trace(viewport_camera: Camera3D) -> Dictionary:
	# Exit conditions
	var sceneRoot = get_tree().get_edited_scene_root() as Node3D
	if !is_instance_valid(sceneRoot):
		return Dictionary()
		
	var mousePos = get_viewport().get_mouse_position()
	mousePos = viewport_camera.get_viewport().get_mouse_position()
	var rayLength = 10000000000
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
	# Exit conditions
	if !Engine.is_editor_hint():
		return
		
	# Returns an array of selected nodes
	var selected = eds.get_selected_nodes() 
	
	if not selected.is_empty():
		# Always pick first node in selection
		var selected_node = selected[0]
		#print("Editor Mode: Selected node: ", selected_node)
	else:
		selected_node = null

func spawn_object(hitResult : Dictionary):
	# Spawn object
	var newObjectInstance = toolbar.objectRef.instantiate()
	get_editor_interface().get_selection().get_selected_nodes()[0].add_child(newObjectInstance)
	newObjectInstance.set_owner(get_tree().get_edited_scene_root())

	# Handle object normal alignment
	if toolbar.balignToNormal:
		var trans := Transform3D()
		if abs(hitResult.normal.z) == 1:
			trans.basis.x = Vector3(1,0,0)
			trans.basis.y = Vector3(0,0,hitResult.normal.z)
			trans.basis.z = Vector3(0,hitResult.normal.z,0)
		else:
			trans.basis.y = hitResult.normal
			trans.basis.x = hitResult.normal.cross(trans.basis.z)
			trans.basis.z = trans.basis.x.cross(hitResult.normal)
			trans.basis = trans.basis.orthonormalized()
		newObjectInstance.global_transform = trans

	# Handle object location
	newObjectInstance.global_transform.origin = hitResult.position

	# Handle object rotation
	if toolbar.brandX or toolbar.brandY or toolbar.brandZ:
		var frandX : float = 0.0
		var frandY : float = 0.0
		var frandZ : float = 0.0
		if toolbar.brandX:
			frandX = rng.randf_range(0, 360)
		if toolbar.brandY:
			frandY = rng.randf_range(0, 360)
		if toolbar.brandZ:
			frandZ = rng.randf_range(0, 360)
		if toolbar.balignToNormal:
			newObjectInstance.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(frandX))
			newObjectInstance.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(frandY))
			newObjectInstance.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(frandZ))
		else:	
			newObjectInstance.global_rotation = Vector3(frandX, frandY, frandZ)
	
func _physics_process(delta: float):
	pass
	#if toolbar.currentEditorMode == toolbar.EditorModeEnum.MESH_PLACER

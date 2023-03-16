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
		
	#print("Editor Mode: _enter_tree()")
	var toolbarString = self.get_script().get_path().get_base_dir() + "/toolbar.tscn"
	var toolbarScript = load(self.get_script().get_path().get_base_dir() + "/toolbar.gd")
	var toolbar_ref = load(toolbarString)
	toolbar = toolbar_ref.instantiate()
	toolbar.set_script(toolbarScript)
	add_control_to_bottom_panel(toolbar, "Editor Mode")
	
	#Modes/Mode_MeshPlacer/HBoxContainer/CB_Align
	
	# Handle toolbar script and signals
	scene_changed.connect(_on_scene_changed)
	eds.selection_changed.connect(_on_selection_changed)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer/HBoxContainer2/CB_RandX").toggled.connect(toolbar._on_randX_toggled)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer/HBoxContainer3/CB_RandY").toggled.connect(toolbar._on_randY_toggled)
	toolbar.get_node("Modes/Mode_MeshPlacer/VBoxContainer/HBoxContainer4/CB_RandZ").toggled.connect(toolbar._on_randZ_toggled)
	#toolbar.check_randY.toggled.connect(toolbar._on_randY_toggled)
	#toolbar.check_randZ.toggled.connect(toolbar._on_randZ_toggled)
	
	# Create RNG
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _exit_tree():
	# Exit conditions
	if !Engine.is_editor_hint():
		return
		
	#print("Editor Mode: _exit_tree()")
	remove_control_from_bottom_panel(toolbar)
	toolbar.queue_free()

func _make_visible(visible : bool):
	return
	
	# Exit conditions
	#if !Engine.is_editor_hint():
	#	return
	
	#print("Editor Mode: _make_visible() : ", visible)
	#if visible:
	#	toolbar.visible = true
	#else:
	#	toolbar.visible = false

func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int:
	#print("Editor Mode: _forward_3d_gui_input()")
	
	# Exit conditions
	if !Engine.is_editor_hint():
		return EditorPlugin.AFTER_GUI_INPUT_PASS
		
	if toolbar.get_editor_mode() != 0:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				var hitResult = ray_trace(viewport_camera)
				if hitResult.is_empty():
					return EditorPlugin.AFTER_GUI_INPUT_PASS
				#print (toolbar.objectRef)
				#if !toolbar.objectRef:
				#	return EditorPlugin.AFTER_GUI_INPUT_PASS
				
				# Spawn object
				var newObjectInstance = toolbar.objectRef.instantiate()
				get_editor_interface().get_selection().get_selected_nodes()[0].add_child(newObjectInstance)
				newObjectInstance.set_owner(get_tree().get_edited_scene_root())
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
					#print("Editor Mode: randX: ", toolbar.brandX, ", frandX: ", frandX)
					#print("Editor Mode: randY: ", toolbar.brandY, ", frandY: ", frandY)
					#print("Editor Mode: randZ: ", toolbar.brandZ, ", frandZ: ", frandZ)
					newObjectInstance.global_rotation = Vector3(frandX, frandY, frandZ)
					
				#print("Editor Mode: Input: Stop")
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
	var rayLength = 100000
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

#func _physics_process(delta: float):
	#if toolbar.get_node("OptionButton_PlaceMode") == 1:
		#pass
		#print("AAAAAAA")

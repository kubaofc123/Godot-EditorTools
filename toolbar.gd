@tool
extends HBoxContainer

# Widget references
@onready var optionsButton = $OptionButton
@onready var modes = $Modes
@onready var mode_meshplacer = $Modes/Mode_MeshPlacer
@onready var mesh_ref_textbox = $Modes/Mode_MeshPlacer/VBoxContainer2/HBoxContainer2/MeshRef
@onready var vbox_frequency = $Modes/Mode_MeshPlacer/VBox_Frequency
@onready var frequency_spinbox = $Modes/Mode_MeshPlacer/VBox_Frequency/SpinBox

var objectRef
var brandX : bool = false
var brandY : bool = false
var brandZ : bool = false
var balignToNormal : bool = false
var currentEditorMode : EditorModeEnum = EditorModeEnum.REGULAR
var currentMeshPlacerPlaceMode : MeshPlacerPlaceModeEnum = MeshPlacerPlaceModeEnum.SINGLE

# Enums
enum EditorModeEnum {REGULAR = 0, MESH_PLACER = 1}
enum MeshPlacerPlaceModeEnum {SINGLE = 0, CONTINOUS = 1}

func _ready():
	modes.visible = false
	_on_mesh_placer_place_mode_selected(0)

func _on_option_button_item_selected(index):
	currentEditorMode = index
	
	if currentEditorMode == EditorModeEnum.REGULAR:
		modes.visible = false
		return
		
	if currentEditorMode == EditorModeEnum.MESH_PLACER:
		modes.visible = true
		mode_meshplacer.visible = true
		if mode_meshplacer.get_node("VBoxContainer2/HBoxContainer/Label_PlaceMode").get_total_character_count() != 0:
			objectRef = load(mesh_ref_textbox.text)
		else:
			objectRef = null		

func _on_mesh_ref_text_submitted(new_text):
	if mode_meshplacer.get_node("VBoxContainer2/HBoxContainer/Label_PlaceMode").get_total_character_count() != 0:
			objectRef = load(mesh_ref_textbox.text)
			#print("Editor Mode Toolbar: Mesh reference submitted: ", objectRef)
	else:
			objectRef = null

func _on_mesh_ref_text_changed(new_text):
	if mode_meshplacer.get_node("VBoxContainer2/HBoxContainer/Label_PlaceMode").get_total_character_count() != 0:
			objectRef = load(mesh_ref_textbox.text)
			#print("Editor Mode Toolbar: Mesh reference submitted: ", objectRef)
	else:
			objectRef = null

func _on_randX_toggled(button_pressed : bool):
	#print("Editor Mode Toolbar: _on_randX_toggled():", button_pressed)
	brandX = button_pressed

func _on_randY_toggled(button_pressed : bool):
	#print("Editor Mode Toolbar: _on_randY_toggled():", button_pressed)
	brandY = button_pressed
	
func _on_randZ_toggled(button_pressed : bool):
	#print("Editor Mode Toolbar: _on_randZ_toggled():", button_pressed)
	brandZ = button_pressed

func _on_align_to_normal_toggled(button_pressed : bool):
	balignToNormal = button_pressed

func _on_mesh_placer_place_mode_selected(index : int):
	currentMeshPlacerPlaceMode = index
	if currentMeshPlacerPlaceMode == MeshPlacerPlaceModeEnum.SINGLE:
		vbox_frequency.visible = false
	if currentMeshPlacerPlaceMode == MeshPlacerPlaceModeEnum.CONTINOUS:
		vbox_frequency.visible = true

@tool
extends HBoxContainer

@onready var optionsButton = $OptionButton
@onready var modes = $Modes
@onready var mode_meshplacer = $Modes/Mode_MeshPlacer
@onready var mesh_ref_textbox = $Modes/Mode_MeshPlacer/VBoxContainer2/HBoxContainer2/MeshRef
var objectRef

func _ready():
	modes.visible = false

func _on_option_button_item_selected(index):
	#print("Editor Mode Toolbar: _on_option_button_item_selected():", index)
	if index == 0:
		modes.visible = false
		return
		
	if index == 1:
		modes.visible = true
		mode_meshplacer.visible = true
		if mode_meshplacer.get_node("VBoxContainer2/HBoxContainer/Label_PlaceMode").get_total_character_count() != 0:
			objectRef = load(mesh_ref_textbox.text)
		else:
			objectRef = null		

func get_editor_mode() -> int:
	return optionsButton.selected

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

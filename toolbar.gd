# Copyright 2023 Firewind Games. All rights reserved.

@tool
extends HBoxContainer

@onready var optionsButton = $OptionButton
var objectRef

func _ready():
	$Modes.visible = false

func _on_option_button_item_selected(index):
	print("Editor Mode Toolbar: _on_option_button_item_selected():", index)
	if index == 0:
		$Modes.visible = false
		return
		
	if index == 1:
		$Modes.visible = true
		$Modes/Mode_MeshPlacer.visible = true
		if $Modes/Mode_MeshPlacer/Label_PlaceMode.get_total_character_count() != 0:
			objectRef = load($Modes/Mode_MeshPlacer/MeshRef.text)
		else:
			objectRef = null
		

func get_editor_mode() -> int:
	return $OptionButton.selected


func _on_mesh_ref_text_submitted(new_text):
	if $Modes/Mode_MeshPlacer/Label_PlaceMode.get_total_character_count() != 0:
			objectRef = load($Modes/Mode_MeshPlacer/MeshRef.text)
			print("Editor Mode Toolbar: Mesh reference submitted: ", objectRef)
	else:
			objectRef = null

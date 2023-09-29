tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Beholder",
					"Camera",
					preload("beholder.gd"),
					preload("beholder.svg"))


func _exit_tree():
	remove_custom_type("Beholder")

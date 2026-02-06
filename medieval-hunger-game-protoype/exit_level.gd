extends Area3D

const FILE_PATH_BEGIN = "res://start_menu.tscn"


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(FILE_PATH_BEGIN)

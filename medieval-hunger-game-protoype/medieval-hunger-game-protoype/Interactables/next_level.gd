extends Interactable

const FILE_PATH_BEGIN = "res://Levels/Maze_"


func _ready() -> void:
	pass
	#if PlayerManager.player.position != Vector3(0, 0, 0):
		#PlayerManager.player.position = PlayerManager.position + Vector3(0, 0, 0)


func _on_interacted(body: Variant) -> void:
	PlayerManager.position = PlayerManager.player.position
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = FILE_PATH_BEGIN + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)




func _on_level_layout_level_changed(level_name: Variant) -> void:
	emit_signal("level_change", level_name)

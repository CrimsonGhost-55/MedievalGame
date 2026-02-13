extends Interactable

const FILE_PATH_BEGIN = "res://Game UI/start_menu.tscn"

func _on_interacted(body: Variant) -> void:
	get_tree().change_scene_to_file(FILE_PATH_BEGIN)

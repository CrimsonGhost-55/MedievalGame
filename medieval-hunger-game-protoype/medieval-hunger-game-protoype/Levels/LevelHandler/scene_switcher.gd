extends Node

func _ready() -> void:
	$Maze1.connect("level_changed", self, "handle_level_changed")


func handle_level_changed(current_level_name: String):
	pass

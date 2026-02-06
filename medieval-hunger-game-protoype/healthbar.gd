extends Control


@onready var health = $HealthProgressBar

func _ready() -> void:
	health.value = health.max_value

extends Control

@onready var hunger = $HungerProgressBar

@export var player: CharacterBody3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hunger.value = hunger.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_hunger(change_value: int):
	hunger.value += change_value
	GameState.set_value("hunger", hunger.value)
	hunger.value = clamp(hunger.value, 0, 100)

func _on_hunger_timer_timeout() -> void:
	change_hunger(-2)

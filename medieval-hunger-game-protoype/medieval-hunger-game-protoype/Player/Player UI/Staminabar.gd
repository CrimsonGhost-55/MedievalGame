extends Control

@onready var stamina = $TextureProgressBar
var can_regen = false
var time_to_wait = 1.5
var s_timer = 0
var can_start_stimer = true
var base_max = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stamina.value = stamina.max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_regen == false && stamina.value != base_max or stamina.value == 0:
		can_start_stimer = true
		if can_start_stimer:
			s_timer += delta
			if s_timer >= time_to_wait:
				can_regen = true
				can_start_stimer = false
				s_timer = 0
	
	if stamina.value == base_max:
		can_regen = false
	
	if can_regen == true:
		stamina.value += 0.5
		can_start_stimer = false
		s_timer = 0
	

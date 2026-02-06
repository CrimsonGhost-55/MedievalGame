extends Node3D

@onready var raycast = %SeeCast

var sensitivity = 0.2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))

#func _process(delta: float):
	#var object = raycast.get_collider()
	#if object.is_in_group("pickable"):
		#if Input.is_action_pressed("pick_up"):
			#object.global_position = hand.global_position
			#object.global_rotation = hand.global_rotation
			#object.collision_layer = 2

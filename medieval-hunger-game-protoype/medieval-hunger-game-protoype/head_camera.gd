extends Node3D



var sensitivity = 0.2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		

#func _process(delta: float):
	#var object = raycast.get_collider()
	#if object.is_in_group("pickable"):
		#if Input.is_action_pressed("pick_up"):
			#object.global_position = hand.global_position
			#object.global_rotation = hand.global_rotation
			#object.collision_layer = 2

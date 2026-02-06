extends Node3D

@export var value: int = 1

func pick_up():
	print("You can pick up this food")
	queue_free()

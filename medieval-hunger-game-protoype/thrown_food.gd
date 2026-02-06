extends RigidBody3D

@onready var timer = $Timer
@export var value: int = 1

func pick_up():
	print("You can pick up this food")
	queue_free()



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		timer.start()


func _on_timer_timeout() -> void:
	queue_free()

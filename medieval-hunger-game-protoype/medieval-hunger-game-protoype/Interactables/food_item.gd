extends Interactable
signal food_amount(value)



func _on_interacted(body: Variant) -> void:
	$AudioStreamPlayer3D.play()
	emit_signal("food_amount", 1)
	queue_free()

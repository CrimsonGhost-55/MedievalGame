extends RayCast3D

@onready var prompt = $Prompt

func _physics_process(delta: float) -> void:
	##Sets the text to nothing when the raycast hovers over nothing interactable
	prompt.text = ""
	
	if is_colliding():
		##get_collider allows me to grab info from what the raycast is colliding on
		var collider = get_collider()
		##Calls from the interactable class name to grab the vars in the code
		if collider is Interactable:
			prompt.text = collider.get_prompt()
			
			if Input.is_action_just_pressed(collider.prompt_input):
				collider.interact(owner)
